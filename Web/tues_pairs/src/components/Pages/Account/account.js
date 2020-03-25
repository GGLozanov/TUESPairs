import React from 'react';
import { PasswordForgetForm } from '../PasswordForget/passwordforget';
import PasswordChangeForm from '../PasswordChange/passwordchange';
import { AuthUserContext, withAuthorization } from '../../Authentication';

const AccountPage = () => (
    <AuthUserContext.Consumer>
        {authUser => (
            <div>
                <h1>Account: {authUser.email}</h1>
                <PasswordForgetForm />
                <PasswordChangeForm />
            </div>  
        )}
    </AuthUserContext.Consumer>
);

const condition = authUser => !!authUser;

export default withAuthorization(condition)(AccountPage);