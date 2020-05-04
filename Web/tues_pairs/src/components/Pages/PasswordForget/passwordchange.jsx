import React, { Component } from 'react';
import './passwordforget.scss';
import { compose } from 'recompose';
import { withAuthorization } from '../../Authentication';
import { withCurrentUser } from '../../Authentication/context';
import * as ROUTES from '../../../constants/routes';
import { Link, withRouter } from 'react-router-dom';
import { Card, Button } from 'react-bootstrap';

class PasswordChange extends Component {
    constructor(props) {
        super(props);

        this.state = {
            error: ''
        };
    }

    onSubmit = () => {
        const currentUser = this.props.authUser;
        const email  = currentUser.email;
        this.props.firebase
        .doPasswordReset(email)
        .then(() => {
            this.props.history.push(ROUTES.EDIT_PERSONAL_INFO);
        })
        .catch(error => {
            this.setState({ error });
        });
    
    }

    render() {
        const { error } = this.state;

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
                            Click the button and we will send you an email to change you password.
                            </Card.Text>
                            <Button onClick={this.onSubmit}>
                                Send Link To Email
                            </Button>
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