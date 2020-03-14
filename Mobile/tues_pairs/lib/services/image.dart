import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tues_pairs/templates/baseauth.dart';
import 'package:tues_pairs/modules/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:tues_pairs/services/database.dart';
import 'dart:io';

class ImageService {

  File profileImage; // always null in the beginning
  final Database database = new Database();
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  ImageService({this.profileImage});

  Future<File> getImageByGallery() async {
    return await ImagePicker.pickImage(source: ImageSource.gallery);
  }


  Future<File> getImageByCamera() async {
    return await ImagePicker.pickImage(source: ImageSource.camera);
  }

  Future uploadImage() async {
    if(profileImage == null) return null;
    String fileName = basename(profileImage.path); // derive the name from the full file path
    StorageReference firebaseStorageReference = firebaseStorage.ref().child(fileName); // creates such a reference if not found
    StorageUploadTask uploadTask = firebaseStorageReference.putFile(profileImage);

    // check completion through a snapshot
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
  }

  Future<NetworkImage> getImageByURL(String photoURL) async {
    try{
      StorageReference reference = firebaseStorage.ref().child(photoURL);
      String URL = await reference.getDownloadURL();
      return NetworkImage(URL);
    }catch(e){
      print(e.toString());
    }
  }

}