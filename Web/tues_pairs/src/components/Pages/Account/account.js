import React from 'react';
import { PasswordChangeLink } from '../PasswordForget/passwordforget';
import { AuthUserContext, withAuthorization } from '../../Authentication';
import * as ROUTES from '../../../constants/routes';

const AccountPage = () => (
    <AuthUserContext.Consumer>
        {authUser => (
            <div>
                <h1>Account: {authUser.username}</h1>
                <h2>Email: {authUser.email}</h2>
                <PasswordChangeLink />
            </div>
        )}
    </AuthUserContext.Consumer>
);

const condition = authUser => !!authUser;

export default withAuthorization(condition)(AccountPage);