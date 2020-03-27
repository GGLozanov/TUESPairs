import React, { Component } from 'react';
import { Link, withRouter } from 'react-router-dom';

import { withFirebase } from '../../Firebase';
import * as ROUTES from '../../../constants/routes';
import { compose } from 'recompose';
import { withCurrentUser } from '../../Authentication/context';

const PasswordForgetPage = () => (
  <div>
    <h1>PasswordForget</h1>
    <PasswordForgetForm />
  </div>
);

const INITIAL_STATE = {
  email: null,
  error: null,
};

class PasswordForgetFormBase extends Component {
  constructor(props) {
    super(props);
    this.state = { ...INITIAL_STATE, email: this.props.authUser.email };
  }

  onSubmit = event => {
    const { email } = this.state;
    this.props.firebase
      .doPasswordReset(email)
      .then(() => {
        this.setState({ ...INITIAL_STATE });
        this.props.history.push(ROUTES.ACCOUNT);
      })
      .catch(error => {
        this.setState({ error });
      });
    event.preventDefault();
  };

  onChange = event => {
    this.setState({ [event.target.name]: event.target.value });
  };
  
  render() {
    const { email, error } = this.state;
    const isInvalid = email === '';
    return (
      <form onSubmit={this.onSubmit}>
        <p>You have to approve the email confirmation</p>
        <button disabled={isInvalid} type="submit">
          Send email
        </button>
        {error && <p>{error.message}</p>}
      </form>
    );
  }
}

const PasswordForgetLink = () => (
  <p>
    <Link to={ROUTES.PASSWORD_FORGET}>Forgot Password?</Link>
  </p>
);

const PasswordChangeLink = () => (
  <p>
    <Link to={ROUTES.PASSWORD_FORGET}>Change my password</Link>
  </p>
)
export default PasswordForgetPage;

const PasswordForgetForm = compose (
  withRouter,
  withFirebase,
  withCurrentUser
)(PasswordForgetFormBase);

export { PasswordForgetForm, PasswordForgetLink, PasswordChangeLink };