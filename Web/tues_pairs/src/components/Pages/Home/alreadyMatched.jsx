import React, { Component } from 'react';
import { Button} from 'react-bootstrap';
import { withAuthorization } from '../../Authentication';
import * as ROUTES from '../../../constants/routes';
import { withRouter } from 'react-router-dom';
import { compose } from 'recompose';
import './style.scss';
import { withCurrentUser } from '../../Authentication/context';
import log from '../../../constants/logger';
import Loading from '../../../constants/loading';
import UserCard from '../../../constants/user_card';

class AlreadyMatched extends Component {
    constructor(props) {
        super(props);

        this.state = {
            currentUser: this.props.authUser,
            matchedUser: Object,
            loading: '',
        }

    }

    componentDidMount() {
        this.setState({ loading: true });

        this.props.firebase.user(this.props.authUser.uid).get()
        .then(snapshot => {
            const currentUser = this.props.firebase.getUserFromSnapshot(snapshot);
            log.info("Received current user w/ id " + currentUser.uid);

            this.setState({ currentUser });
        }).then(() => {
            this.props.firebase.user(this.state.currentUser.matchedUserID).get()
            .then(snapshot => {
                if(snapshot.exists) {
                    const matchedUser = this.props.firebase.getUserFromSnapshot(snapshot);
                    log.info("Received matched user w/ id " + matchedUser.uid + " of current user");
                    
                    this.setState({ matchedUser, loading: false });
                }
            }).then(() => {
                let tags = [];
                
                this.state.matchedUser.tagIDs.forEach(tid => {
                    this.props.firebase.tag(tid).get()
                    .then(tag => {
                        tags.push(tag.data());
                        log.info("Received current tags w/ ids " + tag.toString());

                        this.setState({ tags, loading: false });
                    });
                });
            });
        });
    }

    handleCancelMatched = () => {
        const currentUser = this.props.authUser;

        this.props.firebase.db.collection("users").doc(currentUser.uid).set({
            matchedUserID: null,
        }, 
        {merge: true})
        .then(() => {
            log.info("Current user w/ id " + currentUser.uid + " has cancelled")
            this.props.history.push(ROUTES.HOME);
        })
        .catch(error => {
            log.error(error);
            this.setState({ error });
        });
    }

    render() {
        const { matchedUser, loading } = this.state;

        return(
            <div className="already-matched-page">
                { loading && <Loading /> }

                <div className="match-text">
                    <p>You have sent a match request</p>
                </div>
                <div className="matched-user-card">
                    <UserCard user={matchedUser} />
                </div>
                <Button onClick={this.handleCancelMatched} variant="dark">Cancel</Button>
            </div>
        )
    }
};

const condition = authUser => !!authUser

const AlreadyMatchedPage = compose(
    withCurrentUser,
    withRouter,
    withAuthorization(condition)
)(AlreadyMatched);

export default AlreadyMatchedPage;