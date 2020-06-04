import React, { Component } from 'react';
import { FormControl, Button, Col, Image, Form, Row, InputGroup, ButtonGroup, Modal } from 'react-bootstrap';
import { withCurrentUser } from '../../Authentication/context';
import { compose } from 'recompose';
import { withFirebase } from '../../Firebase';
import { withAuthorization } from '../../Authentication';
import { withRouter } from 'react-router-dom';
import * as ROUTES from '../../../constants/routes';
import { Link } from 'react-router-dom';
import { PasswordChangeLink } from '../ChangeForms/passwordchange';
import { EmailChangeLink } from '../ChangeForms/emailChange';
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
            password: '',
            description: '',
            valid: true
        };
    }

    componentDidMount(){
        let currentUser = this.props.authUser;
        this.setState({ loading: true });
    
        this.unsubscribe = this.props.firebase.user(currentUser.uid).get()
        .then(snapshot => {
            const currentUser = this.props.firebase.getUserFromSnapshot(snapshot);

            if(currentUser.providerData) {
                currentUser.providerData.forEach(provider => {
                    if(provider.providerId !== 'password') {
                        this.setState({ valid: false });
                    }
                });
            }

            this.setState({ 
                photoURL: currentUser.photoURL, 
                email: currentUser.email, 
                tagIDs: currentUser.tagIDs, 
                description: currentUser.description,
                loading: false 
            });
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
        const { username, email, GPA, tagIDs, description} = this.state;

        const currentUser = this.props.authUser;

        this.props.firebase.db.collection("users").doc(currentUser.uid).set({
            username: username,
            GPA: parseFloat(GPA),
            email: email,
            tagIDs: tagIDs,
            description: description,
            lastUpdateTime: this.props.firebase.fieldValue.serverTimestamp()
        }, {merge: true})
        .then(() => {
            log.info("Updated current user w/ id edited his settings inside Edit Personal Info page!");
            log.info(currentUser.uid);
            this.props.firebase.doEmailUpdate(email).then(this.props.history.push(ROUTES.ACCOUNT));
        })
        .catch(error => {
            if(error === "Missing or insufficient permissions.") {
                this.setState({ error: "Please wait before submitting again!" });
            } else this.setState({ error });
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
        }, {merge: true})
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
        }, {merge: true})
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
        const logText = show ? 'enabled' : 'disabled';
        log.info('Current user has toggled the delete notification and ' + logText + ' it');
        this.setState({ show });
    }

    submitWithPassword = event => {
        const { password } = this.state;
        let credential;
        this.props.firebase.getCurrentUser()
        .then(currentUser => {
            this.setState({ currentUser });
        }).then(() => {
            credential = this.props.firebase.getCredentials(this.props.authUser.email, password);
        }).then(() => {
            this.state.currentUser.reauthenticateWithCredential(credential).then(() => {
                this.handleDeleteProfile(event);
            }).catch(error => {
                log.error(error);
                this.setState({ error, modalShow: false });
            });
        });

        event.preventDefault();
    }

    handleDeleteProfile = event => {
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
            this.setState({ error, modalShow: false });
        });
        log.info("Current user has successfully been deleted.");

        event.preventDefault();
    }

    render() {
        const { username, email, photoURL, GPA, loading, error, tags, show, description, valid } = this.state;

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
                                    value={username}
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

                        <div className="description">
                        <Form.Group controlId="exampleForm.ControlTextarea1">
                            {!isTeacher && <p>Change your project idea?</p>}
                            {isTeacher && <p>Change in what projects are you interested in?</p>}
                            <Form.Control as="textarea" 
                                rows="3" 
                                maxlength="200"
                                onChange={this.onChange}
                                name="description"
                                value={description}
                            />
                        </Form.Group>
                    </div>

                        <Button className="email" variant="primary" size="lg" block>
                            { email }
                        </Button>

                        {valid &&<EmailChangeLink />}
                        {valid &&<PasswordChangeLink />}

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
                        <div className="clear-buttons">
                            <ButtonGroup as={Row}>
                                {isMatched && <Button variant="secondary" onClick={this.handleClearMatchedUser}>Clear Match</Button>}
                                {hasSkipped && <Button variant="secondary" onClick={this.handleSkippedUsers}>Clear Skipped</Button>}
                            </ButtonGroup>
                        </div>
                        <Button variant="success" type="submit" className="submit-button">
                            Save Changes
                        </Button>
                    </Form>
                    <Button onClick={this.handleDeleteProfileNotification} variant="danger" className="delete-profile">
                            Delete profile
                    </Button>

                    <Modal
                        show={show}
                        onHide={() => this.setState({ show: false })}
                        size="lg"
                        aria-labelledby="contained-modal-title-vcenter"
                        centered
                    >
                        <Modal.Header closeButton>
                            <Modal.Title id="contained-modal-title-vcenter">
                                Confirm Account Deletion
                            </Modal.Title>
                        </Modal.Header>
                        <Modal.Body>
                            <h4>Enter your password</h4>
                            <Form.Group controlId="formBasicCurrentPassword">
                                <FormControl
                                    aria-describedby="basic-addon2"
                                    placeholder="Enter your current password"
                                    name="password"
                                    type="password"
                                    onChange={this.onChange}
                                />
                            </Form.Group>
                            <p>
                                Are you absolutely sure that you want to delete your account?
                                This change is permanent and cannot be reverted. Press the I'm Sure button to proceed.
                            </p>
                        </Modal.Body>
                        <Modal.Footer>
                            <Button variant="danger" onClick={this.handleDeleteProfile}>I'm Sure</Button>
                        </Modal.Footer>
                    </Modal>
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