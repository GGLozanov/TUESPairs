import app from 'firebase/app';
import 'firebase/auth';
import 'firebase/firestore';
import 'firebase/storage';

const config = {
    apiKey: "AIzaSyCKbaA0epDZJnNLaehLEb5iuhwHAbXCe7Y",
    authDomain: "tuespairs.firebaseapp.com",
    databaseURL: "https://tuespairs.firebaseio.com",
    projectId: "tuespairs",
    storageBucket: "tuespairs.appspot.com",
    messagingSenderId: "911913368022",
    appId: "1:911913368022:web:4035568fc570db81208c77",
    measurementId: "G-8WP9R10Q34"
  };

  class Firebase {
    constructor() {
        app.initializeApp(config);

        this.auth = app.auth();
        this.db = app.firestore();
        this.storage = app.storage();
    }

    doCreateUserWithEmailAndPassword = (email, password) =>
        this.auth.createUserWithEmailAndPassword(email, password);

    doSignInWithEmailAndPassword = (email, password) =>
        this.auth.signInWithEmailAndPassword(email, password);

    doSignOut = () => this.auth.signOut();

    doPasswordReset = email => this.auth.sendPasswordResetEmail(email);

    doPasswordUpdate = password =>
        this.auth.currentUser.updatePassword(password);

    doEmailUpdate = email => this.auth.currentUser.updateEmail(email);

    // *** User API ***

    getCurrentUser = async () => this.auth.currentUser;

    user = uid => this.db.doc(`users/${uid}`);

    users = () => this.db.collection(`users`);

    messages = () => this.db.collection(`messages`);
    
  }

  export default Firebase;