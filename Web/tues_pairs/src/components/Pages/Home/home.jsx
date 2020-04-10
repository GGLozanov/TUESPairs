import React, { Component } from 'react';
import { withAuthorization } from '../../Authentication';
import { withFirebase } from '../../Firebase';
import { compose } from 'recompose';
import { withCurrentUser } from '../../Authentication/context';
import * as ROUTES from '../../../constants/routes';
import { withRouter } from 'react-router-dom';
import { Button, Card, Row } from 'react-bootstrap';
import './style.scss'

const HomePage = () => (
    <MatchPage />
);

class UserList extends Component {
  constructor(props) {
    super(props);

    this.state = {
      loading: false,
      users: [],
    };
  }

  onMatch = event => {
    const currentUser = this.props.authUser;

    if(currentUser.matchedUserID == null) {
      currentUser.matchedUserID = event.target.value;

      this.props.firebase.db.collection("users").doc(currentUser.uid).set({
        matchedUserID: currentUser.matchedUserID
      }, {merge: true})
      .then(() => {
        this.props.history.push(ROUTES.ALREADY_MATCHED_PAGE);
      })
      .catch(error => {
        console.log(error);
      });
    }
    event.preventDefault();
    
  }

  onSkip = event => {
    const currentUser = this.props.authUser;
    currentUser.skippedUserIDs.push(event.target.value);

    this.props.firebase.db.collection("users").doc(currentUser.uid).set({
      skippedUserIDs: currentUser.skippedUserIDs
    }, {merge: true})
    .catch(error => {
      console.log(error);
    });
  }

  componentDidMount() {
    if(this.props.authUser.matchedUserID) {
      this.props.history.go(ROUTES.ALREADY_MATCHED_PAGE);
    }
    this.setState({ loading: true });

    console.log(this.props.history);

    this.unsubscribe = this.props.firebase.users()
      .onSnapshot(snapshot => {
        let users = [];

        snapshot.forEach(doc =>
          users.push({ ...doc.data(), uid: doc.id }),
        );
        
        this.setState({
          users,
          loading: false,
        });
      });
  }

  componentWillUnmount() {
    this.unsubscribe();
  }

  componentDidUpdate() {
    console.log("red");
  }

  render() {
    const { users, loading } = this.state;

    let mappedUsers = [];

    const isTeacher = this.props.authUser.isTeacher;
    
    const currentUser = this.props.authUser;

    for(let i = 0; i < users.length; i++) {
      if(currentUser.isTeacher !== users[i].isTeacher && 
        !currentUser.skippedUserIDs.includes(users[i].uid) &&
        (users[i].matchedUserID === null || users[i].matchedUserID === currentUser.uid) &&
        !users[i].skippedUserIDs.includes(currentUser)){
        if(users[i].photoURL === null) {
          users[i].photoURL = "https://x-treme.com.mt/wp-content/uploads/2014/01/default-team-member.png";
        }
        mappedUsers.push(users[i]);
      }
    }

    return(
      <div className="match-page">
        <h1>Find your match</h1>
        { loading && <div>Loading ...</div> }
        
        <div className="user-cards">
            {mappedUsers.map(user => (
              <Row xs={14} md={14}>
                <Card bg="dark" style={{ width: '18rem' }} className="profile-card">
                  <Card.Img variant="top" src={user.photoURL} className="profile-image"/>
                  <Card.Body className="profile-body">
                      <Card.Title>{ user.username }</Card.Title>
                      {!isTeacher &&<Card.Subtitle>Teacher</Card.Subtitle>}
                      {isTeacher &&<Card.Subtitle>Student</Card.Subtitle>}
                          <Card.Text>
                              User description + tehcnologies he knows
                          </Card.Text>
                      <Button value={user.uid} onClick={this.onMatch} variant="dark">Match</Button>
                      <Button value={user.uid} onClick={this.onSkip} variant="dark">Skip</Button>
                  </Card.Body>
                </Card>
              </Row>
            ))}
      </div>
    </div>
    )
  }

}

const condition = authUser => !!authUser;

const MatchPage =  compose (
  withRouter,
  withFirebase,
  withCurrentUser
)(UserList);

export default withAuthorization(condition)(HomePage);

export { MatchPage };