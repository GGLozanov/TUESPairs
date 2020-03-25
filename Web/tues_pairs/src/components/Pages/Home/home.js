import React, { Component } from 'react';
import { withAuthorization } from '../../Authentication';
import { withFirebase } from '../../Firebase';
import { compose } from 'recompose';
import { withCurrentUser } from '../../Authentication/context';

const HomePage = () => (
  <div>
    <h1>Home Page</h1>
    <MatchPage />
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

    for(let i = 0; i < users.length; i++) {
      if(this.props.authUser.isTeacher !== users[i].isTeacher) { 
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
                <img src={user.photoURL} alt="Please wait" height="32" width="32"></img>
                <span>
                  <strong>ID:</strong> {user.uid}
                </span>
                <span>
                  <strong>E-Mail:</strong> {user.email}
                </span>
                <span>
                  <strong>Username:</strong> {user.username}
                </span>
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
  withFirebase,
  withCurrentUser
)(UserList);

export default withAuthorization(condition)(HomePage);

export { MatchPage };