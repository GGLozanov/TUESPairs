import 'package:flutter/material.dart';
import 'package:tues_pairs/services/image.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:tues_pairs/shared/constants.dart';

class Avatar extends StatefulWidget {

  final ImageService imageService;
  NetworkImage userImage;

  Avatar({this.imageService, this.userImage});

  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {

  void setImage(File image) {
    logger.i('Avatar: User image set => Rerendering Avatar wtih chosen profile image');
    setState(() {
      widget.imageService.profileImage = image;
      widget.userImage = null;
    });
  }

  Future setPictureFromGallery() async {
    try {
      logger.i('Avatar: User image selection chosen from gallery. Awaiting user image selection.');
      var image = await widget.imageService.getImageByGallery();
      logger.i('Avatar: User image chosen from gallery w/ path "' + image.path + '"');
      setImage(image);
    } catch(e) {
      logger.e('Avatar: ' + e.toString());
    }
  }

  Future setPictureFromCamera() async {
    logger.i('Avatar: User image selection chosen from camera. Awaiting user image selection.');
    var image = await widget.imageService.getImageByCamera();
    logger.i('Avatar: User image chosen from camera w/ path "' + image.path + '"');
    setImage(image);
  }

  Widget displayImage(){
    if (widget.userImage == null) {
      logger.i('Avatar: No user image detected => Rendering default Avatar');
      if (widget.imageService.profileImage == null) {
        logger.i('Avatar: No profile image selected => Rendering empty Avatar');
        return Icon(
          Icons.person,
          size: 100.0,
          color: Colors.orange,
        );
      }
      logger.i('Avatar: Profile image detected => Rendering Avatar with chosen image');
      return Image.file(
        widget.imageService.profileImage,
        fit: BoxFit.fill,
      );
    }
    logger.i('Avatar: User image detected => Rendering Avatar with user image');
    return Image(
      image: widget.userImage,
      fit: BoxFit.fill,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
          CircleAvatar(
            radius: 65.0,
            backgroundColor: Color.fromRGBO(33, 36, 44, 1),
            child: ClipOval(
              child: SizedBox(
                width: 180.0,
                height: 180.0,
                child: displayImage(),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: IconButton(
                  icon: Icon(
                    Icons.camera_alt,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    setPictureFromCamera();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: IconButton(
                  icon: Icon(
                    Icons.folder,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    setPictureFromGallery();
                  },
                ),
              ),
            ]
          )
        ],
      );
    }
}
