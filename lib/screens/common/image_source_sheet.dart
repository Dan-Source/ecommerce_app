import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  final Function(File) onImageSelected;
  final ImagePicker picker = ImagePicker();

  ImageSourceSheet({required this.onImageSelected});
  Future<void> editImage(String path, BuildContext context) async {
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: path,
          aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
            );

      if (croppedFile != null) {
        onImageSelected(croppedFile as File);
      }
  }

  @override
  Widget build(BuildContext context) {


    Future<void> getImageByCamera() async {
      final PickedFile? file = await picker.pickImage(source: ImageSource.camera) as PickedFile?;
      if (file != null) editImage(file.path, context);
    }

    Future<void> getImageByGallery() async {
      final PickedFile? file =
          await picker.pickImage(source: ImageSource.gallery) as PickedFile?;
      if (file != null) editImage(file.path, context);
    }

    if (Platform.isAndroid) {
      return BottomSheet(
        onClosing: () {},
        builder: (_) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
              onPressed: getImageByCamera,
              child: const Text('Câmera'),
            ),
            TextButton(
              onPressed: getImageByGallery,
              child: const Text('Galeria'),
            )
          ],
        ),
      );
    } else {
      return CupertinoActionSheet(
        title: const Text('Selecionar foto para o item'),
        message: const Text('Escolha a origem da foto'),
        cancelButton: CupertinoActionSheetAction(
          onPressed: Navigator.of(context).pop,
          child: const Text('Cancelar'),
        ),
        actions: [
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: getImageByCamera,
            child: const Text('Câmera'),
          ),
          CupertinoActionSheetAction(
            onPressed: getImageByCamera,
            child: const Text('Galeria'),
          )
        ],
      );
    }
  }
}
