import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class Utils {
  static showToast(
    Color backgroundColor,
    Color textColor,
    String text,
  ) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0,
    );
  }

  static Future<List<File>> pickedMultipleImage() async {
    List<File> images = [];
    List<XFile?> image = await ImagePicker().pickMultiImage(
      imageQuality: 100,
      maxWidth: 1000,
      maxHeight: 1000,
    );
    for (var i = 0; i < image.length; i++) {
      images.add(File(image[i]!.path));
    }
    return images;
  }

  
}
