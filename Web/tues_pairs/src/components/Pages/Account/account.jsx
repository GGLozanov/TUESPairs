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

    componentDidMount(){
        let currentUser = this.props.authUser;
        this.setState({ loading: true });
    
        this.unsubscribe = this.props.firebase.user(currentUser.uid).get()
        .then(snapshot => {
            const firebaseUser = snapshot.data();

            currentUser = {
                uid: currentUser.uid,
                email: currentUser.email,
                ...firebaseUser,
            };

            this.setState({ photoURL: currentUser.photoURL, username: currentUser.username, loading: false });
        });
    }

    render() {
        const { username, photoURL} = this.state;

        const isTeacher = this.props.authUser.isTeacher;

        const hasImage = photoURL ? true : false;

        return(
            <div className="page-main">
                <Card bg="dark" style={{ width: '18rem' }} className="profile-card">
                    {hasImage && <Card.Img variant="top" src={photoURL} className="profile-image"/>}
                    {!hasImage && 
                        <Card.Img 
                            variant="top" 
                            src="https://x-treme.com.mt/wp-content/uploads/2014/01/default-team-member.png" 
                            className="profile-image"
                        />}                
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