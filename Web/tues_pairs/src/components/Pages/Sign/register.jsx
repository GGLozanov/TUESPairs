import React, { Component } from 'react';
import { withRouter } from 'react-router-dom';
import { compose } from 'recompose';

import { withFirebase } from '../../Firebase';
import * as ROUTES from '../../../constants/routes';
import log from '../../../constants/logger';

import './style.scss';
import validator from 'validator';

const SingUpPage = () => (
    <div>
        <SignUpForm />
    </div>
);

const INITIAL_STATE = {
    passwordOne: '',
    passwordTwo: '',
    error: null,
};

class SignUpFormBase extends Component {
    constructor(props) {
        super(props);

        this.state = { ...INITIAL_STATE };
    }

    onSubmit = event => {
        const { email, passwordOne } = this.state;
        this.props.firebase
            .doCreateUserWithEmailAndPassword(email, passwordOne)
            .then(authUser => {
                log.info("Registered new user w/ id to the Firebase Authentication SDK");
                this.props.firebase.getCurrentUser().then(currentUser => {
                    authUser = this.props.firebase.db.collection("users").doc(currentUser.uid).set({
                        username: null,
                        email: email,
                        isTeacher: null,
                        GPA: null,
                        deviceTokens: [],
                        photoURL: null,
                        matchedUserID: null,
                        skippedUserIDs: [],
                        tagIDs: [],
                        lastUpdateTime: this.props.firebase.fieldValue.serverTimestamp()
                    });
                })
            })
            .then(() => {
                log.info("Current user will be navigated to User info following Authentication");
                this.setState({ ...INITIAL_STATE });
                this.props.history.push(ROUTES.USER_INFO);
            })
            .catch(error => {
                log.error(error);
                this.setState({ error });
            });
            
        event.preventDefault();
    }

    onChange = event => {
        this.setState({ [event.target.name]: event.target.value });
    };    

    render() {

        const {
            email,
            passwordOne,
            passwordTwo,
            error,
        } = this.state;

        const isInvalid = 
            passwordOne !== passwordTwo ||
            passwordOne === '' ||
            validator.isEmpty(email) ||
            !validator.isEmail(email);

        return(
            <div className="base-container" ref={this.props.contanerRef}>
                <div className="header">Register</div>
                <div className="content">
                    <div className="form">
                        <form onSubmit={this.onSubmit}>
                            <div className="form-group">
                                <label htmlFor="email">Email</label>
                                <input name="email" 
                                value={email} 
                                onChange={this.onChange} 
                                type="email" 
                                placeholder="Enter your email address"
                                aria-label="email"/>
                            </div>
                            <div className="form-group">
                                <label htmlFor="passwordOne">Password</label>
                                <input name="passwordOne"
                                    value={passwordOne}
                                    onChange={this.onChange}
                                    type="password"
                                    placeholder="Enter your password"
                                    minLength="4" 
                                    maxLength="8"
                                    aria-label="passwordOne"
                                />
                            </div>
                            <div className="form-group">
                                <label htmlFor="passwordTwo">Confirm your password</label>
                                <input name="passwordTwo" 
                                    value={passwordTwo} 
                                    onChange={this.onChange} 
                                    type="password" 
                                    placeholder="Confirm your password" 
                                    minLength="4" 
                                    maxLength="8"
                                    aria-label="passwordTwo"    
                                />
                            </div>
                            <div className="error-message">
                                {error && <p>{error.message}</p>}
                            </div>
                            <button type="button" className="btn" disabled={isInvalid} onClick={this.onSubmit} data-testid="signup-button">
                                Sign Up
                            </button>
                        </form>
                    </div>
                </div>
                <div className="footer">
                </div>
            </div>
        );
    }
}

const SignUpForm = compose(
    withRouter,
    withFirebase,
)(SignUpFormBase);


export default SingUpPage

export { SignUpForm };