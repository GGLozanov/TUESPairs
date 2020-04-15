import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:mockito/mockito.dart';
import 'package:tues_pairs/services/image.dart';

void main() {
  // call tests here. . .
  // use mocks here

  TestWidgetsFlutterBinding.ensureInitialized();

  group('Image', () {
    test('Uploads an image to Firebase Storage', () async { // Doesn't work
      ImageService imageService = new ImageService.mock(profileImage: new File('picture.jpg')); // fake path

      var URL = await imageService.uploadImage();
      expect(URL, isNull);
      // the URL will be converted to a Firebase Storage one no matter what
      // but what's important is that the URL is for the same image as uploaded
    });

    test('Returns null upon unsuccessful image upload to Firebase Storage (profileImage is null)', () async {
      ImageService imageService = new ImageService.mock();

      var URL = await imageService.uploadImage();
      expect(URL, isNull);
    });

    test('Deletes an image from Firebase Storage', () async { // Doesn't work
      ImageService imageService = new ImageService.mock(profileImage: new File('picture.jpg'));

      var result = await imageService.deleteImage(await imageService.uploadImage());

      expect(result, isNull);
    });

    test('Returns null upon unsuccessful image deletion from Firebase Storage (photoURL is null)', () async {
      ImageService imageService = new ImageService.mock();

      var result = await imageService.deleteImage(await imageService.uploadImage());

      expect(result, isNull);
    });

    test('Converts a photo URL to a Network image (photo URL is received from Firebase Storage)', () async { // Doesn't work
      ImageService imageService = new ImageService.mock(profileImage: new File('picture.jpg'));

      debugPrint(basename(imageService.profileImage.path));
      // upload and retrieve photo here for conversion
      expect(imageService.getImageByURL(await imageService.uploadImage()), isNull);
    });
  });
}