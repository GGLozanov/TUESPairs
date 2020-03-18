import React, { Component } from 'react';
import { Link, withRouter } from 'react-router-dom';
import { compose } from 'recompose';

import { withFirebase } from '../Firebase';
import * as ROUTES from '../../constants/routes';

const SingUpPage = () => (
    <div>
        <h1>SignUp</h1>
        <SignUpForm />
    </div>
);

const INITIAL_STATE = {
    username: '',
    email: '',
    passwordOne: '',
    passwordTwo: '',
    isTeacher: false,
    GPA: 0.1,
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
                authUser = this.props.firebase.db.collection("users").add({
                    username: username,
                    email: email,
                    isTeacher: isTeacher,
                    GPA: parseFloat(GPA),
                    photoURL: photoURL,
                });
            })
            .then(() => {
                this.setState({ ...INITIAL_STATE });
                this.props.history.push(ROUTES.HOME);
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
            <form onSubmit={this.onSubmit}>
                <input
                    name="username"
                    value={username}
                    onChange={this.onChange}
                    type="text"
                    placeholder="Enter your username"
                />
                
                <br/><br/>

                <input
                    name="email"
                    value={email}
                    onChange={this.onChange}
                    type="email"
                    placeholder="Enter your email address"
                />

                <br/><br/>
                
                <input
                    name="passwordOne"
                    value={passwordOne}
                    onChange={this.onChange}
                    type="password"
                    placeholder="Enter your password"
                    minLength="4"
                    maxLength="8"
                />

                <br/><br/>

                <input
                    name="passwordTwo"
                    value={passwordTwo}
                    onChange={this.onChange}
                    type="password"
                    placeholder="Confirm your password"
                    minLength="4"
                    maxLength="8"
                />

                <br/><br/>

                <select name="isTeacher" value={isTeacher} onChange={this.onChange}>
                    <option value="true">Teacher</option>
                    <option value="false">Student</option>    
                </select>                

                <br /><br/>

                <input 
                    name="GPA"
                    value={GPA}
                    onChange={this.onChange}
                    disabled={checkTeacher}
                    type="number"
                    placeholder="Enter your GPA(from 8-12th grade)"
                    min="2.01"
                    step="0.01"
                    max="6.00"
                />

                <br /><br/>

                <button disabled={isInvalid} type="submit">
                    Sign Up
                </button>
                
                {error && <p>{error.message}</p>}
            </form>
        );
    }
}

const SignUpLink = () => (
    <p>
        Don't have an account? <Link to={ROUTES.SIGN_UP}>Sign Up</Link>
    </p>
)

const SignUpForm = compose(
    withRouter,
    withFirebase,
)(SignUpFormBase);


export default SingUpPage

export { SignUpForm, SignUpLink };