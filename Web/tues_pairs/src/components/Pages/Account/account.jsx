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
import * as ROUTES from '../../../constants/routes';
import { withRouter, Link } from 'react-router-dom';

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
            if(currentUser.username == null) {
                this.props.history.push(ROUTES.USER_INFO);
            }
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
                <Link to={ROUTES.EDIT_PERSONAL_INFO}>
                    <Button variant="dark">Edit your personal info</Button>
                </Link>
            </div>
        )
    }
}



const condition = authUser => !!authUser;

const UserProfilePage = compose (
    withRouter,
    withFirebase,
    withCurrentUser,
)(UserProfile);

export default withAuthorization(condition)(AccountPage);