import React from 'react';

import { withFirebase } from '../../Firebase';
import { withCurrentUser } from '../../Authentication/context';
import { compose } from 'recompose';

const SignOutButtonBase = ({ firebase }) => {
        return(
            <button type="button" data-testid="signout-button" onClick={firebase.doSignOut}>
                Sign Out
            </button>
        )
            
}

const SignOutButton = compose(
    withFirebase,
    withCurrentUser
)(SignOutButtonBase);

export default SignOutButton;