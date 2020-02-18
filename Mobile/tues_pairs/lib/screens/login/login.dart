import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/templates/baseauth.dart';
import 'package:tues_pairs/services/auth.dart';
import 'package:tues_pairs/modules/user.dart';

class Login extends StatefulWidget {
  final Function toggleView;

  Login({this.toggleView});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final BaseAuth baseAuth = new BaseAuth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // TO-DO: Encapsulate widget in one class
        backgroundColor: Colors.teal[500],
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
              onPressed: () {widget.toggleView();}, // since the toggleView() function is known in the context of the widget, we need to address the widget and then access it
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
        color: Colors.teal[400],
        child: Form(
          key: baseAuth.key,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0), // Padding accessed by EdgeInsets
            child: Column(
              children: <Widget>[
                SizedBox(height: 15.0),
                TextFormField(
                  onChanged: (value) => setState(() => baseAuth.email = value), // need to define the setState() method as to rerun the build method each time we change the inputs
                  validator: (value) => value.isEmpty ? 'Enter an e-mail' : null,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 15.0), // SizedBox widget creates an invisible box with a height/width to help separate elements
                TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (value) => setState(() => value.isEmpty ? 'Enter a password' : null),
                ),
                SizedBox(height: 25.0),
                RaisedButton(
                  onPressed: () async {
                    if(baseAuth.key.currentState.validate()) {
                      User user = await baseAuth.auth.loginUserByEmailAndPassword(baseAuth.email, baseAuth.password); // call the login method

                      if(user == null) {
                        setState(() => baseAuth.errorMessage = 'Invalid login credentials');
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
                    baseAuth.errorMessage,
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

