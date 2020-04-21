import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:tues_pairs/shared/constants.dart';
import 'dart:io';

class ImageService {

  File profileImage; // always null in the beginning unless specified
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  ImageService({this.profileImage}) {
    final profileImageMsg = this.profileImage != null ? this.profileImage.path : 'null';
    logger.i('ImageService: Creating real instance of ImageService w/ profileImage' + profileImageMsg + '; ' + toString());
  }

  ImageService.mock({this.profileImage}) {
    final profileImageMsg = this.profileImage != null ? this.profileImage.path : 'null';
    logger.i('ImageService: Creating mock instance of ImageService w/ profileImage' + profileImageMsg + '; ' + toString());
    firebaseStorage = MockFirebaseStorage();
  }

  Future<File> getImageByGallery() async {
    return await ImagePicker.pickImage(source: ImageSource.gallery);
  }


  Future<File> getImageByCamera() async {
    return await ImagePicker.pickImage(source: ImageSource.camera);
  }

  Future uploadImage() async {
    if(profileImage != null) {
      String fileName = basename(profileImage.path); // derive the name from the full file path

      logger.i('ImageService: uploadImage Uploading file "' + fileName + '" to Firebase Storage');

      StorageReference firebaseStorageReference = firebaseStorage.ref().child(fileName); // creates such a reference if not found
      StorageUploadTask uploadTask = firebaseStorageReference.putFile(profileImage);

      // check completion through a snapshot
      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
      return await firebaseStorageReference.getDownloadURL();
    }

    logger.w('ImageService: uploadImage has been called with a null profileImage => returning null');

    return null;
  }

  Future deleteImage(String photoURL) async {
    if(photoURL != null) {
      try {
        StorageReference imageRef = await firebaseStorage.getReferenceFromUrl(photoURL);
        await imageRef.delete();
        logger.i('ImageService: Successfully deleted image with URL "' + photoURL + '" from Firebase Storage');
        return 1; // code for successful pass
      } catch (e) {
        logger.e('ImageService: ' + e.toString());
        return null;
      }
    }

    logger.w('ImageService: deleteImage has been called with a null photoURL => returning null');

    return null;
  }

  NetworkImage getImageByURL(String photoURL) {
    if(photoURL != null) {
      try {
        logger.i('ImageService: getImageByURL has been called with a photoURL "' + photoURL + '"; returning NetworkImage with that URL');
        return NetworkImage(photoURL);
      } catch (e) {
        logger.e('ImageService: ' + e.toString());
        return null;
      }
    }

    logger.w('ImageService: getImageByURL has been called with a null photoURL => returning null');

    return null;
  }

}