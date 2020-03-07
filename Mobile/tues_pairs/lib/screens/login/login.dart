import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/templates/baseauth.dart';
import 'package:tues_pairs/screens/loading/loading.dart';
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
    return baseAuth.isLoading ? Loading() : Scaffold(

      appBar: AppBar(
        backgroundColor: Color.fromRGBO(33, 36, 44, 1),
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
              icon: Icon(
                Icons.person,
                color: Colors.orange,
                size: 30.0,
              ),
              label: Text(
                'Register',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  fontSize: 25.0,
                )
              ),
          )
        ],
      ),

      body: Container(
        color: Color.fromRGBO(59, 64, 78, 1),
        child: Form(
          key: baseAuth.key,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0), // Padding accessed by EdgeInsets
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
                  child: Text(
                    'Welcome to TUESPairs',
                    style: TextStyle(
                      color: Colors.orange,
                      fontFamily: 'BebasNeue',
                      letterSpacing: 1.0,
                      fontSize: 40.0,
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  onChanged: (value) => setState(() => baseAuth.user.email = value), // need to define the setState() method as to rerun the build method each time we change the inputs
                  validator: (value) => value.isEmpty ? 'Enter an e-mail' : null,
                  keyboardType: TextInputType.emailAddress,
                  decoration: textInputDecoration.copyWith(
                    icon: Icon(
                      Icons.mail,
                      color: Colors.orange,
                    ),
                    hintText: 'Enter email',
                  ),
                ),
                SizedBox(height: 15.0), // SizedBox widget creates an invisible box with a height/width to help separate elements
                TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  onChanged: (value) => setState(() => baseAuth.user.password = value),
                  validator: (value) => value.isEmpty ? 'Enter a password' : null,
                  decoration: textInputDecoration.copyWith(
                    icon: Icon(
                      Icons.lock,
                      color: Colors.orange,
                    ),
                    hintText: 'Enter password',
                  ),
                ),
                SizedBox(height: 25.0),
                ButtonTheme(
                  minWidth: 250.0,
                  height: 60.0,
                  child: RaisedButton(
                    child: Text(
                      'Log in',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    textColor: Colors.white,
                    color: Color.fromRGBO(33, 36, 44, 1),
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () async {
                      if(baseAuth.key.currentState.validate()) {
                        setState(() => baseAuth.toggleLoading());
                        User user = await baseAuth.authInstance.loginUserByEmailAndPassword(baseAuth.user.email, baseAuth.user.password); // call the login method
                        if(user == null) {
                          setState(() {
                            baseAuth.errorMessages = [];
                            baseAuth.errorMessages.add('Invalid login credentials');
                            baseAuth.toggleLoading();
                          });

                        }
                      }
                    },
                  ),
                ),
                
                SizedBox(height: 15.0),
                Column(
                  children: baseAuth.errorMessages?.map((message) => Text(
                    "$message",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 15.0,
                    ),
                  ))?.toList() ?? [],
                ),
              ],
            ),
          )
        )
      ),
    );
  }
}

