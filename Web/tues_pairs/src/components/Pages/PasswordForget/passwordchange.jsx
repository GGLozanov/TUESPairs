import React, { Component } from 'react';
import './passwordforget.scss';
import { compose } from 'recompose';
import { withAuthorization } from '../../Authentication';
import { withCurrentUser } from '../../Authentication/context';
import * as ROUTES from '../../../constants/routes';
import { Link, withRouter } from 'react-router-dom';

class PasswordChange extends Component {
    constructor(props) {
        super(props);

        this.state = {
            email: '',
            error: ''
        };
    }

    onSubmit() {
        const currentUser = this.props.authUser
        const email  = currentUser.email;
        this.props.firebase
        .doPasswordReset(email)
        .then(() => {
            this.props.history.push(ROUTES.ACCOUNT);
        })
        .catch(error => {
            this.setState({ error });
        });
    
    }

    render() {
        const { email, error } = this.state;
        const isInvalid = email === '';

        return (
            <div className="email-confirmation">
                <div className="hedaer">
                <h2>Send me a confirmation email</h2>
                </div>
                <div className="form">
                <form onSubmit={this.onSubmit}>
                    <button disabled={isInvalid} type="submit">
                        Send
                    </button>
                    {error && <p>{error.message}</p>}
                </form>
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