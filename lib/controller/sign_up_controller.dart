// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medotg/Screens/homepage/home_page.dart';

import 'package:medotg/models/file_model.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();
  FileModel? _imageFile;
  FileModel? get imageFile => _imageFile;
  void setImageFile(FileModel? file) {
    _imageFile = file;
    debugPrint("Updated ImageFile: ${imageFile!.filename}");
    update();
  }

  FileModel? _resumeFile;
  FileModel? get resumeFile => _resumeFile;
  void setResumeFile(FileModel? file) {
    _resumeFile = file;
    debugPrint("Updated ResumeFile: ${resumeFile!.filename}");
    update();
  }

  String? _userType = "Student";
  String? get userType => _userType;
  void setUserType(String? text) {
    _userType = text;
    debugPrint("Updated userType: $userType");
    update();
  }

  String? _name;
  String? get name => _name;
  void setName(String? text) {
    _name = text;
    debugPrint("Updated name: $name");
    update();
  }

  String? _email;
  String? get email => _email;
  void setEmail(String? text) {
    _email = text;
    debugPrint("Updated email: $email");
    update();
  }

  String? _password;
  String? get password => _password;
  void setPassword(String? text) {
    _password = text;
    debugPrint("Updated password: $password");
    update();
  }

  String? _mobileNumber;
  String? get mobileNumber => _mobileNumber;
  void setMobileNumber(String? text) {
    _mobileNumber = text;
    debugPrint("Updated mobileNumber: $mobileNumber");
    update();
  }

  String? _hospitalName;
  String? get hospitalName => _hospitalName;
  void setHospitalName(String? text) {
    _hospitalName = text;
    debugPrint("Updated hospitalName: $hospitalName");
    update();
  }

  String? _admissionYear;
  String? get admissionYear => _admissionYear;
  void setAdmissionYear(String? text) {
    _admissionYear = text;
    debugPrint("Updated admissionYear: $admissionYear");
    update();
  }

  String? _passOutYear;
  String? get passOutYear => _passOutYear;
  void setPassOutYear(String? text) {
    _passOutYear = text;
    debugPrint("Updated passOutYear: $passOutYear");
    update();
  }

  Future postSignUpDetails() async {
    String newDocId =
        FirebaseAuth.instance.currentUser?.uid ?? ''; // New document ID

// Create a new document with a new ID
    DocumentReference newDocRef =
        FirebaseFirestore.instance.collection('user').doc(newDocId);

    String imageUrl = await uploadImageFile(); // Upload image and get URL

// Save data to a new document
    await newDocRef.set({
      'docId': newDocId,
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'userType': userType,
      'name': name,
      'email': email,
      'password': password,
      'mobileNumber': mobileNumber,
      'hospitalName': hospitalName,
      'imageUrl': imageUrl,
    });

    uploadResumeFile();
    await Get.offAll(() => const HomeScreenBody());
  }
  Future uploadImageFile() async {
  if (imageFile == null) {
    throw Exception('Image file is null');
  }

  var uploadTask = await FirebaseStorage.instance
      .ref('files/${imageFile!.filename}')
      .putData(imageFile!.fileBytes);

  var downloadURL = await uploadTask.ref.getDownloadURL();
  return downloadURL.toString(); // Return the download URL
}

  Future<String> uploadResumeFile() async {
  if (userType == "Employee") {
    if (resumeFile != null) {
      await uploadResumeFile();
    } else {
      throw('No resume file selected');
    }
  }

    var uploadTask = await FirebaseStorage.instance
        .ref('files/${resumeFile!.filename}')
        .putData(resumeFile!.fileBytes);

    var downloadURL = await uploadTask.ref.getDownloadURL();
    return downloadURL.toString(); // Return the download URL
  }
  Future<bool> registerUser(String email, String password) async {
    try {
      var response = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return true;
    } catch (error) {
      if (error is FirebaseAuthException) {
        Get.showSnackbar(GetSnackBar(
          message: error.toString(),
        ));
      }
    }
    return false;
  }
}
