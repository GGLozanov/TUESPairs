import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/modules/tag.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/screens/register/register.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/services/image.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/shared/keys.dart';
import 'package:tues_pairs/templates/baseauth.dart';
import 'package:tues_pairs/widgets/avatar/avatar_wrapper.dart';
import 'package:tues_pairs/widgets/form/GPA_input_field.dart';
import 'package:tues_pairs/widgets/form/input_button.dart';
import 'package:tues_pairs/widgets/form/username_input_field.dart';
import 'package:tues_pairs/widgets/form/email_input_field.dart';
import 'package:tues_pairs/widgets/form/password_input_field.dart';
import 'package:tues_pairs/widgets/form/confim_password_input_field.dart';
import 'package:tues_pairs/widgets/tag_display/tag_selection.dart';

class RegisterForm extends StatefulWidget {

  final Function switchPage;
  final AnimationController animationController;
  Function callback;

  bool isExternalAuth = false;

  Function formIsValid;
  Function registerUser;

  RegisterForm({
    @required this.switchPage,
    this.animationController
  }) : assert(switchPage != null) {

    formIsValid = (BaseAuth baseAuth, List<User> users) {
      final FormState formState = baseAuth.key.currentState;

      baseAuth.errorMessages = [''];
      if(!formState.validate()) {
        logger.w('Register: User is invalid (incorrect data entered)');
        baseAuth.errorMessages.add('Please enter correct data');
        return false;
      }
      if(usernameExists(baseAuth.user.username, users)) {
        logger.w('Register: User is invalid (username already exists)');
        baseAuth.errorMessages.add('Username exists');
        return false;
      }
      if(baseAuth.password != baseAuth.confirmPassword) {
        logger.w('Register: User is invalid (passwords do not match)');
        baseAuth.errorMessages.add('Passwords do not match');
        return false;
      }

      logger.i('Register: User is valid');
      return true;
    };

    registerUser = (BaseAuth baseAuth,
        ImageService imageService, List<User> users) async {
      final User registeredUser = baseAuth.user;

      if(formIsValid(baseAuth, users)) {
        final FormState formState = baseAuth.key.currentState;
        formState.save();

        switchPage(isLoading: true);

        // TODO: narrow these final settings of values down in function
        if(registeredUser.isTeacher) registeredUser.GPA = null;

        if(imageService != null && imageService.profileImage != null) {
          logger.i('Register: Attempting to upload authUser image to Firebase storage');
          registeredUser.photoURL = await imageService.uploadImage();
        }

        User user = await baseAuth.authInstance.registerUserByEmailAndPassword(registeredUser, baseAuth.password);

        if(user == null) {
          logger.w('Register: User hasn\'t been registered (failed)');
          return null;
        }

        return user;
      } else {
        switchPage();
      }
      return null;
    };
  }

