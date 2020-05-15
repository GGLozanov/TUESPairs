import React, { Component } from 'react';
import { FormControl, Button, Col, Image, Form, Row, Alert, InputGroup, ButtonGroup } from 'react-bootstrap';
import { withCurrentUser } from '../../Authentication/context';
import { compose } from 'recompose';
import { withFirebase } from '../../Firebase';
import { withAuthorization } from '../../Authentication';
import { withRouter } from 'react-router-dom';
import * as ROUTES from '../../../constants/routes';
import { Link } from 'react-router-dom';
import { PasswordChangeLink } from '../ChangeForms/passwordchange';
import rgbHex from 'rgb-hex';
import log from '../../../constants/logger.jsx';
import Loading from '../../../constants/loading';

const StudentInfo = () => (
    <div>
        <PersonalInfo />
    </div>
)

class EditPersonalInfo extends Component{
    constructor(props){
        super(props);


        this.state = {
            username: this.props.authUser.username,
            GPA: this.props.authUser.GPA,
            photoURL: this.props.authUser.photoURL,
            email: this.props.authUser.email,
            tags: [],
            tagIDs: [],
            error: '',
            message: '',
            users: null,
            loading: false,
            show: false,
        };
    }

    componentDidMount(){
        let currentUser = this.props.authUser;
        this.setState({ loading: true });
    
        this.unsubscribe = this.props.firebase.user(currentUser.uid).get()
        .then(snapshot => {
            const currentUser = this.props.firebase.getUserFromSnapshot(snapshot);

            this.setState({ photoURL: currentUser.photoURL, email: currentUser.email, tagIDs: currentUser.tagIDs, loading: false });
        }).then(() => {
            this.tagProvider = this.props.firebase.tags()
            .onSnapshot(snapshot => {
                let tags = [];

                snapshot.forEach(doc => 
                    tags.push({ ...doc.data(), tid: doc.id }),
                );

                this.setState({ tags, loading: false });
            });
        })
    }


    setChecked = event => {
        let tagIDs = this.state.tagIDs;
        const tagColor = event.target.value;
        const tagID = event.target.name;

        if(event.target.style.backgroundColor === '') {
            event.target.style.backgroundColor = 'rgb(252, 152, 0)';
        }

        let bgColor = '#' + rgbHex(event.target.style.backgroundColor);

        if(bgColor === tagColor) {
            event.target.style.backgroundColor = 'rgb(252, 152, 0)';
            var index = tagIDs.indexOf(tagID);
            if (index !== -1) tagIDs.splice(index, 1);
        } else {
            event.target.style.backgroundColor = tagColor;
            tagIDs.push(tagID);
        }

        this.setState({ tagIDs });
    }

    onSubmit = event => {
        const { username, email, GPA, tagIDs} = this.state;

        const currentUser = this.props.authUser;

        this.props.firebase.db.collection("users").doc(currentUser.uid).set({
            username: username,
            GPA: parseFloat(GPA),
            email: email,
            tagIDs: tagIDs,
        }, {merge: true})
        .then(() => {
            log.info("Updated current user w/ id edited his settings inside Edit Personal Info page!");
            log.info(currentUser.uid);
            this.props.firebase.doEmailUpdate(email).then(this.props.history.push(ROUTES.ACCOUNT));
        })
        .catch(error => {
            this.setState({ error });
        });

        event.preventDefault();

    }

    onChange = event => {
        this.setState({ [event.target.name]: event.target.value });
    }

    handleClearMatchedUser = () => {
        const currentUser = this.props.authUser;

        this.props.firebase.db.collection("users").doc(currentUser.uid).set({
                matchedUserID: null,
            }, 
        {merge: true})
        .then(() => {
            log.info("Updated current user w/ id " + currentUser.uid + " with a clear of matched user!");
            this.props.history.push(ROUTES.HOME);
        })
        .catch(error => {
            log.error(error);
            this.setState({ error });
        });
    }

    handleSkippedUsers = () => {
        const currentUser = this.props.authUser;

        this.props.firebase.db.collection("users").doc(currentUser.uid).set({
            skippedUserIDs: [],
        }, 
        {merge: true})
        .then(() => {
            log.info("Updated current user w/ id ", currentUser.uid, " with a clear of skipped users!");
            this.props.authUser.skippedUserIDs = [];
            this.props.history.push(ROUTES.HOME);
        })
        .catch(error => {
            log.error(error);
            this.setState({ error });
        });
    }

    handleDeleteProfileNotification = () => {
        const show = !this.state.show;
        log.info('Current user has toggled the delete notification and' + show ? 'enabled' : 'disabled' + 'it');
        this.setState({ show });
    }

    handleDeleteProfile = event => {
        event.preventDefault();
        let users = [];

        const currentUser = this.props.authUser;

        this.props.firebase.users()
            .onSnapshot(snapshot => {

                snapshot.forEach(doc => {
                    if(doc.id !== currentUser.uid){
                        users.push({ ...doc.data(), uid: doc.id });
                    }
                }
            );

            for(let i = 0; i < users.length; i++) {
                if(users[i].matchedUserID === currentUser.uid){
                    this.props.firebase.db.collection("users").doc(users[i].uid).set({
                        matchedUserID: null
                    }, {merge: true});
                }
                if(users[i].skippedUserIDs.includes(currentUser.uid)){
                    users[i].skippedUserIDs.splice(currentUser.uid, 1);
                    this.props.firebase.db.collection("users").doc(users[i].uid).set({
                        skippedUserIDs: users[i].skippedUserIDs
                    }, {merge: true});
                }
            }
        });

        this.props.firebase.db.collection("users").doc(currentUser.uid).delete()
        .then(this.props.firebase.auth.currentUser.delete())
        .catch(error => {
            log.error(error);
            this.setState({ error });
        });
        log.info("Current user has successfully been deleted.");
    }

