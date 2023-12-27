// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medotg/Screens/homepage/components/home_page_body.dart';
import 'package:file_picker/file_picker.dart';

class AddArticlePage extends StatefulWidget {
  const AddArticlePage({super.key});

  @override
  State<AddArticlePage> createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
  final TextEditingController _searchQueryController = TextEditingController();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();

  File? _imageFile;
  final _storage = FirebaseStorage.instance;
  //final _articleCollection = FirebaseFirestore.instance.collection('Collection');

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }
File? _pdfFile;

Future<void> _pickPdf() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  setState(() {
    if (result != null) {
      _pdfFile = File(result.files.single.path!);
    }
  });
}
  Future<String?> _uploadImageToFirebase() async {
  if (_imageFile == null) {
    bool? confirmed = await Get.defaultDialog<bool>(
      title: 'No Image selected',
      middleText: 'Do you want to continue without selecting a Image?',
      textConfirm: 'Yes',
      textCancel: 'No',
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(result: true),
      onCancel: () => Get.back(result: false),
    );

    if (confirmed == true) {
      return null;
    } else {
      throw Exception('No Image selected');
    }
  }


    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = _storage.ref().child('images/$fileName');
    await ref.putFile(_imageFile!);

    return await ref.getDownloadURL();
  }Future<String?> _uploadPdfToFirebase() async {
  if (_imageFile == null) {
    bool? confirmed = await Get.defaultDialog<bool>(
      title: 'No Report selected',
      middleText: 'Do you want to continue without selecting a Report?',
      textConfirm: 'Yes',
      textCancel: 'No',
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(result: true),
      onCancel: () => Get.back(result: false),
    );

    if (confirmed == true) {
      return null;
    } else {
      throw Exception('No Report selected');
    }
  }


  final fileName = DateTime.now().millisecondsSinceEpoch.toString();
  final ref = _storage.ref().child('pdfs/$fileName');
  await ref.putFile(_pdfFile!);

  return await ref.getDownloadURL();
}

  Future<void> _saveData() async {
    try {
      if (_formKey1.currentState!.validate() && _formKey2.currentState!.validate()) {
        String title = _title.text;
        String description = _description.text;

        String? imageUrl = await _uploadImageToFirebase();
        String? pdfUrl = await _uploadPdfToFirebase(); // New line

        /*await _articleCollection.add({
          'uid': FirebaseAuth.instance.currentUser!.uid,
          'title': title,
          'description': description,
          'imageUrl': imageUrl ?? "",
          'pdfUrl': pdfUrl ?? "", // New line
          'date': Timestamp.now(),
        });*/
        final patientRecordsCollection = FirebaseFirestore.instance.collection('patients').doc(_searchQueryController.text).collection('records');

        await patientRecordsCollection.add({
          'uid': FirebaseAuth.instance.currentUser!.uid,
          'title': title,
          'description': description,
          'imageUrl': imageUrl ?? "",
          'pdfUrl': pdfUrl ?? "", // New line
          'date': Timestamp.now(),
        });

        Get.snackbar('Success', 'Data added successfully');
        Get.off(() => const HomeScreenBody());
      }
    } catch (e) {
      Get.snackbar('Error', 'There is an error when adding data');
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
              bottomRight: Radius.circular(12),
            ),
            gradient: LinearGradient(
              colors: [Colors.green, Colors.greenAccent],
            ),
          ),
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.post_add_outlined, size: 40),
            Text('Add Record'),
            SizedBox(width: 120),
          ],
        ),
      ),
      
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30),
              child: Form(
                key: _formKey1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _searchQueryController,
                      decoration: const InputDecoration(
                        labelText: 'Search patients',
                      ),
                      onChanged: (value) {
                        // Call setState to trigger a rebuild of the widget with the new search query
                        setState(() {});
                      },
                    ),
                    // ... rest of your code ...
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Form(
                key: _formKey2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _title,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.title, color: Colors.brown),
                        labelText: 'Enter a Record Title',
                        errorStyle: TextStyle(color: Colors.grey),
                      ),
                      maxLength: 25,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please enter a title';
                        }
                        return null;
                      },
                      onSaved: (value) {},
                    ),
                    TextFormField(
                      maxLength: 1000,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      controller: _description,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.description_outlined,
                            color: Colors.green),
                        labelText: 'Enter a description of the record',
                        errorStyle: TextStyle(color: Colors.grey),
                      ),
                      autofocus: false,
                      maxLines: 10,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please enter a description';
                        }
                        return null;
                      },
                      onSaved: (value) {},
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _pickPdf, // This will open the file picker when the button is pressed
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: _pdfFile != null
                            ? const Icon(Icons.picture_as_pdf, color: Colors.grey)
                            : const Icon(Icons.add, color: Colors.grey),
                      ),
                    ),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: _imageFile != null
                            ? Image.file(_imageFile!, fit: BoxFit.cover)
                            : const Icon(Icons.add_a_photo, color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(45, 8, 15, 8),
                      child: ElevatedButton(
                        autofocus: true,
                        onPressed: _saveData,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        child: const Text('Save', style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
