import React from 'react';
import { PasswordChangeLink } from '../PasswordForget/passwordforget';
import { AuthUserContext, withAuthorization } from '../../Authentication';
import * as ROUTES from '../../../constants/routes';
import { Link } from 'react-router-dom';

const AccountPage = () => (
    <AuthUserContext.Consumer>
        {authUser => (
            <div>
                <h1>Account: {authUser.username}</h1>
                <img src={authUser.photoURL} alt="Your profile pricture" height="200" width="200"></img>
                <h2>Email: {authUser.email}</h2>
                <PasswordChangeLink />
                <Link to={ROUTES.IMAGE_UPLOAD}>Update your profile picture</Link>
            </div>
        )}
    </AuthUserContext.Consumer>
);

const condition = authUser => !!authUser;

export default withAuthorization(condition)(AccountPage);