import React, { Component } from 'react';
import { withRouter } from 'react-router-dom';
import { compose } from 'recompose';

import { withFirebase } from '../../Firebase';
import * as ROUTES from '../../../constants/routes';
import { PasswordForgetLink } from '../PasswordForget'
import './style.scss';

const SignInPage = () => (
  <div>
    <SignInForm />
    <PasswordForgetLink />
  </div>
);

const INITIAL_STATE = {
  email: '',
  password: '',
  error: null,
};

class SignInFormBase extends Component {
  constructor(props) {
    super(props);
    this.state = { ...INITIAL_STATE };
  }

  onSubmit = event => {
    const { email, password } = this.state;
    this.props.firebase
      .doSignInWithEmailAndPassword(email, password)
      .then(() => {
        this.setState({ ...INITIAL_STATE });
        this.props.history.push(ROUTES.HOME);
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
    const { email, password, error } = this.state;

    const isInvalid = password === '' || email === '';

    return (
      <div className="base-container" ref={this.props.containerRef}>
        <div className="header">Login</div>
        <div className="content">
          <div className="image">
            <img src="" alt=""></img>
          </div>
          <div className="form">
            <form onSubmit={this.onSubmit}>
              <div className="form-group">
                <label htmlFor="email">Email</label>
                <input name="email" value={email} onChange={this.onChange} type="email" placeholder="Email Address" />
              </div>
              <div className="form-group">
                <label htmlFor="password">Password</label>
                <input name="password" value={password} onChange={this.onChange} type="password" placeholder="Password"/>
              </div>
              <div className="error-message">
                {error && <p>{error.message}</p>}
              </div>
            </form>
          </div>
        </div>
        <div className="footer">
          <button type="button" className="btn" disabled={isInvalid} onClick={this.onSubmit}>
            Login
          </button>
        </div>
      </div>
    );
  }
}

const SignInForm = compose(
  withRouter,
  withFirebase,
)(SignInFormBase);

export default SignInPage;

export { SignInForm };