import React from 'react';

import { withFirebase } from '../../Firebase';

const SignOutButton = ({ firebase }) => (
    <button classnName="signout-button" type="button" onClick={firebase.doSignOut}>
        Sign Out
    </button>
);

export default withFirebase(SignOutButton);