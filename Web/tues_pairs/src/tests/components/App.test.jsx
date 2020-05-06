import React from 'react';
import { render } from '@testing-library/react';
import App from '../../components/App';
import { FirebaseContext } from '../../components/Firebase';
import MockedFirebase from '../Firebase/MockedFirebase';

test('Renders the basic App component and mocks Firebase', () => {

    render(
        <FirebaseContext.Provider value={new MockedFirebase()}>
            <App />
        </FirebaseContext.Provider>
    );
});