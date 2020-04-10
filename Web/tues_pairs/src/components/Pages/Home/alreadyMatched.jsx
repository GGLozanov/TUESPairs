import React, { Component } from 'react';
import { Button } from 'react-bootstrap';
import { withAuthorization } from '../../Authentication';
import * as ROUTES from '../../../constants/routes';
import { withRouter } from 'react-router-dom';
import { compose } from 'recompose';
import './style.scss';
import { withCurrentUser } from '../../Authentication/context';

class AlreadyMatched extends Component {
    constructor(props) {
        super(props);
    }

    handleCancelMatched = () => {
        const currentUser = this.props.authUser;

        this.props.firebase.db.collection("users").doc(currentUser.uid).set({
                matchedUserID: null,
            }, 
        {merge: true})
        .then(() => {
            this.props.history.push(ROUTES.HOME);
        })
        .catch(error => {
            console.error(error);
            this.setState({ error });
        });
    }

    render() {
        return(
            <div className="already-matched-page">
                <p>You have sent a match request!</p>
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