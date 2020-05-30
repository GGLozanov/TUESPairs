import React from 'react';

import { withFirebase } from '../../Firebase';
import { withCurrentUser } from '../../Authentication/context';
import { compose } from 'recompose';

const SignOutButtonBase = ({ firebase, authUser }) => {
        function signOut() {
            firebase.doSignOut(authUser)
        }
        return(
            <button type="button" data-testid="signout-button" onClick={signOut}>
                Sign Out
            </button>
        )
            
}

const SignOutButton = compose(
    withFirebase,
    withCurrentUser
)(SignOutButtonBase);

export default SignOutButton;