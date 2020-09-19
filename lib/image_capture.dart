import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form/uploader.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

//Widget to capture and crop the file
class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    Future<void> _pickImage(ImageSource source) async {
      ImagePicker imagePicker = ImagePicker();
      PickedFile selected = await imagePicker.getImage(source: source);

      setState(() {
        _imageFile = File(selected.path);
      });
    }

    Future<void> _cropImage() async {
      File cropped = await ImageCropper.cropImage(sourcePath: _imageFile.path);

      setState(() {
        _imageFile = cropped ?? _imageFile;
      });
    }

    void _clear() {
      setState(() {
        _imageFile = null;
      });
    }

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () => {_pickImage(ImageSource.camera)},
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () => {_pickImage(ImageSource.gallery)},
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          if (_imageFile != null) ...[
            Image.file(_imageFile),
            Row(
              children: [
                FlatButton(onPressed: _cropImage, child: Icon(Icons.crop)),
                FlatButton(onPressed: _clear, child: Icon(Icons.refresh)),
              ],
            ),
            Uploader(file: _imageFile)
          ]
        ],
      ),
    );
  }
}
