import React, { Component } from 'react';
import { withAuthorization } from '../../Authentication';
import { compose } from 'recompose';
import { withCurrentUser } from '../../Authentication/context';
import { withFirebase } from '../../Firebase';
import { Card, Button } from 'react-bootstrap';
import './style.scss';

const AccountPage = () => (
    <div>
        <UserProfilePage />
    </div>
);

class UserProfile extends Component {
    constructor(props) {
        super(props);

        this.state = {
            username: this.props.authUser.username,
            email: this.props.authUser.email,
            photoURL: this.props.authUser.photoURL,
            GPA: this.props.authUser.GPA,
            error: '',
            message: '',
            users: null,
        };
    }

    render() {
        const { username, photoURL} = this.state;

        const isTeacher = this.props.authUser.isTeacher;

        return(
            <div className="page-main">
                <Card bg="dark" style={{ width: '18rem' }} className="profile-card">
                    <Card.Img variant="top" src={photoURL} className="profile-image"/>
                    <Card.Body className="profile-body">
                        <Card.Title>{ username }</Card.Title>
                        {isTeacher &&<Card.Subtitle>Teacher</Card.Subtitle>}
                        {!isTeacher &&<Card.Subtitle>Student</Card.Subtitle>}
                            <Card.Text>
                                User description + tehcnologies he knows
                            </Card.Text>
                        <Button href="/edit_personal_info" variant="dark">Edit your personal info</Button>
                    </Card.Body>
                </Card>
            </div>
        )
    }
}



const condition = authUser => !!authUser;

const UserProfilePage = compose (
    withFirebase,
    withCurrentUser,
)(UserProfile);

export default withAuthorization(condition)(AccountPage);