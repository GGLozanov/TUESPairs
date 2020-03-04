import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:tues_pairs/services/image.dart';
import 'package:tues_pairs/modules/user.dart';

class Avatar extends StatefulWidget {
  ImageService imageService;

  Avatar({this.imageService});

  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {

  NetworkImage userImage;

  // TODO: Create separate value for storing picture File instead of accessing widget without the IDE crying

  Future<File> setProfileImageByGallery() async {
    var profilePicture = await widget.imageService.getImageByGallery();

    setState(() => widget.imageService.profilePicture = profilePicture);
  }

  Future<File> setProfileImageByCamera() async {
    var profilePicture = await widget.imageService.getImageByCamera();

    setState(() => widget.imageService.profilePicture = profilePicture);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<User>(context) ?? null;

    return FutureBuilder(
      future: widget.imageService.getImageByURL(currentUser.photoURL).then((value) {
        userImage = value;
      }),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          return Row(
            children: <Widget>[
              SizedBox(height: 15.0),
              CircleAvatar(
                backgroundColor: Colors.deepOrangeAccent,
                radius: 60.0,
                child: ClipOval( // widget clips anything inside to be an oval shape
                    child: SizedBox(
                      width: 180.0,
                      height: 180.0,
                      child: userImage == null ? widget.imageService.profilePicture == null ? Image.network(
                            'https://cdn0.iconfinder.com/data/icons/line-action-bar/48/camera-512.png',
                            // placeholder image
                            fit: BoxFit.fill,
                          ) : Image.file(
                            widget.imageService.profilePicture,
                            fit: BoxFit.fill,
                          ) : Image(
                            image: userImage,
                            fit: BoxFit.fill,
                          ),
                    ),
                ),
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () {
                          setProfileImageByGallery();
                        }
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: IconButton(
                        icon: Icon(Icons.camera),
                        onPressed: () {
                          setProfileImageByCamera();
                        }
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          return Container(); // TODO: shapshot.hasError
        }
      }
    );
  }
}

