import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/modules/tag.dart';
import 'package:tues_pairs/screens/loading/loading.dart';
import 'package:tues_pairs/shared/keys.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/templates/baseauth.dart';
import 'package:tues_pairs/services/image.dart';
import 'package:tues_pairs/widgets/register/register_form.dart';
import 'package:tues_pairs/widgets/register/tag_selection.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  static AnimationController controller;
  static int topPageIndex = 1; // TODO: Change if add more pages (keep track of pages)
  static int currentPage = topPageIndex;

  Register({this.toggleView}); // create a constructor which inits this property toggleView

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> with SingleTickerProviderStateMixin {

  final BaseAuth baseAuth = new BaseAuth();
  final ImageService imageService = new ImageService();

  @override
  void initState() {
    super.initState();
    Register.controller = new AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    Register.controller.forward();
  }

  @override
  Widget build(BuildContext context) {

    void switchPage({bool isLoading}) {
      // replace current stack widget with reverse stack widget
      // with animation
      setState(() { if(isLoading != null && isLoading) baseAuth.toggleLoading(); });
    }

    return baseAuth.isLoading ? Loading() : Scaffold( // Scaffold grants the material design palette and general layout of the app (properties like appBar)
      key: Key(Keys.registerScaffold),
      backgroundColor: greyColor,
      appBar: AppBar(
        backgroundColor: darkGreyColor,
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
            key: Key(Keys.toggleToLoginButton),
            onPressed: () {widget.toggleView();}, // since the toggleView() function is known in the context of the widget, we need to address the widget and then access it
            icon: Icon(
              Icons.lock,
              color: Colors.orange,
              size: 30.0,
            ),
            label: Text(
              'Log in',
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

      body: IndexedStack(
        index: Register.currentPage,
        children: [
          Align(
            alignment: Alignment.center,
            child: Provider<BaseAuth>.value(
              value: baseAuth,
              child: TagSelection(switchPage: switchPage, animationController: Register.controller,),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: MultiProvider(
              providers: [
                Provider<BaseAuth>.value(value: baseAuth),
                Provider<ImageService>.value(value: imageService),
              ],
              child: RegisterForm(switchPage: switchPage, animationController: Register.controller,),
            ),
          ),
        ],
      ),
    );
  }
}
