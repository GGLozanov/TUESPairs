import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/modules/tag.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/services/image.dart';
import 'package:tues_pairs/shared/keys.dart';
import 'package:tues_pairs/templates/baseauth.dart';
import 'package:tues_pairs/screens/loading/loading.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/widgets/form/input_button.dart';
import 'package:tues_pairs/widgets/form/email_input_field.dart';
import 'package:tues_pairs/widgets/form/password_input_field.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/widgets/register/register_form.dart';
import 'package:tues_pairs/widgets/register/register_wrapper.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../templates/baseauth.dart';
import '../authlistener.dart';

class Login extends StatefulWidget {
  final Function toggleView;
  static bool isExternalCreated = false; // check if the user has successfully created an external account (used for authlistener)

  Login({this.toggleView});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final BaseAuth baseAuth = new BaseAuth();
  final GlobalKey _scaffold = GlobalKey(); // global key used to track the scaffold an the currentContext

  StreamSubscription _subs; // return from listen() on a stream => StreamSubscription

  List<User> users;
  List<Tag> tags;

  @override
  void initState() {
    _initDeepLinkListener();
    super.initState();
  }

  @override
  void dispose() {
    _disposeDeepLinkListener();
    super.dispose();
  }

  Future<void> _initDeepLinkListener() async {
    _subs = getLinksStream().listen((String link) {
      _checkDeepLink(link); // checks whether the deep link from the link stream is valid
    }, cancelOnError: true);
  }

  void _checkDeepLink(String link) {
    if (link != null) {
      // if the link is valid, we receive the code using regex and moving 5 indices forward
      String code = link.substring(link.indexOf(RegExp('code=')) + 5);
      baseAuth.authInstance.signInWithGitHub(code) // Auth code received from parse
        .then((authUser) {
          _configureExternalSignIn(authUser);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context){
            return AuthListener.callback(externRegister: AuthListener.externRegister,);
          }));
        }
      ).catchError((e) {
        logger.e('Login: _checkDeepLink() has thrown an exception while authenticating GitHub user!');
      });
    }
  }

  void _disposeDeepLinkListener() {
    if (_subs != null) {
      _subs.cancel();
      _subs = null;
    }
  }

  void _configureExternalSignIn(User authUser) {
    baseAuth.user = authUser;
    baseAuth.user.isTeacher = false;
    baseAuth.user.tagIDs = <String>[];
    AuthListener.externRegister.baseAuth = baseAuth;
    AuthListener.externRegister.tags = tags;
    AuthListener.externRegister.users = users;
    Login.isExternalCreated = true;
  }

  Future<void> _redirectToGitHub() async {
    const String url = 'https://github.com/login/oauth/authorize' +
      '?client_id=' + GITHUB_CLIENT_ID +
        '&scope=public_repo%20read:user%20user:email'; // url to auth the GitHub user

    if (await canLaunch(url)) { // async call that checks whether the applicable url can be launched
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      ); // if so, launches it without enforcing WEB/Safari view (due to usage of DeepLink later on)
    } else {
      logger.e('Login: redirectToGitHub() cannot lauch this URL!');
      throw new PlatformException(
        code: 'ERROR_CANNOT_LAUNCH_GITHUB_URL', message: 'redirectToGitHub() cannot lauch the selected URL!'
      );
    }
  }

  Future<void> _handleExternalSignIn(BuildContext context,
      {ExternalSignInType signInType = ExternalSignInType.GOOGLE}) async {

    switch(signInType) {
      case ExternalSignInType.FACEBOOK:
        // handle faceboook sign-in w/ auth here...
        baseAuth.authInstance.loginWithFacebook().then((authUser) =>
            _configureExternalSignIn(authUser)
        ).catchError((e) =>
            logger.w('Login: User has cancelled/failed Facebook Sign-In. Rerendering login page')
        );
        break;
      case ExternalSignInType.GITHUB:
        // handle github sign-in w/ auth here...
        await _redirectToGitHub();
        break;
      case ExternalSignInType.GOOGLE:
      default:
        // handle Google sign-in w/ auth here...
        // check if user is already registered (return value of signin method)
       // TODO: Handle incorrect user entry exceptions; setState(() => {}) ?
        baseAuth.authInstance.signInWithGoogle().then((authUser) =>
          _configureExternalSignIn(authUser)
        ).catchError((e) => logger.w('Login: User has cancelled/failed Google Sign-In. Rerendering login page'));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

    users = Provider.of<List<User>>(context);
    tags = Provider.of<List<Tag>>(context);

    return baseAuth.isLoading ? Loading() : Scaffold(
      key: _scaffold,
      appBar: AppBar(
        backgroundColor: darkGreyColor,
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
            key: Key(Keys.toggleToRegisterButton),
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

      // TODO: Animate this segment w/implicit animations

      body: Container(
        color: greyColor,
        child: Form(
          key: baseAuth.key,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0), // Padding accessed by EdgeInsets
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
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
                EmailInputField(
                  key: Key(Keys.loginEmailInputField),
                  onChanged: (value) => setState(() => baseAuth.user.email = value),
                  initialValue: baseAuth.user.email,
                ),
                SizedBox(height: 15.0), // SizedBox widget creates an invisible box with a height/width to help separate elements
                PasswordInputField(
                  key: Key(Keys.loginPasswordInputField),
                  onChanged: (value) => setState(() => baseAuth.password = value),
                ),
                SizedBox(height: 25.0),
                InputButton(
                  key: Key(Keys.logInButton),
                  minWidth: 250.0,
                  height: 60.0,
                  text: 'Log in',
                  onPressed: () async {
                    if(baseAuth.key.currentState.validate()) {
                      setState(() => baseAuth.toggleLoading());

                      User user = await baseAuth.authInstance.loginUserByEmailAndPassword(baseAuth.user.email, baseAuth.password); // call the login method

                      if(user == null) {
                        logger.w('Login: Failed user login (invalid credentials)');
                        setState(() {
                          baseAuth.errorMessages = [];
                          baseAuth.errorMessages.add('Invalid login credentials');
                          baseAuth.toggleLoading();
                        });
                      } else logger.i('Login: User w/ id "' + user.uid + '" has successfully logged in');
                    }
                  },
                ),
                SizedBox(height: 25.0),
                Divider(height: 15.0, thickness: 10.0),
                SizedBox(height: 25.0),
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SignInButton(
                        Buttons.Facebook,
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        onPressed: () async => await _handleExternalSignIn(_scaffold.currentContext, signInType: ExternalSignInType.FACEBOOK),
                      ),
                      SizedBox(height: 15.0),
                      SignInButton(
                        Buttons.Google,
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        onPressed: () async => await _handleExternalSignIn(_scaffold.currentContext),
                      ),
                      SizedBox(height: 15.0),
                      SignInButton(
                        Buttons.GitHub,
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        onPressed: () async => await _handleExternalSignIn(_scaffold.currentContext, signInType: ExternalSignInType.GITHUB),
                      ),
                    ]
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

