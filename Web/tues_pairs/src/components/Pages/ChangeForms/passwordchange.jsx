import React, { Component } from 'react';
import './passwordforget.scss';
import { compose } from 'recompose';
import { withAuthorization } from '../../Authentication';
import { withCurrentUser } from '../../Authentication/context';
import * as ROUTES from '../../../constants/routes';
import { Link, withRouter } from 'react-router-dom';
import { Card, Button, Form, FormControl } from 'react-bootstrap';
import { withFirebase } from '../../Firebase';

class PasswordChange extends Component {
    constructor(props) {
        super(props);

        this.state = {
            error: '',
            currentPassword: '',
            newPassword: '',
            confirmNewPassowrd: ''
        };
    }

    onSubmit = async () => {
        const { currentPassword, newPassword } = this.state;
        const currentFirebaseUser = await this.props.firebase.getCurrentUser();
        const credential = this.props.firebase.getCredentials(this.props.authUser.email, currentPassword);

        console.log(credential);
                
        currentFirebaseUser.reauthenticateWithCredential(credential).then(() => {
            this.props.history.push(ROUTES.EDIT_PERSONAL_INFO);

            //this.props.firebase.doPasswordUpdate(newPassword).then(() => {
            //});
        }).catch(error => {
            console.error(error);
            this.setState({ error });
            this.props.history.push(ROUTES.EDIT_PERSONAL_INFO);
        });

    }

    onChange = event => {
        this.setState({ [event.target.name]: event.target.value });
    };

    render() {
        const { error, currentPassword, newPassword, confirmNewPassowrd } = this.state;

        const isInvalid =
            newPassword !== confirmNewPassowrd ||
            currentPassword === '' ||
            newPassword === '' || 
            confirmNewPassowrd === '';

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
                                        name="confirmNewPassowrd"
                                        type="password"
                                    />
                                </Form.Group>
                                <Button disabled={isInvalid} type="submit">
                                    Save changes
                                </Button>
                            </Form>
                            {error && <p>{error.message}</p>}
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
    <div className="password-forget-link">
        <p>
        <Link to={ROUTES.PASSWORD_CHANGE}>Change my password</Link>
        </p>
    </div>
)

export default PasswordChangePage;

export { PasswordChangeLink };