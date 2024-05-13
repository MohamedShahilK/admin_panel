// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';


// mixin ImagePickerMixin on Widget {
mixin ImagePickerMixin{
  Future<ImageSource?> selectImagePickerSource(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              ListTile(
                title: const Text('Camera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              SizedBox(height: 10),
              ListTile(
                title: const Text('Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );
  }

   Future<XFile?> pickXFileImage(
    BuildContext context, {
    ImageSource imageSource = ImageSource.gallery,
  }) async {
    XFile? xFile;
    // await _checkForPermissions(context, imageSource, pickVideo)
    // await _checkForPermissions(context, imageSource)
    //     .then((value) async {
    //   if (value) {
    //     final imagePicker = ImagePicker();
    //     try {
    //       xFile =
    //           await imagePicker.pickImage(source: imageSource, maxWidth: 512);
    //     } catch (e) {
    //       debugPrint(e.toString());
    //       return null;
    //     }
    //   }
    // });
    final imagePicker = ImagePicker();
    try {
      // xFile = await imagePicker.pickImage(source: imageSource, maxWidth: 512);
      xFile = await imagePicker.pickImage(source: imageSource, maxWidth:800,maxHeight: 600);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
    return xFile;
  }
}
