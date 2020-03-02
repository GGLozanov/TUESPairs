import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/screens/loading/loading.dart';
import 'package:tues_pairs/templates/baseauth.dart';
import 'package:tues_pairs/services/auth.dart';
import 'package:tues_pairs/modules/user.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView}); // create a constructor which inits this property toggleView

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final BaseAuth baseAuth = new BaseAuth();

  @override
  Widget build(BuildContext context) {
    return baseAuth.isLoading ? Loading() : Scaffold(
      // Scaffold grants the material design palette and general layout of the app (properties like appBar)
      appBar: AppBar(
          backgroundColor: Colors.teal[500],
          title: Text(
              'Register',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              )
          ),
        // actions take a list of Widgets and are used to display available actions on the AppBar
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () {widget.toggleView();}, // since the toggleView() function is known in the context of the widget, we need to address the widget and then access it
            icon: Icon(Icons.lock),
            label: Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                )
            ),
          )
        ],
      ),

      body: Container( // Container grants access to basic layout principles and properties
        color: Colors.teal[400],
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Form(
            key: baseAuth.key, // set the form's key to the key defined above (keeps track of the state of the form)
            child: Column( // Column orders widgets in a Column and its children property takes a list of Widgets
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
                  child: Text(
                    'Welcome to TUESPairs',
                    style: TextStyle(
                      color: Colors.orange[400],
                      fontFamily: 'BebasNeue',
                      letterSpacing: 1.0,
                      fontSize: 40.0,
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  onChanged: (value) => setState(() {baseAuth.email = value;}), // onChanged property takes a function with val and can be used to update our form properties with the passed values
                  // validator property is used for the validation of separate TextFormFields (takes a function with a value and you can
                  validator: (value) => value.isEmpty ? 'Enter an e-mail' : null, // validator returns string (tag to put on the field if input is invalid)
                  keyboardType: TextInputType.emailAddress, // optimize type set to e-mail
                  decoration: InputDecoration(
                    icon: Icon(Icons.mail),
                    hintText: 'Enter an e-mail',
                  ),
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  obscureText: true, // obscures text (like for a password)
                  onChanged: (value) => setState(() {baseAuth.password = value;}),
                  validator: (value) => value.isEmpty ? 'Enter a password' : null,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock),
                    hintText: 'Enter a password',
                  ),
                ),
                SizedBox(height: 25.0),
                baseAuth.isCurrentAdmin ? SizedBox() : TextFormField( // if the current user wants to be a teacher, he doesn't need GPA field
                   // parse the given string to a double
                  onChanged: (value) => baseAuth.GPA = double.tryParse(value),
                  validator: (value) {
                    double GPA = double.tryParse(value); 
                    if(GPA == null || value.isEmpty || GPA < 2 || GPA > 6){
                      return "Incorrect GPA (Range: 2 to 6)";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    icon: Icon(Icons.border_color),
                    hintText: 'Enter GPA throughout 8-12th grade',
                  ),
                ),
                SizedBox(height: 25.0),
                Switch(
                  value: baseAuth.isCurrentAdmin, // has the current user selected the isAdmin property
                  onChanged: (value) => setState(() => baseAuth.isCurrentAdmin = value),  // Rerun the build method in order for the switch to actually change
                ),
                SizedBox(height: 15.0),
                RaisedButton(
                  onPressed: () async {
                    // the form is valid only when each time the validator receives null as a result (this affects the key for the form)
                    if(baseAuth.key.currentState.validate()) { // access the currentState property of the key and run the validate() method on it (checks if the input is valid)
                      setState(() => baseAuth.toggleLoading()); // toggle the loading widget and rerun the build method
                      User user = await baseAuth.authInstance.registerUserByEmailAndPassword(baseAuth.email, baseAuth.password, null, baseAuth.GPA, baseAuth.isCurrentAdmin);
                      // TODO: Don't have tags be null

                      if(user == null) {
                        setState(() => baseAuth.errorMessage = 'Please enter valid credentials'); // rerun the build method and update the Text widget below holding the error message
                        baseAuth.toggleLoading();
                      }
                      // if the input is valid, create the user with the inputted email and password and return him
                      // the auth state changes if the result is successful, so the user gets rerouted to the homepage
                    }
                  },
                
                  color: Colors.cyanAccent,
                  child: Text( // TO-DO: Encapsulate text into custom widget
                      'Sign up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      )
                  )
                ),
                SizedBox(height: 15.0),
                Text(
                  baseAuth.errorMessage ?? '',
                  style: TextStyle(
                    color: Colors.redAccent[200],
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
