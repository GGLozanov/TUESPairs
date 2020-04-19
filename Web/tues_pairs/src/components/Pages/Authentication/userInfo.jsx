import React, { Component } from 'react';
import { compose } from 'recompose';
import { withCurrentUser } from '../../Authentication/context';
import { withAuthorization } from '../../Authentication';
import { withFirebase } from '../../Firebase';
import { FormControl, Form, Button } from 'react-bootstrap';
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
        }
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
        if(this.state.isTeacher === false) {
            this.setState({ isTeacher: true });
        } else {
            this.setState({ isTeacher: false });
        }
    }

    render() {
        const {username, isTeacher, GPA, error } = this.state;

        const isInvalid = 
            username === '';

        return (
            <div className="register-page">
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

const condition = authuser => !!authuser;

const UserInfoPage = compose (
    withRouter,
    withFirebase,
    withCurrentUser,
    withAuthorization(condition)
)(UserInfo);

export default UserInfoPage;