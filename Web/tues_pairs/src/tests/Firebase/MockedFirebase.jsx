import React from 'react';
let firebaseMock = require('firebase-mock');

export default class MockedFirebase {
    constructor() {

        this.auth = new firebaseMock.MockAuthentication();
        this.db = new firebaseMock.MockFirestore();
        this.storage = new firebaseMock.MockStorage();
    }

    doCreateUserWithEmailAndPassword = (email, password) =>
        this.auth.createUserWithEmailAndPassword(email, password);

    doSignInWithEmailAndPassword = (email, password) =>
        this.auth.signInWithEmailAndPassword(email, password);

    doSignOut = () => this.auth.signOut();
}
