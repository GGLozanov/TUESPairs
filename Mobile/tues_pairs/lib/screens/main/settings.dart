import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/services/image.dart';
import 'package:tues_pairs/templates/baseauth.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:tues_pairs/services/database.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:tues_pairs/widgets/avatar_widgets/avatar_wrapper.dart';
import 'package:tues_pairs/widgets/form_widgets/GPA_input_field.dart';
import 'package:tues_pairs/widgets/form_widgets/email_input_field.dart';
import 'package:tues_pairs/widgets/form_widgets/input_form_settings.dart';
import 'package:tues_pairs/widgets/form_widgets/username_input_field.dart';
import 'package:tues_pairs/widgets/form_widgets/password_input_field.dart';
import 'package:tues_pairs/widgets/form_widgets/confim_password_input_field.dart';
import 'package:tues_pairs/widgets/form_widgets/input_button.dart';

class Settings extends StatefulWidget {

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {
    return Provider<ImageService>.value(
      value: new ImageService(),
      child: Container(
        color: Color.fromRGBO(59, 64, 78, 1),
        child: Column(
          children: <Widget>[
            SizedBox(height: 15.0),
            InputFormSettings(),
            SizedBox(height: 15.0),
            Center(
              child: Text(
                'Warning: Modifications on account only take change after hitting the Submit button!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
