import React, { Component } from 'react';
import { withAuthorization } from '../../Authentication';
import { withFirebase } from '../../Firebase';
import { compose } from 'recompose';
import { withCurrentUser } from '../../Authentication/context';
import * as ROUTES from '../../../constants/routes';
import { withRouter } from 'react-router-dom';

const HomePage = () => (
  <div>
    <h1>Home Page</h1>
    <MatchPage />
  </div>
);

const AlreadyMatchedPage = () => (
  <div>
    <h1>Match Page</h1>
    <p>You have sent a match request!</p>
  </div>
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

  componentDidMount(){
    this.setState({ loading: true });

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

  render() {
    const { users, loading } = this.state;

    let mappedUsers = [];
    
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
      <div>
        <h1>Users</h1>
        { loading && <div>Loading ...</div> }
        
        <div>
          <ul>
            {mappedUsers.map(user => (
              <li key={user.uid}>
                <span>
                  <img src={user.photoURL} alt="Please wait" height="50" width="50"></img>
                </span>
                <span>
                  <strong>Username:</strong> {user.username}
                </span>
                <span>
                  <strong>Gpa:</strong> {user.GPA}
                </span>
                <button type="submit" value={user.uid} onClick={this.onMatch}>Match</button>
                <button type="submit" value={user.uid} onClick={this.onSkip}>Skip</button>
              </li>
            ))}
        </ul>
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

export { MatchPage, AlreadyMatchedPage };