// ignore_for_file: file_names, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medotg/Screens/homepage/components/home_page_body.dart';

class AkunPage extends StatefulWidget {
  const AkunPage({super.key});

  @override
  AkunPageState createState() => AkunPageState();
}

class AkunPageState extends State<AkunPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late User user;
  String? username, email, mobileNumber, userType, hospitalName;

  @override
  void initState() {
    super.initState();
    user = auth.currentUser!;
    _loadUserProfile();
  }

  // Metode untuk mengambil dan memuat data profil pengguna dari Firestore
  Future<void> _loadUserProfile() async {
    var docSnapshot = await firestore.collection("user").doc(user.uid).get();
    if (docSnapshot.exists) {
      var userData = docSnapshot.data();
      setState(() {
        username = userData!["name"];
        email = userData["email"];
        mobileNumber = userData["mobileNumber"];
        userType = userData["userType"];
        hospitalName = userData["hospitalName"];
      });
    }
  }

  // Metode untuk menampilkan dialog pengeditan dan menyimpan perubahan data profil
  void _showEditDialog(String field) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? value = '';

        return AlertDialog(
          title: Text('Edit $field'),
          content: TextField(
            onChanged: (newValue) {
              value = newValue;
            },
            decoration: InputDecoration(
              labelText: field,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                if (value != null && value!.isNotEmpty) {
                  try {
                    await firestore
                        .collection('user')
                        .doc(user.uid)
                        .update({field: value});
                    setState(() {
                      // Memperbarui nilai bidang yang sesuai di state
                      switch (field) {
                        case 'name':
                          username = value;
                          break;
                        case 'email':
                          email = value;
                          break;
                        case 'mobileNumber':
                          mobileNumber = value;
                          break;
                        case 'hospitalName':
                          hospitalName = value;
                          break;
                        case 'userType':
                          userType = value;
                          break;
                        default:
                          break;
                      }
                    });
                    Navigator.pop(context);
                  } catch (e) {
                    print('Error updating user data: $e');
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Menampilkan tombol kembali dan judul halaman
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreenBody()),
            );
          },
        ),
        title: const Text('Settings'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Metode yang akan dipanggil saat tombol pengaturan diklik
            },
          ),
        ],
      ),
      body: StreamBuilder(
        // StreamBuilder untuk mendapatkan data profil pengguna dari Firestore
        stream: FirebaseFirestore.instance
            .collection('user')
            .where('uid', isEqualTo: auth.currentUser!.uid)
            .snapshots()
            .map((querySnapshot) => querySnapshot.docs.first),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!.data();
            var username = data['name'];
            var email = data['email'];
            var mobileNumber = data['mobileNumber'];
            var hospitalName = data['hospitalName'];
            var userType = data['userType'];

            return ListView(
              children: <Widget>[
                // Item daftar untuk setiap bidang profil pengguna
                ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: const Text('Username'),
                  subtitle: Text(username ?? 'Loading...'),
                  onTap: () => _showEditDialog(
                      'name'), // Menampilkan dialog pengeditan saat item diklik
                ),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Email'),
                  subtitle: Text(email ?? 'Loading...'),
                  onTap: () => _showEditDialog('email'),
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: const Text('Mobile Number'),
                  subtitle: Text(mobileNumber ?? 'Loading...'),
                  onTap: () => _showEditDialog('mobileNumber'),
                ),
                ListTile(
                  leading: const Icon(Icons.school),
                  title: const Text('Hospital Name'),
                  subtitle: Text(hospitalName ?? 'Loading...'),
                  onTap: () => _showEditDialog('hospitalName'),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('User Type'),
                  subtitle: Text(userType ?? 'Loading...'),
                  onTap: () => _showEditDialog('userType'),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
