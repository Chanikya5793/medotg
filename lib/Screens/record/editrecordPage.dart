// ignore_for_file: file_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medotg/Screens/homepage/components/home_page_body.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart'as path;

late TextEditingController _recordUrlController;


class EditRecordPage extends StatefulWidget {
  final String documentId;

  const EditRecordPage({super.key, required this.documentId});

  @override
  EditRecordPageState createState() => EditRecordPageState();
}

class EditRecordPageState extends State<EditRecordPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;

Future<void> _viewImage() async {
  String imageUrl = _imageUrlController.text;
  if (imageUrl.isNotEmpty) {
    await launchUrl(Uri.parse(imageUrl)); // Convert the String to a Uri
  }
}
Future<void> _viewRecord() async {
  String recordUrl = _recordUrlController.text;
  if (recordUrl.isNotEmpty) {
    await launchUrl(Uri.parse(recordUrl)); // Requires the url_launcher package
  }
}

Future<void> _deleteImage() async {
  String imageUrl = _imageUrlController.text;
  if (imageUrl.isNotEmpty) {
    Reference storageReference = FirebaseStorage.instance.refFromURL(imageUrl);
    await storageReference.delete();
    _imageUrlController.text = '';
  }
}

Future<void> _deleteRecord() async {
  String recordUrl = _recordUrlController.text;
  if (recordUrl.isNotEmpty) {
    Reference storageReference = FirebaseStorage.instance.refFromURL(recordUrl);
    await storageReference.delete();
    _recordUrlController.text = '';
  }
}
  Future<void> _addImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('images/${path.basename(image.path)}');
      UploadTask uploadTask = storageReference.putFile(image);
      await uploadTask.whenComplete(() async {
        _imageUrlController.text = await storageReference.getDownloadURL();
      });
    }
  }
Future<void> _addRecord() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    File record = File(result.files.single.path!);
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('records/${path.basename(record.path)}');
    UploadTask uploadTask = storageReference.putFile(record);
    await uploadTask.whenComplete(() async {
      _recordUrlController.text = await storageReference.getDownloadURL();
    });
  }
}
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _imageUrlController = TextEditingController();
    _recordUrlController = TextEditingController();
    _fetchData();
    
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _recordUrlController.dispose();
    super.dispose();
    
  }

  void _fetchData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Collection')
        .doc(widget.documentId)
        .get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      setState(() {
        _titleController.text = data['title'];
        _descriptionController.text = data['description'];
        _imageUrlController.text = data['imageUrl'];
        _recordUrlController.text = data['recordUrl'];
      });
    }
  }

void _uploadData() async {
  String title = _titleController.text;
  String description = _descriptionController.text;
  String imageUrl = _imageUrlController.text;
  String recordUrl = _recordUrlController.text;
  if (title.isNotEmpty && description.isNotEmpty) {
    await FirebaseFirestore.instance
        .collection('Collection')
        .doc(widget.documentId)
        .update({
      'title': title,
      'description': description,
      'imageUrl': imageUrl, // This will be an empty string if the image was deleted
      'recordUrl': recordUrl,
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreenBody()),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        flexibleSpace: Container(
          width: 200,
          height: 200,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12)),
            gradient:
                LinearGradient(colors: [(Color.fromARGB(255, 115, 210, 118)), Colors.greenAccent]),
          ),
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.edit_outlined, size: 40),
            Text('Edit Record'),
            SizedBox(
              width: 180,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  icon: Icon(
                    Icons.title,
                    color: Colors.brown,
                  ),
                  labelText: 'Enter a Record Title',
                  errorStyle: TextStyle(color: Colors.grey),
                ),
                maxLength: 25,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  icon: Icon(
                    Icons.description_outlined,
                    color: Colors.green,
                  ),
                  labelText: 'Enter a record description',
                  errorStyle: TextStyle(color: Colors.grey),
                ),
                maxLines: 10,
                keyboardType: TextInputType.multiline,
                maxLength: 1000,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
              ),
              const SizedBox(height: 16.0),
            /*  TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  icon: Icon(
                    Icons.image_outlined,
                    color: Colors.green,
                  ),
                  labelText: 'Enter Image URL',
                  errorStyle: TextStyle(color: Colors.grey),
                ),
              ), */
              ElevatedButton(
                onPressed: _viewImage,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 115, 210, 118)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                child: const Text('View Image',style: TextStyle(color: Colors.black),),
              ),
              ElevatedButton(
                onPressed: _viewRecord,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 115, 210, 118)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                child: const Text('View Record',style: TextStyle(color: Colors.black),),
              ),
              ElevatedButton(
                onPressed: () async {
                  final confirm = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Delete',style: TextStyle(color: Colors.red),),
                      content: const Text('Are you sure you want to delete the image?',style: TextStyle(color: Colors.red),),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Yes',style: TextStyle(color: Colors.red),),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('No',style: TextStyle(color: Color.fromARGB(255, 0, 18, 1)),),
                        ),
                      ],
                    ),
                  );
                  if (confirm) {
                    _deleteImage();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Image deleted',style: TextStyle(color: Colors.red),)),
                    );
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                child: const Text('Delete Image',style: TextStyle(color: Colors.black),),
              ),
              ElevatedButton(
                onPressed: () async {
                  final confirm = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Delete',style: TextStyle(color: Colors.red),),
                      content: const Text('Are you sure you want to delete the record?',style: TextStyle(color: Colors.red),),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Yes',style: TextStyle(color: Colors.red),),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('No',style: TextStyle(color: Color.fromARGB(255, 0, 10, 0)),),
                    )],
                    ),
                  );
                  if (confirm) {
                    _deleteRecord();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Record deleted',style: TextStyle(color: Colors.red),)),
                    );
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                child: const Text('Delete Record',style: TextStyle(color: Colors.black),),
              ),
              ElevatedButton(
                onPressed: _addImage,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 115, 210, 118)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                child: const Text('Add Image',style: TextStyle(color: Colors.black),),
              ),
              ElevatedButton(
                onPressed: _addRecord,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 115, 210, 118)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                child: const Text('Add Record',style: TextStyle(color: Colors.black),),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _uploadData,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color.fromARGB(255, 115, 210, 118)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                child: const Text('Save',style: TextStyle(color: Colors.black),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
