import React, { Component } from 'react';
import './changeform.scss';
import { compose } from 'recompose';
import { withAuthorization } from '../../Authentication';
import { withCurrentUser } from '../../Authentication/context';
import * as ROUTES from '../../../constants/routes';
import { Link, withRouter } from 'react-router-dom';
import { Card, Button, Form, FormControl } from 'react-bootstrap';
import { withFirebase } from '../../Firebase';
import log from '../../../constants/logger';

class PasswordChange extends Component {
    constructor(props) {
        super(props);

        this.state = {
            error: '',
            currentPassword: '',
            newPassword: '',
            confirmNewPassword: '',
            currentUser: Object,
            credential: Object
        };
    }

    onSubmit = event => {
        const { currentPassword, newPassword } = this.state;
        let credential;
        this.props.firebase.getCurrentUser()
        .then(currentUser => {
            this.setState({ currentUser });
        }).then(() => {
            credential = this.props.firebase.getCredentials(this.props.authUser.email, currentPassword);
        }).then(() => {
            this.state.currentUser.reauthenticateWithCredential(credential).then(() => {
                this.props.firebase.doPasswordUpdate(newPassword).then(() => {
                    log.info("Updated current user changed his password inside Password Change page!");
                    this.props.history.push(ROUTES.EDIT_PERSONAL_INFO);
                }).catch(error => {
                    log.error(error);
                    this.setState({ error });
                });
            }).catch(error => {
                log.error(error);
                this.setState({ error });
            });
        });

        event.preventDefault();
    }

    onChange = event => {
        this.setState({ [event.target.name]: event.target.value });
    };

    render() {
        const { error, currentPassword, newPassword, confirmNewPassword } = this.state;

        const isInvalid =
            newPassword !== confirmNewPassword ||
            currentPassword === '' ||
            newPassword === '' || 
            confirmNewPassword === '';

        return (
            <div className="email-confirmation">
                <div className="password-card">
                    <Card bg="dark">
                        <Card.Img 
                            variant="top" 
                            src="https://firebasestorage.googleapis.com/v0/b/tuespairs.appspot.com/o/tues_pairs_lock.png?alt=media&token=9231df01-cb4c-4c8a-8ada-b8eaf7fdc040"            
                        />
                        <Card.Body>
                            <Card.Title>Want to change your password?</Card.Title>
                            <Card.Text>
                                Enter your old password and change it with a new one.
                            </Card.Text>
                            <Form onSubmit={this.onSubmit} className="email-handler">
                                <Form.Group controlId="formBasicCurrentPassword">
                                    <FormControl
                                        onChange={this.onChange}
                                        aria-describedby="basic-addon2"
                                        placeholder="Enter your current password"
                                        name="currentPassword"
                                        type="password"
                                    />
                                </Form.Group>
                                <Form.Group controlId="formBasicNewPassword">
                                    <FormControl
                                        onChange={this.onChange}
                                        aria-describedby="basic-addon2"
                                        placeholder="Enter your new password"
                                        name="newPassword"
                                        type="password"
                                    />
                                </Form.Group>
                                <Form.Group controlId="formBasicConfirmNewPassword">
                                    <FormControl
                                        onChange={this.onChange}
                                        aria-describedby="basic-addon2"
                                        placeholder="Confirm your new password"
                                        name="confirmNewPassword"
                                        type="password"
                                    />
                                </Form.Group>
                                <Button disabled={isInvalid} type="submit">
                                    Save changes
                                </Button>
                            </Form>
                            <div className="error-message">
                                {error && <p>{error.message}</p>}
                            </div>
                        </Card.Body>
                    </Card>
                    <div className="back-link">
                        <Link to={ROUTES.EDIT_PERSONAL_INFO}>
                            Back
                        </Link>
                    </div>
                </div>
            </div>
        )
    }
}

const condition = authUser => !!authUser;

const PasswordChangePage = compose (
    withAuthorization(condition),
    withFirebase,
    withRouter,
    withCurrentUser
)(PasswordChange);

const PasswordChangeLink = () => (
    <div className="change-link">
        <Link to={ROUTES.PASSWORD_CHANGE}>
            <Button variant="light">
                Change my password
            </Button>
        </Link>
    </div>
)

export default PasswordChangePage;

export { PasswordChangeLink };