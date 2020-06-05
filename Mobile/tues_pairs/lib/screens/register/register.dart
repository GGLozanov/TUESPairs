import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/modules/tag.dart';
import 'package:tues_pairs/screens/loading/loading.dart';
import 'package:tues_pairs/shared/keys.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/templates/baseauth.dart';
import 'package:tues_pairs/services/image.dart';
import 'package:tues_pairs/widgets/register/register_form.dart';
import 'package:tues_pairs/widgets/register/register_wrapper.dart';
import 'package:tues_pairs/widgets/tag_display/tag_selection.dart';

import '../../locale/app_localization.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView}); // create a constructor which inits this property toggleView

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final BaseAuth baseAuth = new BaseAuth();
  final ImageService imageService = new ImageService();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizator = AppLocalizations.of(context);

    return baseAuth.isLoading ? Loading() : Scaffold( // Scaffold grants the material design palette and general layout of the app (properties like appBar)
      key: Key(Keys.registerScaffold),
      backgroundColor: greyColor,
      appBar: buildAppBar(
        pageTitle: localizator.translate('register'),
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
              localizator.translate('login'),
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

      body: RegisterWrapper(
        baseAuth: baseAuth,
        imageService: imageService,
      ),
    );
  }
}
