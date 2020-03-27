import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:tues_pairs/services/image.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:tues_pairs/widgets/avatar/avatar.dart';
import 'package:tues_pairs/widgets/general/error.dart';

class AvatarWrapper extends StatefulWidget {

  @override
  _AvatarWrapperState createState() => _AvatarWrapperState();
}

class _AvatarWrapperState extends State<AvatarWrapper> {

  NetworkImage userImage;

  @override
  Widget build(BuildContext context) {
    final imageService = Provider.of<ImageService>(context) ?? null;
    final currentUser = Provider.of<User>(context) ?? null;

    if(currentUser == null || currentUser.photoURL == null) { // if no currentUser is detected, go with just the layout
      return Avatar(imageService: imageService, userImage: null);
    }

    userImage = imageService.getImageByURL(currentUser.photoURL);
    return userImage != null ? Avatar(imageService: imageService, userImage: userImage) : Error();

  }
}

