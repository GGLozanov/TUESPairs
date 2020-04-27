import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

class _RegisterWrapperState extends State<RegisterWrapper> with SingleTickerProviderStateMixin {

  void switchPage({bool isLoading = false}) {
    // replace current stack widget with reverse stack widget
    // with animation
    setState(() { if(isLoading) widget.baseAuth.toggleLoading(); });
  }

  @override
  void dispose() {
    StackPageHandler.controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    StackPageHandler.controller = new AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    StackPageHandler.controller.forward();
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
            child: TagSelection(switchPage: switchPage, animationController: StackPageHandler.controller,),
          ),
          Align(
            alignment: Alignment.center,
            child: widget.isExternalRegister ?
            RegisterForm.externalSignIn(switchPage: switchPage, animationController: StackPageHandler.controller, callback: widget.callback,) :
              RegisterForm(switchPage: switchPage, animationController: StackPageHandler.controller,),
          ),
        ],
      ),
    );
  }
}
