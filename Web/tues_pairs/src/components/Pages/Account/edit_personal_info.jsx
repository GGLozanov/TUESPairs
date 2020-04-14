import React, { Component } from 'react';
import { FormControl, Button, Col, Image, Form, Row, Alert } from 'react-bootstrap';
import { withCurrentUser } from '../../Authentication/context';
import { compose } from 'recompose';
import { withFirebase } from '../../Firebase';
import { withAuthorization } from '../../Authentication';
import { withRouter } from 'react-router-dom';
import * as ROUTES from '../../../constants/routes';
import { Link } from 'react-router-dom';

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
            email: this.props.authUser.email,
            GPA: this.props.authUser.GPA,
            photoURL: this.props.authUser.photoURL,
            email: this.props.authUser.email,
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
            const firebaseUser = snapshot.data();

            if(!firebaseUser.roles) {
                firebaseUser.roles = {};
            }

            currentUser = {
                uid: currentUser.uid,
                email: currentUser.email,
                ...firebaseUser,
            };

            this.setState({ photoURL: currentUser.photoURL, email: currentUser.email, loading: false });
        });
    }

    onSubmit = event => {
        const { username, email, GPA} = this.state;

        const currentUser = this.props.authUser;

        this.props.firebase.db.collection("users").doc(currentUser.uid).set({
            username: username,
            GPA: parseFloat(GPA),
            email: email,
            }, 
        {merge: true})
        .then(() => {
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
            this.props.history.push(ROUTES.HOME);
        })
        .catch(error => {
            console.error(error);
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
            this.props.authUser.skippedUserIDs = [];
            this.props.history.push(ROUTES.HOME);
        })
        .catch(error => {
            console.error(error);
            this.setState({ error });
        });
    }

    handleDeleteProfileNotification = () => {
        const show = !this.state.show;
        this.setState({ show });
    }

    handleDeleteProfile = () => {
        let users = [];

        const currentUser = this.props.authUser;

        this.props.firebase.users()
            .onSnapshot(snapshot => {

                snapshot.forEach(doc =>
                    users.push({ ...doc.data(), uid: doc.id }),
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
            this.setState({ error });
        });
    }

    render() {
        const { username, email, photoURL, GPA} = this.state;

        const isTeacher = this.props.authUser.isTeacher ? false : true;

        const isMatched = this.props.authUser.matchedUserID ? true : false;
        
        const hasSkipped = this.props.authUser.skippedUserIDs.length > 0 ? true : false;

        const hasImage = photoURL ? true : false;

        return(
            this.state.loading ? <div></div> :
            <div className="edit-page-info">
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
                            <FormControl
                                onChange={this.onChange}
                                aria-label="Recipient's username"
                                aria-describedby="basic-addon2"
                                placeholder={username}
                                name="username"
                            />
                        </Form.Group>

                        <Form.Group controlId="formBasicEmail">
                            {isTeacher && 
                            <Form.Label>GPA</Form.Label>}
                            {isTeacher && <FormControl
                                onChange={this.onChange}
                                aria-label="Recipient's GPA"
                                aria-describedby="basic-addon2"
                                placeholder={GPA}
                                type="number"
                                name="GPA"
                            />}
                        </Form.Group>

                        <Form.Group as={Row} controlId="formPlaintextEmail">
                            <Form.Label column sm="2">
                                Your current email
                            </Form.Label>
                            <Col sm="4">
                                <Form.Control plaintext readOnly defaultValue={email} />
                            </Col>
                        </Form.Group>
                        <Form.Group as={Row} controlId="formBasicEmail">
                            <Form.Label column sm="2">
                                New email
                            </Form.Label>
                            <Col sm="4">
                                <FormControl
                                    onChange={this.onChange}
                                    aria-label="Recipient's email"
                                    aria-describedby="basic-addon2"
                                    placeholder="example@example.com"
                                    type="text"
                                    name="email"
                                />
                            </Col>
                        </Form.Group>

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
                            This changes are final, your account and all its personal data will be deleted permanently.
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