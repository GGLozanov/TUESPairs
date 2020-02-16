import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/services/auth.dart';

class Login extends StatefulWidget {
  final Function toggleView;

  Login({this.toggleView});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final Auth _auth = Auth();

  final _key = GlobalKey<FormState>(); // creating a global key again to identify our form

  String email = ''; // TO-DO: optimise code later on with one superwidget containing email and password (maybe extends Authenticate?)
  String password = '';
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // TO-DO: Encapsulate widget in one class
        backgroundColor: Colors.grey[400],
        title: Text(
            'Login',
            style: TextStyle(
              color: Colors.white,
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            )
        ),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () => widget.toggleView(), // since the toggleView() function is known in the context of the widget, we need to address the widget and then access it
              icon: Icon(Icons.person),
              label: Text(
                'Register',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                )
              ),
          )
        ],
      ),

      body: Container(
        color: Colors.grey[500],
        child: Form(
          key: _key,
          child: Padding(
            padding: EdgeInsets.all(20.0), // Padding accessed by EdgeInsets
            child: Column(
              children: <Widget>[
                SizedBox(height: 15.0),
                TextFormField(
                  onChanged: (value) => setState(() => email = value), // need to define the setState() method as to rerun the build method each time we change the inputs
                  validator: (value) => value.isEmpty ? 'Enter an e-mail' : null,
                  keyboardType: TextInputType.emailAddress,

                ),
                SizedBox(height: 15.0), // SizedBox widget creates an invisible box with a height/width to help separate elements
                TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (value) => setState(() => value.isEmpty ? 'Enter a password' : null),
                ),
                SizedBox(height: 15.0),
                RaisedButton(
                  onPressed: () async {
                    if(_key.currentState.validate()) {
                      FirebaseUser user = await _auth.loginUserByEmailAndPassword(email, password); // call the login method
                      if(user == null) {
                        setState(() => errorMessage = 'Invalid login credentials');
                      }
                    }
                  },
                  color: Colors.cyanAccent,
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    )
                  )
                ),
                Text(
                    errorMessage,
                    style: TextStyle(
                      color: Colors.redAccent[200],
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    )
                )
              ],
            ),
          )
        )
      ),
    );
  }
}

