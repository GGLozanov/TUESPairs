import React from 'react';
import { render, fireEvent, waitForDomChange } from '@testing-library/react';
import SignOutButton from '../../../../components/Pages/SignOut/signout';
import Firebase ,{ FirebaseContext } from '../../../../components/Firebase';
import { Router } from 'react-router-dom';
import { createMemoryHistory } from 'history';
import MockedFirebase from '../../../Firebase/MockedFirebase';

test('User signing out from app', async () => {
    const history = createMemoryHistory();
    const firebaseInstance = new MockedFirebase()
    const container = render(
        <FirebaseContext.Provider value={firebaseInstance}>
            <Router history={history}>
                <SignOutButton />
            </Router>
        </FirebaseContext.Provider>
    );

    const signOutButton = container.getByTestId('signout-button');

    fireEvent.click(signOutButton);

    expect(firebaseInstance.auth.currentUser).toBe(null);
});