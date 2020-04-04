import React, { Component } from 'react';
import { FormControl, Button, Col, Image, Form, Row } from 'react-bootstrap';
import { withCurrentUser } from '../../Authentication/context';
import { compose } from 'recompose';
import { withFirebase } from '../../Firebase';
import { withAuthorization } from '../../Authentication';
import { withRouter } from 'react-router-dom';
import * as ROUTES from '../../../constants/routes';
import { Link } from 'react-router-dom';

const TeacherInfo = () => (
    <div>

    </div>
);

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
            isMatched: true,
            hasSkipped: true,
        };
    }

    componentDidMount(){
        let currentUser = this.props.authUser;
        this.setState({ loading: true });
    
        this.unsubscribe = this.props.firebase.user(currentUser.uid).get()
        .then(snapshot => {
            const firebaseUser = snapshot.data();

            //default empty roles
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
        const { username, email, photoURL, error, message, GPA} = this.state;

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
            this.props.history.push(ROUTES.ACCOUNT);
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
            this.props.history.push(ROUTES.ACCOUNT);
        })
        .catch(error => {
            console.error(error);
            this.setState({ error });
        });
    }

    render() {
        const { username, email, photoURL, error, message, GPA} = this.state;

        const isInvalid = username === '' ||
        GPA < 2 || GPA > 6;

        const isTeacher = this.props.authUser.isTeacher ? false : true;

        this.state.isMatched = this.props.authUser.matchedUserID ? true : false;

        this.state.hasSkipped = this.props.authUser.skippedUserIDs.length > 0 ? true : false;

        return(
            this.state.loading ? <div></div> :
            <div className="edit-page-info">
                <div className="profile-editor">
                    <div className="profile-picture">
                        <Col xs={14} md={14}>
                            <Link to={ROUTES.IMAGE_UPLOAD} className="edit-link">
                                <Image src={photoURL} rounded width="200" height="250" className="profile-image" />
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
                            {isTeacher && 
                            <Form.Label column sm="2">
                                New email
                            </Form.Label>}
                            <Col sm="4">
                                {isTeacher && <FormControl
                                    onChange={this.onChange}
                                    aria-label="Recipient's email"
                                    aria-describedby="basic-addon2"
                                    placeholder="example@example.com"
                                    type="text"
                                    name="email"
                                />}
                            </Col>
                        </Form.Group>

                        <Button variant="primary" type="submit" disabled={isInvalid}>
                            Submit
                        </Button>
                    </Form>
                    <div className="clear-buttons">
                        {this.state.isMatched && <Button onClick={this.handleClearMatchedUser}>Clear Match</Button>}
                        {this.state.hasSkipped && <Button onClick={this.handleSkippedUsers}>Clear Skipped</Button>}
                    </div>
                    <Button onClick={this.handleDeleteProfile} className="delete-profile">
                            Delete profile
                    </Button>
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