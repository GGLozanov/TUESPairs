import React, { Component } from 'react';
import { withAuthorization } from '../../Authentication';
import { compose } from 'recompose';
import { withCurrentUser } from '../../Authentication/context';
import { withFirebase } from '../../Firebase';
import { Card, Button, Row, ButtonGroup, Spinner } from 'react-bootstrap';
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
            tags: [],
            tagIDs: [],
            error: '',
            message: '',
            users: null,
            loading: true,
        };
    }

    componentDidMount(){
        let currentUser = this.props.authUser;
        this.setState({ loading: true });
    
        this.unsubscribe = this.props.firebase.user(currentUser.uid).get()
        .then(snapshot => {
            const currentUser = this.props.firebase.currentUser(snapshot);
            this.setState({ photoURL: currentUser.photoURL, username: currentUser.username, tagIDs: currentUser.tagIDs });
        }).then(() => {
            let tags = [];
            
            this.state.tagIDs.forEach(tid => {
                this.props.firebase.tag(tid).get()
                .then(tag => {
                    tags.push(tag.data());
                    
                    this.setState({ tags, loading: false });
                })
            });
        })
    }

    render() {
        const { username, photoURL, tags, loading} = this.state;

        const isTeacher = this.props.authUser.isTeacher;

        const hasImage = photoURL ? true : false;

        return(
            <div className="page-main">
                { loading && 
                <Spinner animation="border" role="status">
                <span className="sr-only">Loading...</span>
                </Spinner> }

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