import React, { Component } from 'react';
import { Button, Card } from 'react-bootstrap';
import { withAuthorization } from '../../Authentication';
import * as ROUTES from '../../../constants/routes';
import { withRouter } from 'react-router-dom';
import { compose } from 'recompose';
import './style.scss';
import { withCurrentUser } from '../../Authentication/context';

class AlreadyMatched extends Component {
    constructor(props) {
        super(props);

        this.state = {
            matchedUser: null,
        }
    }

    componentDidMount(){
        const currentUser = this.props.authUser;
    
        this.unsubscribe = this.props.firebase.user(currentUser.matchedUserID).get()
        .then(snapshot => {
            const firebaseUser = snapshot.data();


            const matchedUser = {
                ...firebaseUser,
            };

            this.setState({ photoURL: matchedUser.photoURL, username: matchedUser.username, loading: false });
        });
    }   

    handleCancelMatched = () => {
        const currentUser = this.props.authUser;

        this.props.firebase.db.collection("users").doc(currentUser.uid).set({
                matchedUserID: null,
            }, 
        {merge: true})
        .then(() => {
            this.props.history.push(ROUTES.HOME);
        })
        .catch(error => {
            console.error(error);
            this.setState({ error });
        });
    }

    render() {
        const matchedUser = this.state;

        const username = matchedUser.username;

        const photoURL = matchedUser.photoURL

        const isTeacher = matchedUser.isTeacher;

        const hasImage = photoURL ? true : false;

        return(
            <div className="already-matched-page">
                <div className="match-text">
                    <p>You have sent a match request</p>
                </div>
                <div className="matched-user-card">
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
                        </Card.Body>
                    </Card>
                </div>
                <Button onClick={this.handleCancelMatched} variant="dark">Cancel</Button>
            </div>
        )
    }
};

const condition = authUser => !!authUser

const AlreadyMatchedPage = compose(
    withCurrentUser,
    withRouter,
    withAuthorization(condition)
)(AlreadyMatched);

export default AlreadyMatchedPage;