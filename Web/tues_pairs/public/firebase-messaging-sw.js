importScripts('https://www.gstatic.com/firebasejs/7.13.2/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/7.13.2/firebase-messaging.js');

firebase.initializeApp({
    apiKey: "AIzaSyCKbaA0epDZJnNLaehLEb5iuhwHAbXCe7Y",
    authDomain: "tuespairs.firebaseapp.com",
    databaseURL: "https://tuespairs.firebaseio.com",
    projectId: "tuespairs",
    storageBucket: "tuespairs.appspot.com",
    messagingSenderId: "911913368022",
    appId: "1:911913368022:web:4035568fc570db81208c77",
    measurementId: "G-8WP9R10Q34"
});

const initMessaging = firebase.messaging();