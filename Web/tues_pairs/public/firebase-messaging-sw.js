importScripts('https://www.gstatic.com/firebasejs/7.13.2/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/7.13.2/firebase-messaging.js');

firebase.initializeApp({
    apiKey: "AIzaSyAB7quBVKdWxF6LCmfkJ49C6oawDiiaSvU",
    authDomain: "tuespairs-production.firebaseapp.com",
    databaseURL: "https://tuespairs-production.firebaseio.com",
    projectId: "tuespairs-production",
    storageBucket: "tuespairs-production.appspot.com",
    messagingSenderId: "985891410700",
    appId: "1:985891410700:web:c9a95ac7dec65426f92f29",
    measurementId: "G-9HTMDTFG2J"
});

const initMessaging = firebase.messaging();