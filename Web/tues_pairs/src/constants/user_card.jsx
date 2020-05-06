import React from 'react';
import { Card } from 'react-bootstrap';
import TagListView from './tag';

const UserCard = props => {
    const thisUser = props.user;
    const currentUser = props.currentUser;
    let show = false;
    let color = 'rgb(34, 34, 43)';

    if(thisUser === undefined) {
        return(<></>)
    }
    if(currentUser && thisUser.matchedUserID === currentUser.uid) {
        show = true;
        color = 'rgb(252, 152, 0)';
    }
    return(
        <Card bg="dark" style={{ width: '20.6rem' , borderColor: color}} className="profile-card">
            {thisUser.photoURL && <Card.Img variant="top" src={thisUser.photoURL} className="profile-image" data-testid="profile-image"/>}
            {!thisUser.photoURL && 
                <Card.Img 
                    variant="top" 
                    src="https://x-treme.com.mt/wp-content/uploads/2014/01/default-team-member.png" 
                    className="profile-image"
                    data-testid="default-image"
                />}                
            <Card.Body className="profile-body">
                <Card.Title>{ thisUser.username }</Card.Title>
                {thisUser.isTeacher &&<Card.Subtitle>Teacher</Card.Subtitle>}
                {!thisUser.isTeacher &&<Card.Subtitle>Student</Card.Subtitle>}
                {!thisUser.isTeacher &&<Card.Text>GPA: {thisUser.GPA}</Card.Text>}
                {show && <Card.Text>User has send you a match request</Card.Text>}
                <div className="tag-list">
                    <TagListView tags={thisUser.tags} />
                </div>
            </Card.Body>
        </Card>
    )
}

export default UserCard;