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
                <Card.Title data-testid="username">{ thisUser.username }</Card.Title>
                {thisUser.isTeacher &&<Card.Subtitle data-testid="teacher">Teacher</Card.Subtitle>}
                {!thisUser.isTeacher &&<Card.Subtitle data-testid="student">Student</Card.Subtitle>}
                {!thisUser.isTeacher &&<Card.Text data-testid="gpa">GPA: {thisUser.GPA}</Card.Text>}
                {!thisUser.isTeacher &&<Card.Subtitle className="description" data-testid="student-idea">His idea</Card.Subtitle>}
                {thisUser.isTeacher &&<Card.Subtitle className="description" data-testid="teacher-idea">Interested in</Card.Subtitle>}
                {!thisUser.description &&<Card.Text data-testid="gpa">Empty as the void inside our hearts!</Card.Text>}
                <Card.Text data-testid="gpa">{thisUser.description}</Card.Text>
                {show && <Card.Text>User has send you a match request</Card.Text>}
                <div className="tag-list">
                    <TagListView tags={thisUser.tags} />
                </div>
            </Card.Body>
        </Card>
    )
}

export default UserCard;