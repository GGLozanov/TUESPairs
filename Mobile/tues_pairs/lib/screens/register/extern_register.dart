import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/modules/tag.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/services/image.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/templates/baseauth.dart';
import 'package:tues_pairs/widgets/register/register_wrapper.dart';

class ExternRegister extends StatelessWidget {
  BaseAuth baseAuth;
  Function callback; // callback passed down all the way to register_form that calls AuthListener rerender

  bool isInvalid() {
    return baseAuth == null;
  }

  ExternRegister({this.baseAuth, this.callback});

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Scaffold grants the material design palette and general layout of the app (properties like appBar)
      backgroundColor: greyColor,
      appBar: buildAppBar(
        pageTitle: 'Register'
      ),
      body: RegisterWrapper.external(baseAuth: baseAuth, imageService: new ImageService(), callback: callback),
    );
  }
}
