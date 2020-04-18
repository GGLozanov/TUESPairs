import React, { Component } from 'react';
import { Link, withRouter } from 'react-router-dom';

import { withFirebase } from '../../Firebase';
import * as ROUTES from '../../../constants/routes';
import { compose } from 'recompose';
import { withCurrentUser } from '../../Authentication/context';

import './passwordforget.scss';

const PasswordForgetPage = () => (
    <PasswordForgetForm />
);

const INITIAL_STATE = {
  email: null,
  error: null,
};

class PasswordForgetFormBase extends Component {
  constructor(props) {
    super(props);
    this.state = { ...INITIAL_STATE };
  }

  onSubmit = event => {
    const currentUser = this.props.authUser
    const email  = this.state.email;
    this.props.firebase
      .doPasswordReset(email)
      .then(() => {
        this.setState({ ...INITIAL_STATE });
        if(currentUser){
          this.props.history.push(ROUTES.ACCOUNT);
        }
        this.props.history.push(ROUTES.SIGN);
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
      <div className="email-confirmation">
        <div className="hedaer">
          <h1>I forgot my password</h1>
        </div>
        <div className="form">
          <form onSubmit={this.onSubmit}>
            <input name="email" value={email} onChange={this.onChange} placeholder="Enter your email address"/>
              <button disabled={isInvalid} type="submit">
                Send email
              </button>
            {error && <p>{error.message}</p>}
          </form>
        </div>
      </div>
    );
  }
}

const PasswordForgetLink = () => (
  <div className="password-forget-link">
    <p>
      <Link to={ROUTES.PASSWORD_FORGET}>Forgot Password?</Link>
    </p>
  </div>
);

export default PasswordForgetPage;

const PasswordForgetForm = compose (
  withRouter,
  withFirebase,
  withCurrentUser
)(PasswordForgetFormBase);

export { PasswordForgetForm, PasswordForgetLink };