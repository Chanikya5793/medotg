// ignore_for_file: unused_field, file_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medotg/Screens/record/editrecordPage.dart';
import 'package:medotg/Screens/homepage/components/home_page_body.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'pdf_screen.dart';
class DetailRecordPage extends StatefulWidget {
  final String id;
  final String patientName;

  const DetailRecordPage({super.key, required this.id, required this.patientName});

  @override
  State<DetailRecordPage> createState() => _DetailRecordPageState();
}


class _DetailRecordPageState extends State<DetailRecordPage> {
  DocumentSnapshot? _articleSnapshot;
  DocumentSnapshot? _userSnapshot;
  User? user = FirebaseAuth.instance.currentUser;

  bool isLiked = false; // status like
  bool isSaved = false; // status save

  final TextEditingController _commentController = TextEditingController();
  // Add a new state variable for user type
  String? userType;

  @override
  void initState() {
    super.initState();
    // Retrieving data records from firestore
    _fetchArticle();
    _fetchUserType();
  }

  @override
  void dispose() {
    // Dispose of resources here
    // For example, if you have any controllers or other resources to dispose of, do it here.
    super.dispose();
  }

  Future<void> _fetchArticle() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('patients').doc(widget.patientName).collection('records')
          .doc(widget.id)
          .get();

      if (snapshot.exists) {
        setState(() {
          _articleSnapshot = snapshot;
        });
      } else {
        print('Record not found');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  // Fetch user type from Firestore
  Future<void> _fetchUserType() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();
      if (snapshot.exists) {
        setState(() {
          userType = (snapshot.data() as Map<String, dynamic>)['userType'];
        });
      }
    }
  }

  Future<void> _delete() async {
    await FirebaseFirestore.instance
        .collection('patients').doc(widget.patientName).collection('records')
        .doc(widget.id)
        .delete();
  }

  Future<void> _sendComment() async {
    // Get current user
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && _commentController.text.isNotEmpty) {
      String username = '';

      // Fetch user data from the collection
      await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get()
          .then((snapshot) {
        if (snapshot.exists) {
          username = snapshot.data()?['name'];
        } else {
          print('User data not found');
        }
      }).catchError((error) {
        print('Error fetching user data: $error');
      });

      if (username.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('patients').doc(widget.patientName).collection('records')
            .doc(widget.id)
            .collection('comment')
            .add({
          'comment': _commentController.text,
          'timestamp': Timestamp.now(),
          'username': username,
        }).then((_) {
          // Clear the text field
          _commentController.clear();
        }).catchError((error) {
          print('Error adding comment: $error');
        });
      } else {
        print('Username not found');
      }
    } else {
      print('Comment is empty or user is not signed in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _articleSnapshot?['title'] ?? '',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                isSaved = !isSaved;
              });
            },
          ),
        if (userType != 'Patient') ...[
            IconButton(
              onPressed: () {
                _showDeleteConfirmationDialog();
              },
              icon: const Icon(Icons.delete),
              color: Colors.black,
            ),
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.black,
              ),
              onPressed: () {
                // navigate to edit page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditRecordPage(documentId: widget.id)),
                );
              },
            ),
          ],
          ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  _articleSnapshot?['imageUrl'] ??
                      'https://firebasestorage.googleapis.com/v0/b/health-5f252.appspot.com/o/images%2F2023-05-26%2022%3A44%3A10.930239.png?alt=media&token=9c55f402-c174-498b-bef1-35b364f6f55c',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text('View PDF'),
                onPressed: () async {
                  // Store the context in a local variable before the async operation
                  BuildContext currentContext = context;

                  // Fetch the PDF URL from Firestore
                  String pdfUrl = _articleSnapshot?['pdfUrl'];

                  // Download the PDF file and get the local path
                  var dio = Dio();
                  var dir = await getApplicationDocumentsDirectory();
                  var pdfPath = '${dir.path}/file.pdf';
                  await dio.download(pdfUrl, pdfPath);

                  // Use the stored context here
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    currentContext,
                    MaterialPageRoute(
                      builder: (context) => PDFScreen(pdfPath),
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        isLiked = !isLiked;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                _articleSnapshot?['description'] ?? '',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: 'Add comments',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendComment,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Comment',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('patients').doc(widget.patientName).collection('records')
                    .doc(widget.id)
                    .collection('comment')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data?.docs.length ?? 0,
                    itemBuilder: (context, index) {
                      DocumentSnapshot comment = snapshot.data!.docs[index];
                      String username = comment['username'];
                      String commentText = comment['comment'];
                      Timestamp timestamp = comment['timestamp'];
                      DateTime dateTime = timestamp.toDate();
                      String formattedDate =
                          DateFormat('dd/MM/yyyy HH:mm').format(dateTime);

                      return ListTile(
                        title: Text('$username: $commentText'),
                        subtitle: Text(formattedDate),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text('Are you sure you want to delete this data?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _delete(); // Call the function to clear the data
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreenBody()),
                  );
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
