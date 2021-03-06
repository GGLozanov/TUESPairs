import React, { Component } from 'react';
import { withRouter } from 'react-router-dom';
import { compose } from 'recompose';
import firebase from 'firebase';
import { withFirebase } from '../../Firebase';
import * as ROUTES from '../../../constants/routes';
import { PasswordForgetLink } from '../ChangeForms'
import './style.scss';
import { withCurrentUser } from '../../Authentication/context';
import FacebookIcon from '@material-ui/icons/Facebook';
import GitHubIcon from '@material-ui/icons/GitHub';
import log from '../../../constants/logger';

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

  handleExternalSignIn = provider => {
    firebase.auth().signInWithPopup(provider)
    .then(result => {
      log.info("User w/ id has successfully authenticated with external provider!");
      this.props.firebase.user(result.user.uid).get()
      .then(snapshot => {
        if(snapshot.exists) {
          this.props.history.push(ROUTES.HOME);
        } else {
          this.props.firebase.db.collection("users").doc(result.user.uid).set({
            username: null,
            email: result.user.email,
            isTeacher: null,
            GPA: null,
            photoURL: result.user.photoURL,
            matchedUserID: null,
            skippedUserIDs: [],
            tagIDs: [],
            deviceTokens: [],
            lastUpdateTime: this.props.firebase.fieldValue.serverTimestamp()
          })
          .then(() => this.props.history.push(ROUTES.USER_INFO));
        }
      })
    }).catch(error => {
      log.error(error);
    });
  }

  onSubmit = event => {
    const { email, password } = this.state;
    this.props.firebase
      .doSignInWithEmailAndPassword(email, password)
      .then(() => {
        log.info("User has successfully logged in with the Firebase SDK! Redirecting to Home page!");
        this.setState({ ...INITIAL_STATE });
        this.props.history.push(ROUTES.HOME);
      })
      .catch(error => {
        log.error(error);
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
                <input name="email" value={email} onChange={this.onChange} type="email" placeholder="Email Address" aria-label="email"/>
              </div>
              <div className="form-group">
                <label htmlFor="password">Password</label>
                <input name="password" value={password} onChange={this.onChange} type="password" placeholder="Password" aria-label="password"/>
              </div>
              <div className="error-message">
                {error && <p>{error.message}</p>}
              </div>
            </form>
          </div>
        </div>
        <div className="footer">
          <button type="button" className="btn" disabled={isInvalid} onClick={this.onSubmit} data-testid="signin-button">
            Login
          </button>
        </div>
        <div className="external-sign-in">
          <hr></hr>
          <button type="button" onClick={this.handleExternalSignIn.bind(this, new firebase.auth.GoogleAuthProvider())}>
              <img className="google-image" src="https://maxcdn.icons8.com/Share/icon/Logos/google_logo1600.png" alt="googleimage"></img>
              <span className="google-text">Log in with Google</span>
          </button>
          <button type="button" onClick={this.handleExternalSignIn.bind(this, new firebase.auth.FacebookAuthProvider())}>
              <span className="facebook-icon"><FacebookIcon/></span>
              <span>Log in with Facebook</span>
          </button>
          <button type="button" onClick={this.handleExternalSignIn.bind(this, new firebase.auth.GithubAuthProvider())}>
              <span className="github-icon"><GitHubIcon/></span>
              <span className="github-text">Log in with Github</span>
          </button>
        </div>
      </div>
    );
  }
}

const SignInForm = compose(
  withCurrentUser,
  withRouter,
  withFirebase,
)(SignInFormBase);

export default SignInPage;

export { SignInForm };