  RegisterForm.externalSignIn({
    @required this.switchPage,
    this.animationController,
    @required this.callback}) :
  assert(switchPage != null) {
    isExternalAuth = true;

    formIsValid = (BaseAuth baseAuth, List<User> users) {
      final FormState formState = baseAuth.key.currentState;

      baseAuth.errorMessages = [''];
      if(!formState.validate()) {
        logger.w('Register: User is invalid (incorrect data entered)');
        baseAuth.errorMessages.add('Please enter correct data');
        return false;
      }
      if(usernameExists(baseAuth.user.username, users)) {
        logger.w('Register: User is invalid (username already exists)');
        baseAuth.errorMessages.add('Username exists!');
        return false;
      }

      logger.i('Register: User is valid');
      return true;
    };

    registerUser = (BaseAuth baseAuth,
        ImageService imageService, List<User> users) async {
      final User registeredUser = baseAuth.user;

      if(formIsValid(baseAuth, users)) {
        final FormState formState = baseAuth.key.currentState;
        formState.save();

        switchPage(isLoading: true);

        // TODO: narrow these final settings of values down in function
        if(registeredUser.isTeacher) registeredUser.GPA = null;

        // user already auth'd here because external so we can upload the image
        if(baseAuth.user.photoURL == null || (imageService != null && imageService.profileImage != null)) {
          registeredUser.photoURL = await imageService.uploadImage();
        } // TODO: Potential bug here if user continues with default image?

        await Database(uid: registeredUser.uid).updateUserData(registeredUser); // update external auth user DB
        callback();

        return registeredUser;
      } else {
        switchPage();
      }
      return null;
    };
  }

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {

  @override
  Widget build(BuildContext context) {

    final users = Provider.of<List<User>>(context) ?? [];
    final tags = Provider.of<List<Tag>>(context) ?? [];
    final baseAuth = Provider.of<BaseAuth>(context);
    final imageService = Provider.of<ImageService>(context);

    final baseAuthInputFields = Column(
      children: <Widget>[
        EmailInputField(
          key: Key(Keys.registerEmailInputField),
          onChanged: (value) => setState(() {baseAuth.user.email = value;}),
        ),
        SizedBox(height: 15.0),
        PasswordInputField(
          key: Key(Keys.registerPasswordInputField),
          onChanged: (value) => setState(() {baseAuth.password = value;}),
          hintText: 'Enter a password',
        ),
        SizedBox(height: 15.0),
        ConfirmPasswordInputField(
          key: Key(Keys.registerConfirmPasswordInputField),
          onChanged: (value) => setState(() {baseAuth.confirmPassword = value;}),
        ),
      ],
    );

    return ListView(
      key: Key(Keys.registerListView),
      children: <Widget>[
        Container( // Container grants access to basic layout principles and properties
          color: greyColor,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Form(
              key: baseAuth.key, // set the form's key to the key defined above (keeps track of the state of the form)
              child: Column( // Column orders widgets in a Column and its children property takes a list of Widgets
                children: <Widget>[
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        MultiProvider(
                          providers: [
                            Provider<ImageService>.value(
                              value: imageService,
                            ),
                            Provider<User>.value(
                              value: imageService.profileImage == null ?
                                baseAuth.user : null,
                            ),
                          ],
                          child: AvatarWrapper(),
                        ),
                        Column(
                          children: baseAuth.errorMessages?.map((message) => Text(
                            "$message",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20.0,
                            ),
                          ))?.toList() ?? [],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.0),
                  UsernameInputField(
                    key: Key(Keys.registerUsernameInputField),
                    onChanged: (value) => setState(() {baseAuth.user.username = value;}),
                  ),
                  SizedBox(height: 15.0),
                  widget.isExternalAuth ? SizedBox() :
                    baseAuthInputFields,
                  SizedBox(height: 15.0),
                  baseAuth.user.isTeacher ? SizedBox() : GPAInputField(
                    key: Key(Keys.registerGPAInputField),
                    onChanged: (value) => setState(() => baseAuth.user.GPA = double.tryParse(value)),
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Are you a teacher?',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          fontSize: 10.0,
                        )
                      ),
                      Switch(
                        key: Key(Keys.isTeacherSwitch),
                        value: baseAuth.user.isTeacher, // has the current user selected the isTeacher property
                        onChanged: (value) => setState(() {baseAuth.user.isTeacher = value;}),
                            // Rerun the build method in order for the switch to actually change
                        activeColor: Colors.orange,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  InputButton(
                    key: Key(Keys.chooseTagsButton),
                    minWidth: 250.0,
                    height: 60.0,
                    text: 'Choose tags',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MultiProvider(
                            providers: [
                              Provider<List<Tag>>.value(value: tags),
                              Provider<BaseAuth>.value(value: baseAuth),
                            ],
                            child: Align(
                              alignment: Alignment.center,
                              child: TagSelection(),
                            ),
                          )
                        )
                      );
                    },
                  ),
                  Divider(height: 30.0, thickness: 5.0, color: darkGreyColor),
                  InputButton(
                    key: Key(Keys.registerButton),
                    minWidth: 250.0,
                    height: 60.0,
                    color: Colors.deepOrange[500],
                    text: widget.isExternalAuth ? 'Finish Account' : 'Create account',
                    onPressed: () async {
                      var result = await widget.registerUser(baseAuth, imageService, users);
                      if(result == null && !widget.isExternalAuth) {
                        // TODO: Reimplement setState(() => {}); threw exception beforehand
                        setState(() =>
                            baseAuth.clearAndAddError('Your e-mail may already be in use or your passwords may not match!')
                        );
                      }
                    },
                  ),
                  SizedBox(height: 20.0),
                  widget.isExternalAuth ? InputButton(
                    key: Key(Keys.externBackButton),
                    minWidth: 300.0,
                    height: 60.0,
                    text: 'Back',
                    onPressed: () {
                      baseAuth.authInstance.deleteCurrentFirebaseUser();
                      widget.switchPage();
                    },
                  ) : SizedBox(),
                ],
              ),
            ),
          ),
        )
      ]
    );
  }
}
