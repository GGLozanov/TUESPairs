import React from 'react';
import { Card } from 'react-bootstrap';
import TagListView from './tag';

const UserCard = user => {
    const thisUser = user.user;

    if(thisUser === undefined) {
        return(<></>)
    }
    return(
        <Card bg="dark" style={{ width: '20.6rem' }} className="profile-card">
            {thisUser.photoURL && <Card.Img variant="top" src={thisUser.photoURL} className="profile-image"/>}
            {!thisUser.photoURL && 
                <Card.Img 
                    variant="top" 
                    src="https://x-treme.com.mt/wp-content/uploads/2014/01/default-team-member.png" 
                    className="profile-image"
                />}                
            <Card.Body className="profile-body">
                <Card.Title>{ thisUser.username }</Card.Title>
                {thisUser.isTeacher &&<Card.Subtitle>Teacher</Card.Subtitle>}
                {!thisUser.isTeacher &&<Card.Subtitle>Student</Card.Subtitle>}
                {!thisUser.isTeacher &&<Card.Text>GPA: {thisUser.GPA}</Card.Text>}
                <div className="tag-list">
                    <TagListView tags={thisUser.tags} />
                </div>
            </Card.Body>
        </Card>
    )
}

export default UserCard;