import app from 'firebase/app';
import 'firebase/auth';
import 'firebase/firestore';
import 'firebase/storage';
import log from '../../constants/logger';

const config = {
    apiKey: "AIzaSyAB7quBVKdWxF6LCmfkJ49C6oawDiiaSvU",
    authDomain: "tuespairs-production.firebaseapp.com",
    databaseURL: "https://tuespairs-production.firebaseio.com",
    projectId: "tuespairs-production",
    storageBucket: "tuespairs-production.appspot.com",
    messagingSenderId: "985891410700",
    appId: "1:985891410700:web:c9a95ac7dec65426f92f29",
    measurementId: "G-9HTMDTFG2J"
  };

  class Firebase {
    constructor() {
        app.initializeApp(config);

        this.auth = app.auth();
        this.db = app.firestore();
        this.fieldValue = app.firestore.FieldValue;
        this.storage = app.storage();
        this.messaging = app.messaging();
    }

    doCreateUserWithEmailAndPassword = (email, password) =>
        this.auth.createUserWithEmailAndPassword(email, password);

    doSignInWithEmailAndPassword = (email, password) =>
        this.auth.signInWithEmailAndPassword(email, password);

    doSignOut = (currentUser) => {
        let deviceTokens = currentUser.deviceTokens;
        this.messaging.getToken().then(token => {
            if(currentUser.deviceTokens) {
                deviceTokens.splice(deviceTokens.indexOf(token), 1);
            }
            this.db.collection("users").doc(currentUser.uid).set({
                deviceTokens: deviceTokens
            }, {merge: true});
        }).then(() => {
            this.auth.signOut();
        })
        .catch(error => {
            log.error(error);
        });
    }

    doPasswordReset = email => this.auth.sendPasswordResetEmail(email);

    doPasswordUpdate = password =>
        this.auth.currentUser.updatePassword(password);

    doEmailUpdate = email => this.auth.currentUser.updateEmail(email);

    // *** User API ***

    getCurrentUser = async () => this.auth.currentUser;

    getCredentials = (email, password) => {
        return app.auth.EmailAuthProvider.credential(
            email,
            password
        ); 
    }

    user = uid => this.db.doc(`users/${uid}`);

    users = () => this.db.collection(`users`);

    messages = () => this.db.collection(`messages`);

    tags = () => this.db.collection(`tags`);

    tag = tid => this.db.doc(`tags/${tid}`);

    notifications = () => this.db.collection(`notifications`);

    getUserFromSnapshot = snapshot => {
        const firebaseUser = snapshot.data();
        let tags = [];
        if(firebaseUser !== undefined) {
            tags = this.getUserTags(firebaseUser.tagIDs);
        }
        let uid = null;
        if(this.auth.currentUser === null) {
            uid = null;
        } else {
            uid = this.auth.currentUser.uid;
        }

        return {
            ...firebaseUser,
            uid: uid,
            tags: tags,
            providerData: this.auth.currentUser.providerData
        };
    }
    
    getUserTags = tagIDs => {
        let tags = [];

        tagIDs.forEach(tag => {
            this.tag(tag).get()
            .then(doc => {
                tags.push({...doc.data(), tid: doc.id });
            })
        });

        return tags;
    }

    getUserNotifications = async (uid) => {
        let notifications = [];

        this.notifications().onSnapshot(snapshot => {
            snapshot.forEach(doc => {
                if(doc.data().userID === uid) { // Todo: Change that with firebase query filter method
                    notifications.push({ ...doc.data(), nid: doc.id });
                }
            })
        });

        return notifications;
    }

  }

  export default Firebase;