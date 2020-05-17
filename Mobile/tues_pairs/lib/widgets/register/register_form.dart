import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/modules/tag.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/services/database.dart';
import 'package:tues_pairs/services/image.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/shared/keys.dart';
import 'package:tues_pairs/templates/baseauth.dart';
import 'package:tues_pairs/templates/step_info.dart';
import 'package:tues_pairs/widgets/avatar/avatar_wrapper.dart';
import 'package:tues_pairs/widgets/form/GPA_input_field.dart';
import 'package:tues_pairs/widgets/form/input_button.dart';
import 'package:tues_pairs/widgets/form/input_field.dart';
import 'package:tues_pairs/widgets/form/username_input_field.dart';
import 'package:tues_pairs/widgets/form/email_input_field.dart';
import 'package:tues_pairs/widgets/form/password_input_field.dart';
import 'package:tues_pairs/widgets/form/confim_password_input_field.dart';
import 'package:tues_pairs/widgets/general/baseauth_error_display.dart';
import 'package:tues_pairs/widgets/general/button_pair.dart';
import 'package:tues_pairs/widgets/general/stepper_button.dart';
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

      formStates.removeWhere((state) => state == null); // remove null states (like GPA if deselected)

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

      stepperKeys.removeWhere((key) => key == null); // remove null keys (for fields that are not forms)

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
          switchPage();
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

      formStates.removeWhere((state) => state == null); // remove null states (like GPA if deselected)

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

      stepperKeys.removeWhere((key) => key == null); // remove null keys (for fields that are not forms)

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

  List<StepInfo> _stepInfos; // idx to map with String keys and dynamic values (GlobakLeys, names, etc. associated)

  Step _stepFromWidget(
      Widget content,
      int stepIdx,
      bool innerCondition,
      {bool isActive = true}
  ) {
    assert(content != null);
    assert(stepIdx != null);
    assert(innerCondition != null);

    return Step(
      title: Text(
        _stepInfos[stepIdx].name,
        style: TextStyle(
          fontFamily: 'Nilam',
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
      ),
      content: content,
      isActive: isActive,
      state: currentStep == stepIdx // changes the state depending
        ? StepState.editing // on the stepidx, which affects the icon shown
      : innerCondition ? // if the form has been filled, we show the 'complete' state
        StepState.complete : StepState.indexed
    );
  }

  List<Step> _getSteps(List<Widget> fields) {
    final steps = fields.map((widget) {
      final stepIdx = fields.indexOf(widget);

      if(widget is InputField) { // decide which conversion func to call
        // retrieve whether the form is currently filled (should not save currentState)
        return _stepFromWidget(
          Form(
            key: _stepInfos[stepIdx].formKey,
            child: widget
          ), // content
          stepIdx, // step index
          _stepInfos[stepIdx].isFormValid(shouldSave: false), // inner condition for state (edit, indexed, complete)
          isActive: currentStep >= stepIdx // isActive (highlighted w/ blue)
        );
      }
      if(widget is Row) {
        // if it's not an input field, it's a row with switch
        return _stepFromWidget(
          widget,
          stepIdx,
          currentStep > stepIdx,
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
    _stepInfos = widget.isExternalAuth ? // TODO: Optimise this to be better and for future fields
      [
        new StepInfo(
          stepIdx: 0,
          name: 'Are you a teacher?',
          formKey: null
        ),
        new StepInfo(
          stepIdx: 1,
          name: 'Username',
          formKey: GlobalKey<FormState>(debugLabel: 'Username')
        ),
        new StepInfo(
          stepIdx: 2,
          name: 'GPA',
          formKey: GlobalKey<FormState>(debugLabel: 'GPA')
        ),
      ]
    : [
      new StepInfo(
        stepIdx: 0,
        name: 'Are you a teacher?',
        formKey: null
      ),
      new StepInfo(
        stepIdx: 1,
        name: 'E-mail',
        formKey: GlobalKey<FormState>(debugLabel: 'E-mail'),
      ),
      new StepInfo(
        stepIdx: 2,
        name: 'Password',
        formKey: GlobalKey<FormState>(debugLabel: 'Password'),
      ),
      new StepInfo(
        stepIdx: 3,
        name: 'Confirm Password',
        formKey: GlobalKey<FormState>(debugLabel: 'Confirm Password'),
      ),
      new StepInfo(
        stepIdx: 4,
        name: 'Username',
        formKey: GlobalKey<FormState>(debugLabel: 'Username'),
      ),
      new StepInfo(
        stepIdx: 5,
        name: 'GPA',
        formKey: GlobalKey<FormState>(debugLabel: 'GPA'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {

    final users = Provider.of<List<User>>(context) ?? [];
    final tags = Provider.of<List<Tag>>(context) ?? [];
    final baseAuth = Provider.of<BaseAuth>(context);
    final imageService = Provider.of<ImageService>(context);

    final screenSize = MediaQuery.of(context).size;
    final btnHeight = screenSize.height / (widgetReasonableHeightMargin - 1.25);
    final btnWidth = screenSize.width / (widgetReasonableWidthMargin - 1.25);

    final _isTeacherField = <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
          'Tap the switch if you are',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            fontSize: 15.0,
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
    ];

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
        sourcePassword: baseAuth.password,
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
      _isTeacherField,
      _baseAuthInputFields,
      _infoInputFields,
    ];

    final _externFields = <List<Widget>>[
      _isTeacherField,
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
                BaseAuthErrorDisplay(baseAuth: baseAuth,),
                Theme(
                  data: ThemeData(
                    primaryColor: Colors.orangeAccent,
                  ),
                  child: Stepper(
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
                      bool isCurrentFormValid =
                          _stepInfos[currentStep]
                          .isFormValid();
                      setState(() {
                      if(isCurrentFormValid &&
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
                          SizedBox(height: 80.0),
                          StepperButton(
                            screenSize: screenSize,
                            key: Key(Keys.registerStepNextButton),
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
                          SizedBox(width: 15.0),
                          StepperButton(
                            screenSize: screenSize,
                            key: Key(Keys.registerStepBackButton),
                            child: Text(
                              'Back',
                              style: TextStyle(
                                fontFamily: 'Nilam',
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            onPressed: onStepCancel,
                          ),
                        ]
                      );
                    },
                  ),
                ), 
                SizedBox(height: 10.0),
                ButtonPair(
                  leftBtnKey: Key(Keys.chooseTagsButton),
                  rightBtnKey: Key(Keys.registerButton),
                  btnsHeight: btnHeight,
                  btnsWidth: btnWidth,
                  leftBtnText: 'Choose Tags',
                  rightBtnText: widget.isExternalAuth ? 'Finish Account' : 'Create account',
                  onLeftPressed: () {
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
                  onRightPressed: () async {
                    var result = await widget.registerUser(
                        baseAuth,
                        imageService,
                        users,
                        _stepInfos.map((stepInfo) => stepInfo.formKey).toList() // map to keys and get all them as a list
                    );

                    if(result == null && !widget.isExternalAuth) {
                      // TODO: Reimplement setState(() => {}); threw exception beforehand -> done
                      setState(() =>
                          baseAuth.errorMessages.add(
                              'An error has occurred! Please try again!'
                          )
                      );
                    }
                  },
                  rightBtnColor: Colors.deepOrange[500],
                ),
                SizedBox(height: 30.0),
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
