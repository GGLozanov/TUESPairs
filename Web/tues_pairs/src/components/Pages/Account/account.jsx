import React, { Component } from 'react';
import { withAuthorization } from '../../Authentication';
import { compose } from 'recompose';
import { withCurrentUser } from '../../Authentication/context';
import { withFirebase } from '../../Firebase';
import { Button } from 'react-bootstrap';
import './style.scss';
import log from '../../../constants/logger.jsx';
import Loading from '../../../constants/loading';
import UserCard from '../../../constants/user_card';

const AccountPage = () => (
    <div>
        <UserProfilePage />
    </div>
);

class UserProfile extends Component {
    constructor(props) {
        super(props);

        this.state = {
            tags: [],
            error: '',
            message: '',
            loading: true,
        };
    }

    componentDidMount(){
        let currentUser = this.props.authUser;
        this.setState({ loading: true });
    
        this.unsubscribe = this.props.firebase.user(currentUser.uid).get()
        .then(snapshot => {
            const currentUser = this.props.firebase.getUserFromSnapshot(snapshot);
            log.info("Received current user inside account! Current user is: " + currentUser.toString());
            this.setState({ currentUser, loading: false });
        }).then(() => {
            let tags = [];
            
            currentUser.tagIDs.forEach(tid => {
                this.props.firebase.tag(tid).get()
                .then(tag => {
                    log.info("Received current user tag inside account! Tag is: " + tag.toString());
                    tags.push(tag.data());
                    
                    this.setState({ tags });
                })
            });
        })
    }

    render() {
        const { currentUser, loading } = this.state;

        return(
            <div className="page-main">
                { loading && <Loading /> }

                <UserCard user={currentUser} />
                <Button href="/edit_personal_info" variant="dark">Edit your personal info</Button>
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