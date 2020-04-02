import React, { Component } from 'react';
import { withRouter } from 'react-router-dom';
import { compose } from 'recompose';

import { withFirebase } from '../../Firebase';
import * as ROUTES from '../../../constants/routes';

import './style.scss';

const SingUpPage = () => (
    <div>
        <SignUpForm />
    </div>
);

const INITIAL_STATE = {
    username: '',
    email: '',
    passwordOne: '',
    passwordTwo: '',
    isTeacher: false,
    GPA: 2.1,
    photoURL: null,
    error: null,
};

class SignUpFormBase extends Component {
    constructor(props) {
        super(props);

        this.state = { ...INITIAL_STATE };
    }

    onSubmit = event => {
        const { username, email, passwordOne, isTeacher, GPA, photoURL } = this.state;
        this.props.firebase
            .doCreateUserWithEmailAndPassword(email, passwordOne)
            .then(authUser => {
                // Create a user in your Firestore database
                this.props.firebase.getCurrentUser().then(currentUser => {
                    authUser = this.props.firebase.db.collection("users").doc(currentUser.uid).set({
                        username: username,
                        email: email,
                        isTeacher: Boolean(isTeacher),
                        GPA: parseFloat(GPA),
                        photoURL: photoURL,
                        matchedUserID: null,
                        skippedUserIDs: []
                    });
                })
            })
            .then(() => {
                this.setState({ ...INITIAL_STATE });
                this.props.history.push(ROUTES.IMAGE_UPLOAD);
            })
            .catch(error => {
                this.setState({ error });
            });
            
        event.preventDefault();
    }

    onChange = event => {
        this.setState({ [event.target.name]: event.target.value });
    };    

    render() {

        const {
            username,
            email,
            passwordOne,
            passwordTwo,
            isTeacher,
            GPA,
            error,
        } = this.state;

        const isInvalid = 
            passwordOne !== passwordTwo ||
            passwordOne === '' ||
            email === '' ||
            username === '';

        const checkTeacher = 
            isTeacher === true;

        return(
            <div className="base-container" ref={this.props.contanerRef}>
                <div className="header">Register</div>
                <div className="content">
                    <div className="image">
                        <img src="" alt=""></img>
                    </div>
                    <div className="form">
                        <form onSubmit={this.onSubmit}>
                            <div className="form-group">
                                <label htmlFor="username">Username</label>
                                <input name="username" value={username} onChange={this.onChange} type="text" placeholder="Enter your username"/>
                            </div>
                            <div className="form-group">
                                <label htmlFor="email">Email</label>
                                <input name="email" value={email} onChange={this.onChange} type="email" placeholder="Enter your email address"/>
                            </div>
                            <div className="form-group">
                                <label htmlFor="passwordOne">Password</label>
                                <input name="passwordOne" value={passwordOne} onChange={this.onChange} type="password" placeholder="Enter your password" minLength="4" maxLength="8"/>
                            </div>
                            <div className="form-group">
                                <label htmlFor="passwordTwo">Confirm your password</label>
                                <input name="passwordTwo" value={passwordTwo} onChange={this.onChange} type="password" placeholder="Confirm your password" minLength="4" maxLength="8"/>
                            </div>
                            <div className="teacher-options">
                                <select name="isTeacher" value={isTeacher} onChange={this.onChange}>
                                    <option value="true">Teacher</option>
                                    <option value="false">Student</option>    
                                </select> 
                            </div>
                            <div className="form-group">
                                <input name="GPA" value={GPA} onChange={this.onChange} disabled={checkTeacher} type="number" placeholder="Enter your GPA(from 8-12th grade)" min="2.01" step="0.01" max="6.00"/>
                            </div>
                            <div className="error-message">
                                {error && <p>{error.message}</p>}
                            </div>
                            <button type="button" className="btn" disabled={isInvalid} onClick={this.onSubmit}>
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