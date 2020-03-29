import React, { Component } from 'react';
import { PasswordChangeLink } from '../PasswordForget/passwordforget';
import { withAuthorization } from '../../Authentication';
import * as ROUTES from '../../../constants/routes';
import { Link } from 'react-router-dom';
import { compose } from 'recompose';
import { withCurrentUser } from '../../Authentication/context';
import { withFirebase } from '../../Firebase';

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

    onSaveChanges = event => {
        const { username, GPA } = this.state;
        const currentUser = this.props.authUser;
    
        this.props.firebase.db.collection("users").doc(currentUser.uid).set({
            username: username,
            GPA: parseFloat(GPA),
          }, {merge: true})
          .then(() => {
              this.setState({ message: "You have successffuly updated your profile! "})
          })
          .catch(error => {
            this.setState({ error });
          });
    
        event.preventDefault();
      };
    
    onChange = event => {
        this.setState({ [event.target.name]: event.target.value });
    };

    onDelete = () => {
        let users = [];

        const currentUser = this.props.authUser;

        this.props.firebase.users()
            .onSnapshot(snapshot => {

                snapshot.forEach(doc =>
                    users.push({ ...doc.data(), uid: doc.id }),
            );

            for(let i = 0; i < users.length; i++) {
                if(users[i].matchedUserID === currentUser.uid){
                    this.props.firebase.db.collection("users").doc(users[i].uid).set({
                        matchedUserID: null
                    }, {merge: true});
                }
                if(users[i].skippedUserIDs.includes(currentUser.uid)){
                    users[i].skippedUserIDs.splice(currentUser.uid, 1);
                    this.props.firebase.db.collection("users").doc(users[i].uid).set({
                        skippedUserIDs: users[i].skippedUserIDs
                    }, {merge: true});
                }
            }
        });

        this.props.firebase.db.collection("users").doc(currentUser.uid).delete()
        .then(this.props.firebase.auth.currentUser.delete())
        .catch(error => {
            this.setState({ error });
        });
    }

    render() {
        const { username, email, photoURL, error, message, GPA} = this.state;

        const isInvalid =
            username === '' || GPA === '';

        return(
            <div>
                <h1>Account: {username}</h1>
                <img src={photoURL} alt="Your profile pricture" height="200" width="200"></img>
                <h2>Email: {email}</h2>
                <h3>GPA: {GPA}</h3>

                <PasswordChangeLink />
                <Link to={ROUTES.IMAGE_UPLOAD}>Update your profile picture</Link>

                <br /><br />

                <form onSubmit={this.onSubmit}>
                    Username: 
                    <input
                        name="username"
                        value={username}
                        onChange={this.onChange}
                        type="text"
                        placeholder={this.props.authUser.username}
                    />
                    <br /><br />

                    GPA: 
                    <input 
                        name="GPA"
                        value={GPA}
                        onChange={this.onChange}
                        type="number"
                        placeholder={this.props.authUser.GPA}
                        min="2.01"
                        step="0.01"
                        max="6.00"
                    />

                    <br /><br /><br />

                    <button disabled={isInvalid} onClick={this.onSaveChanges}>
                        Save Changes
                    </button>

                    <button type="button" onClick={this.onDelete}>Delete</button>

                    {error && <p>{error.message}</p>}
                    {message && <p>{message}</p>}
                </form>
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