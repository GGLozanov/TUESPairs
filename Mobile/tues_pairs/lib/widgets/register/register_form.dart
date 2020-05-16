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
import 'package:tues_pairs/widgets/form/input_field.dart';
import 'package:tues_pairs/widgets/form/username_input_field.dart';
import 'package:tues_pairs/widgets/form/email_input_field.dart';
import 'package:tues_pairs/widgets/form/password_input_field.dart';
import 'package:tues_pairs/widgets/form/confim_password_input_field.dart';
import 'package:tues_pairs/widgets/tag_display/tag_selection.dart';

class RegisterForm extends StatefulWidget {

  static bool hasUserEnteredTags = false;

  final Function switchPage;
  Function callback;

  bool isExternalAuth = false;

  Function formIsValid;
  Function registerUser;

  RegisterForm({
    @required this.switchPage,
  }) : assert(switchPage != null) {

    formIsValid = (BaseAuth baseAuth,
        List<User> users, List<FormState> formStates) {

      formStates.removeWhere((state) => null); // remove null states (like GPA if deselected)

      baseAuth.errorMessages = [''];
      if(formStates.firstWhere(
          (state) => !state.validate(), // if no element is found to satisfy this condition, the form is valid
          orElse: () => null) != null) {
        logger.w('Register: User is invalid (stepper forms are invalid)');
        baseAuth.errorMessages.add('Invalid info in forms!');
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
        ImageService imageService, List<User> users,
        List<GlobalKey<FormState>> stepperKeys) async {
      final User registeredUser = baseAuth.user;

      if(formIsValid(baseAuth, users, stepperKeys
          .map((key) => key.currentState)
          .toList())) {

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
    @required this.callback}) :
  assert(switchPage != null) {
    isExternalAuth = true;

    formIsValid = (BaseAuth baseAuth,
        List<User> users, List<FormState> formStates) {

      formStates.removeWhere((state) => null); // remove null states (like GPA if deselected)

      baseAuth.errorMessages = [''];
      if(formStates.firstWhere(
              (state) => !state.validate(), // if no element is found to satisfy this condition, the form is valid
          orElse: () => null) != null) {
        logger.w('Register: User is invalid (stepper forms are invalid)');
        baseAuth.errorMessages.add('Invalid info in forms!');
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
        ImageService imageService, List<User> users,
        List<GlobalKey<FormState>> stepperKeys) async {
      final User registeredUser = baseAuth.user;

      if(formIsValid(baseAuth, users, stepperKeys
          .map((key) => key.currentState)
          .toList())) {

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

  int currentStep = 0;

  Map<int, String> _stepNames;

  List<GlobalKey<FormState>> _formStateKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ]; // TODO: Change when adding project idea fields
  // globalkeys used to validate each stepper form

  StepState _stateConditionTemplate(
    int stepIdx,
    {@required innerCondition}) {
    assert(innerCondition != null);

    return currentStep == stepIdx // changes the state depending
        ? StepState.editing // on the stepidx, which affects the icon shown
        : innerCondition ? // if the form has been filled, we show the 'complete' state
    StepState.complete : StepState.indexed;
  }

  Step _stepFromWidget(
      Widget content,
      int stepIdx,
      StepState state,
      {bool isActive = true}
  ) {
    return Step(
      title: Text(
        _stepNames[stepIdx],
        style: TextStyle(
          fontFamily: 'Nilam',
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
      ),
      content: content,
      isActive: isActive,
      state: state
    );
  }

  List<Step> _getSteps(List<Widget> fields) {
    final steps = fields.map((widget) {
      final stepIdx = fields.indexOf(widget);

      if(widget is InputField) { // decide which conversion func to call
        bool isCurrentStepValid = _formStateKeys[stepIdx] // retrieve whether the form is currently filled
            ?.currentState?.validate();

        if(isCurrentStepValid == null) { // check for null and revert to not filled
          isCurrentStepValid = false; // which means showing the index of the step (since the form is empty)
        }

        return _stepFromWidget(
          Form(
            key: _formStateKeys[stepIdx],
            child: widget
          ),
          stepIdx,
          _stateConditionTemplate(
            stepIdx,
            innerCondition: isCurrentStepValid
          ),
          isActive: currentStep >= stepIdx
        );
      } else if(widget is Checkbox) { // TODO: Implement in Stepper
        return _stepFromWidget(
          widget,
          stepIdx,
          _stateConditionTemplate(
            stepIdx,
            innerCondition: currentStep > stepIdx
          ),
          isActive: currentStep >= stepIdx
        );
      } else if(widget is InputButton) { // TODO: Implement in Stepper
        print('');
        return _stepFromWidget(
          widget,
          stepIdx,
          _stateConditionTemplate(
            stepIdx,
            innerCondition: RegisterForm.hasUserEnteredTags,
          ),
          isActive: currentStep >= stepIdx
        );
      }
      return null;
    }).toList(); // Convert each widget to a step
    steps.removeWhere((step) => step == null); // removes GPA input field (sizedbox widgets)
    return steps;
  }


  @override
  void initState() {
    super.initState();
    _stepNames = widget.isExternalAuth ? // TODO: Optimise this to be better and for future fields
      {
        0 : 'Username',
        1 : 'GPA'
      }
    : {
      0 : 'E-mail', // first -> name of step
      1 : 'Password',
      2 : 'Confirm Password', // TODO: Implement Tag selection and isTeacher in Stepper
      3 : 'Username',
      4 : 'GPA',
    };
  }

  @override
  Widget build(BuildContext context) {

    final users = Provider.of<List<User>>(context) ?? [];
    final tags = Provider.of<List<Tag>>(context) ?? [];
    final baseAuth = Provider.of<BaseAuth>(context);
    final imageService = Provider.of<ImageService>(context);

    final screenSize = MediaQuery.of(context).size;

    final _baseAuthInputFields = <Widget>[
      EmailInputField(
        key: Key(Keys.registerEmailInputField),
        onChanged: (value) => setState(() {baseAuth.user.email = value;}),
      ),
      PasswordInputField(
        key: Key(Keys.registerPasswordInputField),
        onChanged: (value) => setState(() {baseAuth.password = value;}),
        hintText: 'Enter a password',
      ),
      ConfirmPasswordInputField(
        key: Key(Keys.registerConfirmPasswordInputField),
        onChanged: (value) => setState(() {baseAuth.confirmPassword = value;}),
      ),
    ];

    final _infoInputFields = <Widget>[
      UsernameInputField(
        key: Key(Keys.registerUsernameInputField),
        onChanged: (value) => setState(() {baseAuth.user.username = value;}),
      ),
      baseAuth.user.isTeacher ? SizedBox() : GPAInputField(
        key: Key(Keys.registerGPAInputField),
        onChanged: (value) => setState(() => baseAuth.user.GPA = double.tryParse(value)),
      ),
    ];

    final _defaultFields = <List<Widget>>[
      _baseAuthInputFields,
      _infoInputFields,
    ];

    final _externFields = <List<Widget>>[
      _infoInputFields
    ];

    final _steps = widget.isExternalAuth ?
      _getSteps(_externFields.expand((widget) => widget).toList()) :
        _getSteps(_defaultFields.expand((widget) => widget).toList());

    if(currentStep >= _steps.length) {
      currentStep = _steps.length - 1;
    }

    return ListView(
      key: Key(Keys.registerListView),
      children: <Widget>[
        Container( // Container grants access to basic layout principles and properties
          color: greyColor,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Column( // Column orders widgets in a Column and its children property takes a list of Widgets
              children: <Widget>[
                Center(
                  child: MultiProvider(
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
                ),
                Column(
                  children: baseAuth.errorMessages?.map((message) => Text(
                    "$message",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ))?.toList() ?? [],
                ),
                SizedBox(height: 15.0),
                Stepper(
                  // create a new stepper with a unique key each time the stepper length changes
                  key: Key(Keys.registerStepper + _steps.length.toString()),
                  physics: ClampingScrollPhysics(),
                  steps: _steps,
                  currentStep: currentStep,
                  onStepTapped: (stepIdx) {
                    setState(() {
                      currentStep = stepIdx;
                    });
                  },
                  onStepContinue: () {
                    final currentFormState =
                        _formStateKeys[currentStep]
                        .currentState;
                    currentFormState.save();
                    setState(() {
                    if(currentFormState.validate() &&
                          currentStep < _steps.length - 1) {
                      currentStep++;
                      } else currentStep = 0;
                    });
                  },
                  onStepCancel: () {
                    setState(() {
                      currentStep = currentStep > 0 ?
                          currentStep - 1 : 0;
                    });
                  },
                  controlsBuilder: (context, {onStepContinue, onStepCancel}) {
                    final bool isFinalStep = currentStep == _steps.length - 1;

                    return Row(
                      children: <Widget>[
                        SizedBox(height: 100.0),
                        ButtonTheme( // TODO: Maybe extract in widget
                          height: screenSize.height / (widgetReasonableHeightMargin + 1),
                          minWidth: screenSize.width / widgetReasonableWidthMargin,
                          child: FlatButton(
                            key: Key(Keys.registerStepNextButton),
                            color: darkGreyColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(23.0),
                            ),
                            child: Text(
                              isFinalStep ? 'Go to Email' : 'Continue',
                              style: TextStyle(
                                fontFamily: 'Nilam',
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            onPressed: onStepContinue,
                          ),
                        ),
                        SizedBox(width: 15.0),
                        ButtonTheme(
                          height: screenSize.height / (widgetReasonableHeightMargin + 1),
                          minWidth: screenSize.width / widgetReasonableWidthMargin,
                          child: FlatButton(
                            key: Key(Keys.registerStepBackButton),
                            color: darkGreyColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(23.0),
                            ),
                            child: Text(
                              'Back',
                              style: TextStyle(
                                fontFamily: 'Nilam',
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            onPressed: onStepCancel
                          ),
                        ),
                      ],
                    );
                  },
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
                        fontSize: 18.0,
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
                SizedBox(height: 30.0),
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
                    var result = await widget.registerUser(baseAuth, imageService, users, _formStateKeys);
                    if(result == null && !widget.isExternalAuth) {
                      // TODO: Reimplement setState(() => {}); threw exception beforehand -> done
                      setState(() =>
                          baseAuth.errorMessages.add(
                              'An error has occurred! Please try again!'
                          )
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
                  onPressed: () async {
                    try {
                      await baseAuth.authInstance.deleteCurrentFirebaseUser();
                    } catch(e) {
                      logger.e('RegisterForm: Back ' + e.toString());
                      setState(() =>
                          baseAuth.clearAndAddError('Could not go back to login. Your auth token may have expired. Please exit and try again.')
                      );
                      return;
                    }
                  },
                ) : SizedBox(),
              ],
            ),
          ),
        )
      ]
    );
  }
}
