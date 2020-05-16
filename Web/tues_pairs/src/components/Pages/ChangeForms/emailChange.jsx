import React, { Component } from 'react';
import { compose } from 'recompose';
import { withRouter, Link } from 'react-router-dom';
import { withAuthorization } from '../../Authentication';
import { withFirebase } from '../../Firebase';
import { withCurrentUser } from '../../Authentication/context';
import * as ROUTES from '../../../constants/routes';
import { Card, FormControl, Button, Form, Modal } from 'react-bootstrap';

class EmailChangeFormBase extends Component {
    constructor(props) {
        super(props);
        
        this.state = {
            email: '',
            error: '',
            password: '',
            modalShow: false,
            setModalShow: false
        };
    }

    onChange = event => {
        this.setState({ [event.target.name]: event.target.value });
    }

    onSubmit = () => {

    }

    render() {
        const{ error, email, password, modalShow } = this.state;

        const isInvalid = email === '';

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
                  {error && <p>{error.message}</p>}
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
                        />
                    </Form.Group>
                    <p>
                        Changes will take effect after hitting the submit button!
                    </p>
                </Modal.Body>
                <Modal.Footer>
                    <Button onClick={() => this.setState({ modalShow: false })}>Submit</Button>
                </Modal.Footer>
            </Modal>
        </div>
        );
    }

}

const EmailChangeLink = () => (
    <div className="password-forget-link">
        <p>
            <Link to={ROUTES.EMAIL_CHANGE}>Change my email</Link>
        </p>
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
