import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final void Function(File? image) onImageSelected;

  const ImagePickerWidget({super.key, required this.onImageSelected});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _imageFile;

  Future<void> _pickImage(ImageSource source) async{
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 85);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      widget.onImageSelected(_imageFile);
    }
  }

  void _showPickerOptions(){
    showModalBottomSheet(context: context,
        builder: (_) => SafeArea(child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Tirar foto"),
              onTap: (){
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Escolha da galeria"),
              onTap: (){
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        )
        ));
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showPickerOptions,
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: _imageFile != null ? FileImage(_imageFile!): null,
            child: _imageFile == null ? const Icon(Icons.person_add_alt_1, size: 50,): null,
          ),
          const SizedBox(height: 10,),
          const Text("Toque para adicionar imagem"),
        ],
      ),
    );
  }
}


//no model, acionar final String? imagemPath
//colocar nos frommap
//no database, atualizar também imagemPath TEXT
//ao utilizar, usar no elemento o
