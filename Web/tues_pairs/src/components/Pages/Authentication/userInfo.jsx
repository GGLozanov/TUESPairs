import React, { Component } from 'react';
import { compose } from 'recompose';
import { withCurrentUser } from '../../Authentication/context';
import { withAuthorization } from '../../Authentication';
import { withFirebase } from '../../Firebase';
import { FormControl, Form, Button, Spinner, ButtonGroup, Col, Row } from 'react-bootstrap';
import './style.scss';
import * as ROUTES from '../../../constants/routes';
import { withRouter } from 'react-router-dom';

class UserInfo extends Component {
    constructor(props) {
        super(props);

        this.state = {
            username: '',
            isTeacher: false,
            GPA: 0,
            error: '',
            tags: [],
            loading: false,
        }
    }

    componentDidMount() {
        this.setState({ loading: true });
    
        this.tagProvider = this.props.firebase.tags()
        .onSnapshot(snapshot => {
            let tags = [];

            snapshot.forEach(doc => 
                tags.push({ ...doc.data(), tid: doc.id }),
            );

            this.setState({ tags, loading: false });
        });
    }

    componentWillUnmount() {
        this.tagProvider();
    }

    setChecked = event => {
        
    }

    onSubmit = event => {
        const { username, isTeacher, GPA } = this.state;
        const currentUser = this.props.authUser;

        this.props.firebase.db.collection("users").doc(currentUser.uid).set({
            username: username,
            isTeacher: Boolean(isTeacher),
            GPA: parseFloat(GPA),
        }, {merge: true})
        .then(() => {
            this.props.authUser.username = username;
            this.props.authUser.GPA = GPA;
            this.props.authUser.isTeacher = isTeacher; 
            this.props.history.push(ROUTES.IMAGE_UPLOAD);
        })
        .catch(error => {
            this.setState({ error });
        });
            
        event.preventDefault();
    }

    onChange = event => {
        this.setState({ [event.target.name]: event.target.value });
    }

    handleChange = () => {
        this.setState({ isTeacher: !this.state.isTeacher })
    }

    render() {
        const {username, isTeacher, GPA, error, tags, loading } = this.state;

        const isInvalid = 
            username === '';

        return (
            <div className="register-page">
                { loading && 
                <Spinner animation="border" role="status">
                    <span className="sr-only">Loading...</span>
                </Spinner> }

                <Form className="user-info" onSubmit={this.onSubmit}>
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
                    
                    <div className="teacher-options">
                        <p>Are you a teacher ?</p>
                        <label className="switch">
                            <input name="isTeacher" value={isTeacher} onChange={this.handleChange} type="checkbox" />
                            <span className="slider round"></span>
                        </label>
                    </div>

                    <Form.Group controlId="formBasicEmail">
                        {!this.state.isTeacher && <Form.Label>GPA</Form.Label>}
                        {!this.state.isTeacher && <FormControl
                            onChange={this.onChange}
                            aria-label="Recipient's GPA"
                            aria-describedby="basic-addon2"
                            placeholder={GPA}
                            type="number"
                            name="GPA"
                            max="6"
                            min="2"
                        />}
                    </Form.Group>

                    <div className="tag-list">
                        <ButtonGroup as={Row}>
                            {this.state.tags.map(tag => (
                                <Button value={tag.color} onClick={this.setChecked}>
                                    {tag.name}
                                </Button>
                            ))}
                        </ButtonGroup>
                    </div>

                    <Button disabled={isInvalid} variant="primary" type="submit">
                        Submit
                    </Button>

                    <div className="eroor-message">
                        {error && <p>{error.message}</p>}
                    </div>
                </Form>
            </div>
        )
    }
}

const condition = authUser => !!authUser;

const UserInfoPage = compose (
    withRouter,
    withFirebase,
    withCurrentUser,
    withAuthorization(condition)
)(UserInfo);

export default UserInfoPage;