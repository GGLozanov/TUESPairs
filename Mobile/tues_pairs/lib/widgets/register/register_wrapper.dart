import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/screens/authlistener.dart';
import 'package:tues_pairs/screens/register/register.dart';
import 'package:tues_pairs/services/image.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/templates/baseauth.dart';
import 'package:tues_pairs/widgets/register/register_form.dart';
import 'package:tues_pairs/widgets/tag_display/tag_selection.dart';

class RegisterWrapper extends StatefulWidget {

  bool isExternalRegister = false;

  final BaseAuth baseAuth;
  final ImageService imageService;
  Function callback;

  RegisterWrapper({
    @required this.baseAuth,
    @required this.imageService
  }) :
    assert(baseAuth != null),
    assert(imageService != null);

  RegisterWrapper.external({
    @required this.baseAuth,
    @required this.imageService,
    @required this.callback
  }) :
    assert(baseAuth != null),
    assert(imageService != null) {
      isExternalRegister = true;
  }

  @override
  _RegisterWrapperState createState() => _RegisterWrapperState();
}

class _RegisterWrapperState extends State<RegisterWrapper> with SingleTickerProviderStateMixin, WidgetsBindingObserver {

  void switchPage({bool isLoading = false}) {
    // replace current stack widget with reverse stack widget
    // with animation
    setState(() { if(isLoading) widget.baseAuth.toggleLoading(); });
  }

  @override
  void dispose() {
    StackPageHandler.registerController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    StackPageHandler.registerController = new AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    StackPageHandler.registerController.forward();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // executes whenever the app has been detached (put in the background), destroyed, resumed, etc.
    // in this specific instance, whenever it is detached (Android term) and inactive (iOS term)
    if((state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) &&
          widget.isExternalRegister) {
      Navigator.pop(context); // remove the page from the widget tree and rebuild without it upon entering
      // avoids setState() exception during build() call for AuthListener
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<BaseAuth>.value(value: widget.baseAuth),
        Provider<ImageService>.value(value: widget.imageService),
      ],
      child: IndexedStack(
        index: StackPageHandler.currentPage,
        children: [
          Align(
            alignment: Alignment.center,
            child: TagSelection(switchPage: switchPage, animationController: StackPageHandler.registerController,),
          ),
          Align(
            alignment: Alignment.center,
            child: widget.isExternalRegister ?
            RegisterForm.externalSignIn(switchPage: switchPage, animationController: StackPageHandler.registerController, callback: widget.callback,) :
              RegisterForm(switchPage: switchPage, animationController: StackPageHandler.registerController,),
          ),
        ],
      ),
    );
  }
}
