import React from 'react';
import { createMemoryHistory } from 'history';
import { Router } from 'react-router-dom';
import { fireEvent, render, waitForDomChange } from '@testing-library/react';
import SignInPage from '../../../../components/Pages/Sign/login';
import Firebase ,{ FirebaseContext } from '../../../../components/Firebase';
import MockedFirebase from '../../../Firebase/MockedFirebase';

test('full app rendering/navigating', () => {
    const history = createMemoryHistory();
    const container = render(
        <FirebaseContext.Provider value={new MockedFirebase()}>
            <Router history={history}>
                <SignInPage />
            </Router>
        </FirebaseContext.Provider>

    );
    const emailInput = container.getByLabelText('email');
    fireEvent.change(emailInput, { target: { value: 'webexample123456@gmail.com'} });

    expect(emailInput.value).toBe('webexample123456@gmail.com');

    const passwordInput = container.getByLabelText('password');
    fireEvent.change(passwordInput ,  { target: { value: 'example'} });

    expect(passwordInput.value).toBe('example');

    const submitButton = container.getByTestId('signin-button');
    fireEvent.click(submitButton);
});