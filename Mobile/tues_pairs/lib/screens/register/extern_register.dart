import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/modules/tag.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/services/image.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/templates/baseauth.dart';
import 'package:tues_pairs/widgets/register/register_wrapper.dart';

import '../../locale/app_localization.dart';

class ExternRegister extends StatefulWidget {
  BaseAuth baseAuth;
  Function callback; // callback passed down all the way to register_form that calls AuthListener rerender

  ExternRegister({
    this.baseAuth,
    this.callback
  });

  bool isInvalid() {
    return baseAuth == null;
  }

  @override
  _ExternRegisterState createState() => _ExternRegisterState();
}

class _ExternRegisterState extends State<ExternRegister> {

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizator = AppLocalizations.of(context);

    return Scaffold( // Scaffold grants the material design palette and general layout of the app (properties like appBar)
      backgroundColor: greyColor,
      appBar: buildAppBar(
        pageTitle: localizator.translate('register')
      ),
      body: RegisterWrapper.external(baseAuth: widget.baseAuth, imageService: new ImageService(), callback: widget.callback),
    );
  }
}
