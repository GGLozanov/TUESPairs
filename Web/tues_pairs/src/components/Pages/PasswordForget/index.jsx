import React, { Component } from 'react';
import { Link, withRouter } from 'react-router-dom';

import { withFirebase } from '../../Firebase';
import * as ROUTES from '../../../constants/routes';
import { compose } from 'recompose';
import { withCurrentUser } from '../../Authentication/context';

import './passwordforget.scss';
import { Card, Form, FormControl, Button } from 'react-bootstrap';

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
          <div className="password-card">
            <Card bg="dark">
              <Card.Img 
                variant="top" 
                src="https://firebasestorage.googleapis.com/v0/b/tuespairs.appspot.com/o/tues_pairs_lock.png?alt=media&token=9231df01-cb4c-4c8a-8ada-b8eaf7fdc040"            
              />
              <Card.Body>
                <Card.Title>Trouble Logging In?</Card.Title>
                <Card.Text>
                  Enter your email and we'll send you a link to get back into your account.
                </Card.Text>
                <Form onSubmit={this.onSubmit} className="email-handler">
                  <Form.Group controlId="formBasicEmail">
                    <FormControl
                        onChange={this.onChange}
                        aria-describedby="basic-addon2"
                        placeholder="Enter Your Email"
                        name="email"
                    />
                  </Form.Group>
                  <Button disabled={isInvalid} type="submit">
                    Send Link To Email
                  </Button>
              </Form>
              {error && <p>{error.message}</p>}
              <div className="or-text">
                <hr></hr>
                  <p>OR</p>
                <hr></hr>
              </div>
              <Link className="create-account" to={ROUTES.SIGN}>Create a new account</Link>
              </Card.Body>
            </Card>
            <div className="back-link">
              <Link to={ROUTES.SIGN}>
                Back
              </Link>
            </div>
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