    render() {
        const { username, email, photoURL, GPA, loading, error, tags} = this.state;

        const isTeacher = this.props.authUser.isTeacher ? false : true;

        const isMatched = this.props.authUser.matchedUserID ? true : false;
        
        const hasSkipped = this.props.authUser.skippedUserIDs.length > 0 ? true : false;

        const hasImage = photoURL ? true : false;

        return(
            <div className="edit-page-info">
                { loading && <Loading /> }
                <div className="profile-editor">
                    <div className="profile-picture">
                        <Col xs={14} md={14}>
                            <Link to={ROUTES.IMAGE_UPLOAD} className="edit-link">
                                {hasImage && <Image src={photoURL} rounded width="200" height="250" className="profile-image" />}
                                {!hasImage && 
                                    <Image src="https://x-treme.com.mt/wp-content/uploads/2014/01/default-team-member.png"  
                                        rounded  
                                        width="200"
                                        height="250"
                                        className="profile-image"
                                    />}
                                <Image src="https://firebasestorage.googleapis.com/v0/b/tuespairs.appspot.com/o/edit_image.png?alt=media&token=29df840d-e73e-49ba-843e-a51b8a693cc8" 
                                    className="edit-image"   
                                />
                            </Link>
                        </Col>
                    </div>
                    <Form className="profile-info" onSubmit={this.onSubmit}>
                        <Form.Group controlId="formBasicPassword">
                            <Form.Label>Username</Form.Label>
                            <InputGroup>
                                <FormControl
                                    onChange={this.onChange}
                                    aria-label="Recipient's username"
                                    aria-describedby="basic-addon2"
                                    placeholder={username}
                                    name="username"
                                />
                                <InputGroup.Prepend>
                                    <InputGroup.Text id="inputGroupPrepend">{username}</InputGroup.Text>
                                </InputGroup.Prepend>
                            </InputGroup>
                        </Form.Group>

                        <Form.Group controlId="formBasicGPA">
                            {isTeacher && 
                            <Form.Label>GPA</Form.Label>}
                            {isTeacher &&<InputGroup>
                                {isTeacher && <FormControl
                                    onChange={this.onChange}
                                    aria-label="Recipient's GPA"
                                    aria-describedby="basic-addon2"
                                    placeholder={GPA}
                                    type="number"
                                    name="GPA"
                                    min="2"
                                    max="6"
                                />}
                                <InputGroup.Prepend>
                                    <InputGroup.Text id="inputGroupPrepend">{GPA}</InputGroup.Text>
                                </InputGroup.Prepend>
                            </InputGroup>}
                        </Form.Group>

                        <PasswordChangeLink />

                        <div className="tag-list">
                            <ButtonGroup as={Row}>
                                {tags.map(tag => {
                                    if(this.state.tagIDs.includes(tag.tid)) {
                                        return(
                                        <Button style={{ backgroundColor: tag.color }} value={tag.color} name={tag.tid} onClick={this.setChecked}>
                                            {tag.name}
                                        </Button>
                                        )
                                    } else {
                                        return(
                                        <Button style={{ backgroundColor: 'rgb(252, 152, 0)' }} value={tag.color} name={tag.tid} onClick={this.setChecked}>
                                            {tag.name}
                                        </Button>
                                        )
                                    }
                                })}
                            </ButtonGroup>
                        </div>

                        <div className="error-message">
                            {error && <p>{error.message}</p>}
                        </div>
                        <Button variant="primary" type="submit">
                            Submit
                        </Button>
                    </Form>
                    <div className="clear-buttons">
                        {isMatched && <Button onClick={this.handleClearMatchedUser}>Clear Match</Button>}
                        {hasSkipped && <Button onClick={this.handleSkippedUsers}>Clear Skipped</Button>}
                    </div>
                    <Button onClick={this.handleDeleteProfileNotification} className="delete-profile">
                            Delete profile
                    </Button>

                    <Alert show={this.state.show} variant="success" className="delete-alert">
                        <Alert.Heading>Are you sure you want to delete your profile ?</Alert.Heading>
                            <p>
                            These changes are final, your account and all its personal data will be deleted permanently.
                            Click the I'm sure button to procceed!
                            </p>
                            <hr />
                        <div className="d-flex justify-content-end">
                            <Button onClick={this.handleDeleteProfile} variant="outline-success">
                                I'm sure
                            </Button>
                        </div>
                        {!this.state.show && <Button >Show Alert</Button>}
                    </Alert>
                </div>
            </div>
        )
    }
}

const condition = authUser => !!authUser;

const PersonalInfo = compose (
    withFirebase,
    withCurrentUser,
    withRouter,
)(EditPersonalInfo);

export default withAuthorization(condition)(StudentInfo);