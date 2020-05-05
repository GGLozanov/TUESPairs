import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tues_pairs/modules/tag.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/services/image.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'package:tues_pairs/templates/baseauth.dart';
import 'package:tues_pairs/widgets/register/register_wrapper.dart';

class ExternRegister extends StatelessWidget {

  List<User> users;
  List<Tag> tags;
  BaseAuth baseAuth;
  Function callback; // callback passed down all the way to register_form that calls AuthListener rerender

  ExternRegister({this.users, this.tags, this.baseAuth, this.callback});

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Scaffold grants the material design palette and general layout of the app (properties like appBar)
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
        ),
        body: MultiProvider(
          providers: [
            Provider<List<User>>.value(
              value: users,
            ),
            Provider<List<Tag>>.value(
              value: tags,
            )
          ],
          child: RegisterWrapper.external(baseAuth: baseAuth, imageService: new ImageService(), callback: callback),
        )
    );
  }
}