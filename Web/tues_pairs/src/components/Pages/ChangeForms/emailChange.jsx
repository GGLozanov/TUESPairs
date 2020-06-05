import React, { Component } from 'react';
import { compose } from 'recompose';
import { withRouter, Link } from 'react-router-dom';
import { withAuthorization } from '../../Authentication';
import { withFirebase } from '../../Firebase';
import { withCurrentUser } from '../../Authentication/context';
import * as ROUTES from '../../../constants/routes';
import { Card, FormControl, Button, Form, Modal } from 'react-bootstrap';
import log from '../../../constants/logger';
import validator from 'validator';

class EmailChangeFormBase extends Component {
    constructor(props) {
        super(props);
        
        this.state = {
            email: '',
            error: '',
            password: '',
            modalShow: false,
            setModalShow: false,
            currentUser: Object
        };
    }

    onChange = event => {
        this.setState({ [event.target.name]: event.target.value });
    }

    onSubmit = () => {
        const { email, password } = this.state;
        let credential;
        this.props.firebase.getCurrentUser()
        .then(currentUser => {
            this.setState({ currentUser });
        }).then(() => {
            credential = this.props.firebase.getCredentials(this.props.authUser.email, password);
        }).then(() => {
            this.state.currentUser.reauthenticateWithCredential(credential).then(() => {
                this.props.firebase.db.collection("users").doc(this.props.authUser.uid).set({
                    email: email,
                }, {merge: true}).then(() => {
                    this.props.firebase.doEmailUpdate(email).then(() => {
                        log.info("Updated current user changed his email inside Email Change page!");
                        this.props.history.push(ROUTES.EDIT_PERSONAL_INFO);
                    }).catch(error => {
                        log.error(error);
                        this.setState({ error, modalShow: false });
                    })
                });
            }).catch(error => {
                log.error(error);
                this.setState({ error, modalShow: false });
            });
        });
    }

    render() {
        const{ error, email, modalShow } = this.state;

        const isInvalid = validator.isEmpty(email) ||
        !validator.isEmail(email);

        return(
            <div className="email-confirmation">
              <div className="password-card">
                <Card bg="dark">
                  <Card.Img 
                    variant="top" 
                    src="https://firebasestorage.googleapis.com/v0/b/tuespairs.appspot.com/o/envelope_tues_pairs.png?alt=media&token=d96fb085-a7cf-4b58-9f8c-40d7c539b4a6"            
                  />
                  <Card.Body>
                    <Card.Title>Want to change your email?</Card.Title>
                    <Card.Text>
                        Enter your new email, and type in your password to confirm.
                    </Card.Text>
                    <Form onSubmit={this.onSubmit} className="email-handler">
                      <Form.Group controlId="formBasicEmail">
                        <FormControl
                            onChange={this.onChange}
                            aria-describedby="basic-addon2"
                            placeholder="Enter Your New Email"
                            name="email"
                        />
                      </Form.Group>
                      <Button disabled={isInvalid} onClick={() => this.setState({ modalShow: true })}>
                        Change Email
                      </Button>
                    </Form>
                    <div className="error-message">
                        {error && <p>{error.message}</p>}
                    </div>
                  </Card.Body>
                </Card>
                <div className="back-link">
                  <Link to={ROUTES.EDIT_PERSONAL_INFO}>
                    Back
                  </Link>
                </div>
              </div>
            <Modal
                show={modalShow}
                onHide={() => this.setState({ modalShow: false })}
                size="lg"
                aria-labelledby="contained-modal-title-vcenter"
                centered
            >
                <Modal.Header closeButton>
                    <Modal.Title id="contained-modal-title-vcenter">
                        Confirm with your password
                    </Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <h4>Enter your password</h4>
                    <Form.Group controlId="formBasicCurrentPassword">
                        <FormControl
                            aria-describedby="basic-addon2"
                            placeholder="Enter your current password"
                            name="password"
                            type="password"
                            onChange={this.onChange}
                        />
                    </Form.Group>
                    <p>
                        You will be notified on the current email, that you had it changed.
                        Changes will take effect after hitting the submit button!
                    </p>
                </Modal.Body>
                <Modal.Footer>
                    <Button className="submit" onClick={this.onSubmit}>Submit</Button>
                </Modal.Footer>
            </Modal>
        </div>
        );
    }

}

const EmailChangeLink = () => (
    <div className="change-link">
        <Link to={ROUTES.EMAIL_CHANGE}>
            <Button variant="light">
                Change my email
            </Button>
        </Link>
    </div>
)

const condition = authUser => !!authUser;

const EmailChangeForm = compose (
    withRouter,
    withAuthorization(condition),
    withFirebase,
    withCurrentUser
)(EmailChangeFormBase);

export default EmailChangeForm; 

export { EmailChangeLink };
