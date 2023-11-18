// ignore_for_file: unused_field, file_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medotg/Screens/article/editrecordPage.dart';
import 'package:medotg/Screens/homepage/components/home_page_body.dart';

class DetailRecordPage extends StatefulWidget {
  final String id;

  const DetailRecordPage({Key? key, required this.id}) : super(key: key);
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

  @override
  void initState() {
    super.initState();
    // Retrieving data records from firestore
    _fetchArticle();
  }

  Future<void> _fetchArticle() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Collection')
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

  Future<void> _delete() async {
    await FirebaseFirestore.instance
        .collection('Collection')
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
            .collection('Collection')
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
              // navigasi ke halaman edit
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EditRecordPage(documentId: widget.id)),
              );
            },
          ),
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
                    .collection('Collection')
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
            title: const Text('Konfirmasi Hapus'),
            content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup dialog
                },
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  _delete(); // Panggil fungsi untuk menghapus data
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreenBody()),
                  );
                },
                child: const Text(
                  'Hapus',
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
