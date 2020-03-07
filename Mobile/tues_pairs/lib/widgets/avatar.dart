import 'package:flutter/material.dart';
import 'package:tues_pairs/services/image.dart';
import 'dart:io';
import 'package:path/path.dart';

class Avatar extends StatefulWidget {

  final ImageService imageService;
  NetworkImage userImage;

  Avatar({this.imageService, this.userImage});

  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {

  void setImage(File image) {
    setState(() {
      widget.imageService.profilePicture = image;
      widget.userImage = null;
    });
  }


  Future setPictureFromGallery() async {
    
    try{
      var image = await widget.imageService.getImageByGallery();
      setImage(image);
    }catch(e){
      print(e.toString());
    }

  }


  Future setPictureFromCamera() async {
    var image = await widget.imageService.getImageByCamera();

    setImage(image);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
          CircleAvatar(
            radius: 65.0,
            backgroundColor: Color.fromRGBO(33, 36, 44, 1),
            child: ClipOval(
              child: SizedBox(
                width: 180.0,
                height: 180.0,
                child: widget.userImage == null ? widget.imageService.profilePicture == null ? Icon(
                  Icons.person,
                  size: 100.0,
                  color: Colors.orange,
                ) : Image.file(
                  widget.imageService.profilePicture,
                  fit: BoxFit.fill,
                ) : Image(
                  image: widget.userImage,
                  fit: BoxFit.fill,
                )
              ),
            ),
          ),
          Column(
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
            ],
          )
        ],
      );
    }
}
