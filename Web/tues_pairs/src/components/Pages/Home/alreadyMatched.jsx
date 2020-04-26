import React, { Component } from 'react';
import { Button, Card, Row, ButtonGroup, Spinner } from 'react-bootstrap';
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
            matchedUser: this.props.authUser,
            loading: '',
            tags: [],
        }

    }

    componentDidMount(){
        this.setState({ loading: true });

        const currentUser = this.props.authUser;
    
        this.unsubscribe = this.props.firebase.user(currentUser.matchedUserID).get()
        .then(snapshot => {
            const matchedUser = this.props.firebase.currentUser(snapshot);

            this.setState({ matchedUser });
        }).then(() => {
            let tags = [];
             
            this.state.matchedUser.tagIDs.forEach(tid => {
                this.props.firebase.tag(tid).get()
                .then(tag => {
                    tags.push(tag.data());
                    
                    this.setState({ tags, loading: false });
                })
            });
        })
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
        const { matchedUser, loading, tags } = this.state;

        return(
            <div className="already-matched-page">
                { loading && 
                <Spinner animation="border" role="status">
                    <span className="sr-only">Loading...</span>
                </Spinner> }

                <div className="match-text">
                    <p>You have sent a match request</p>
                </div>
                <div className="matched-user-card">
                    <Card bg="dark" style={{ width: '18rem' }} className="profile-card">
                        {matchedUser.photoURL && <Card.Img variant="top" src={matchedUser.photoURL} className="profile-image"/>}
                        {!matchedUser.photoURL && 
                            <Card.Img 
                                variant="top" 
                                src="https://x-treme.com.mt/wp-content/uploads/2014/01/default-team-member.png" 
                                className="profile-image"
                            />}                
                        <Card.Body className="profile-body">
                            <Card.Title>{ matchedUser.username }</Card.Title>
                            {matchedUser.isTeacher &&<Card.Subtitle>Teacher</Card.Subtitle>}
                            {!matchedUser.isTeacher &&<Card.Subtitle>Student</Card.Subtitle>}
                            <div className="tag-list">
                                <ButtonGroup as={Row}>
                                    {tags.map(tag => {
                                        if(tag) {  
                                            return (
                                            <Button value={tag.color} style={{backgroundColor: tag.color}} name={tag.tid} onClick={this.setChecked}>
                                                    {tag.name}
                                            </Button>
                                            )
                                        } else {

                                        }
                                    })}
                                </ButtonGroup>
                            </div>
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