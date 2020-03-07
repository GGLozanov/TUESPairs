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

  File profilePicture; // always null in the beginning
  final Database database = new Database();
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  ImageService({this.profilePicture});

  Future<File> getImageByGallery() async {
    return await ImagePicker.pickImage(source: ImageSource.gallery);
  }


  Future<File> getImageByCamera() async {
    return await ImagePicker.pickImage(source: ImageSource.camera);
  }

  Future uploadPicture() async {
    if(profilePicture == null) return;
    String fileName = basename(profilePicture.path); // derive the name from the full file path
    StorageReference firebaseStorageReference = firebaseStorage.ref().child(fileName); // creates such a reference if not found
    StorageUploadTask uploadTask = firebaseStorageReference.putFile(profilePicture);

    // check completion through a snapshot
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
  }


  Future updateUserProfileImage(User currentUser) async {
    if(profilePicture == null) return;
    await database.updateUserPhotoURL(currentUser, basename(profilePicture.path));
  }

  Future<NetworkImage> getImageByURL(String photoURL) async {
    try{
      StorageReference reference = firebaseStorage.ref().child(photoURL);
      String URL = await reference.getDownloadURL();
      print(URL);
      return NetworkImage(URL);
    }catch(e){
      print(e.toString());
    }
  }

}