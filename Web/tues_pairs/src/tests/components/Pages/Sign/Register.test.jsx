import React from 'react';
import { createMemoryHistory } from 'history';
import { Router } from 'react-router-dom';
import { fireEvent, render, waitForDomChange } from '@testing-library/react';
import { FirebaseContext } from '../../../../components/Firebase';
import MockedFirebase from '../../../Firebase/MockedFirebase';
import SingUpPage from '../../../../components/Pages/Sign/register';

test('full app rendering/navigating', () => {
    const history = createMemoryHistory();
    const firebaseMock = new MockedFirebase();
    const container = render(
        <FirebaseContext.Provider value={firebaseMock}>
            <Router history={history}>
                <SingUpPage />
            </Router>
        </FirebaseContext.Provider>

    );

    var users = {
        create: function (credentials) {
          return firebaseMock.auth.createUser(credentials);
        }
    };
    
    const emailInput = container.getByLabelText('email');
    fireEvent.change(emailInput, { target: { value: 'webexample@gmail.com'} });

    expect(emailInput.value).toBe('webexample@gmail.com');

    const passwordInputOne = container.getByLabelText('passwordOne');
    fireEvent.change(passwordInputOne,  { target: { value: 'example'} });

    expect(passwordInputOne.value).toBe('example');

    const passwordInputTwo = container.getByLabelText('passwordTwo');
    fireEvent.change(passwordInputTwo,  { target: { value: 'example'} });

    expect(passwordInputTwo.value).toBe('example');

    const submitButton = container.getByTestId('signup-button');
    fireEvent.click(submitButton);

    users.create({
        email: 'webexample@example.com',
        passwod: 'example'
    });

    const checkUser = {
        email: 'webexample@example.com',
        passwod: 'example'
    };

    firebaseMock.auth.flush();

    firebaseMock.auth.getUserByEmail('webexample@exapmle.com').then(function(user) {
        expect(checkUser).toBe(user);
    });

});