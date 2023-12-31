// ignore_for_file: prefer_const_constructors, avoid_print, use_super_parameters, use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medotg/Screens/account/accountPage.dart';
import 'package:medotg/Screens/login/login.dart';
import 'package:medotg/Screens/record/addRecordPage.dart';
import 'package:medotg/Screens/record/detailRecordPage.dart';

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({Key? key}) : super(key: key);

  @override
  State<HomeScreenBody> createState() => HomeScreenBodyState();
}

class UserProfileDrawerHeader extends StatefulWidget {
  const UserProfileDrawerHeader({super.key});

  @override
  UserProfileDrawerHeaderState createState() =>
      UserProfileDrawerHeaderState();
}

class UserProfileDrawerHeaderState extends State<UserProfileDrawerHeader> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('user')
          .where('uid', isEqualTo: auth.currentUser!.uid)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs.first),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const UserAccountsDrawerHeader(
            accountName: Text('Loading...'),
            accountEmail: Text('Loading...'),
            currentAccountPicture: CircleAvatar(backgroundColor: Colors.orange),
          );
        }

        if (snapshot.hasError) {
          return const UserAccountsDrawerHeader(
            accountName: Text('Error'),
            accountEmail: Text('Error'),
            currentAccountPicture: CircleAvatar(backgroundColor: Colors.red),
          );
        }

        if (snapshot.hasData) {
          var data = snapshot.data!.data();
          var username = data['name'];
          var email = data['email'];
          var userType = data['userType'];
          var imageUrl = data['imageUrl'];

          return UserAccountsDrawerHeader(
            accountName: Text(username),
            accountEmail: Text('$userType , $email'),
            currentAccountPicture: imageUrl != null
                ? CircleAvatar(backgroundImage: NetworkImage(imageUrl))
                : const CircleAvatar(backgroundColor: Colors.orange),
          );
        }

        return const UserAccountsDrawerHeader(
          accountName: Text('No data'),
          accountEmail: Text('No data'),
          currentAccountPicture: CircleAvatar(backgroundColor: Colors.orange),
        );
      },
    );
  }
}

class HomeScreenBodyState extends State<HomeScreenBody> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String patientName = ''; // Store the patient name

  final TextEditingController _searchController = TextEditingController();
  String _searchKeyword = '';
  String userType = '';
    @override
    void initState() {
      super.initState();
      fetchUserType();
    }

  Future<void> fetchUserType() async {
    if (auth.currentUser != null) {
      var doc = await firestore.collection('user').doc(auth.currentUser!.uid).get();
      if (doc.exists && doc.data()?.containsKey('userType') == true) {
        if (mounted) {
          setState(() {
            userType = doc.data()?['userType'] ?? '';
            patientName = doc.data()?['name'] ?? ''; // Fetch patient name
          });
        }
      } else {
        print('Document does not exist or does not contain userType field');
      }
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
                LinearGradient(colors: [Colors.green, Colors.greenAccent]),
          ),
        ),
        title: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,// give space between widgets
          children: [
            const Icon(Icons.tips_and_updates_outlined, size: 40),
            const Text('MEDOTG'),
            const SizedBox(
              width: 100,
            ),
            GestureDetector(
              onTap: () {
                if (userType == 'Patient') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("You Don't Have Access to Upload"),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddArticlePage()),
                  );
                }
              },
              child: const Icon(Icons.post_add_outlined),
            ),
          ],
        ),
      ),

          body: userType == 'Employee'
        ? StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('patients').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                  return ListTile(
                    title: Text(data['name']),
                    onTap: () {
                      setState(() {
                        patientName = data['name'];
                        //patientId = document.id;
                      });
                    },
                  );
                }).toList(),
              );
            },
          )
       // : Container(), // Render nothing for non-employee users

      : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Add carousel here
          SizedBox(
            //height: 200, // Adjust this value as needed
            /*child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('patients')  // Access the "patients" collection
              .doc(patientName)  // Access the subcollection with the patient's name
              .collection('records')  // Access the records collection within the subcollection
              .where('title', isGreaterThanOrEqualTo: _searchKeyword)
              .where('patientName', isEqualTo: patientName)
              .snapshots(),*/
              child: StreamBuilder<QuerySnapshot>(
                stream: patientName.isNotEmpty
                  ? FirebaseFirestore.instance.collection('patients')
                      .doc(patientName)
                      .collection('records')
                      .snapshots()
                  : Stream.empty(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                return CarouselSlider(
                  options: CarouselOptions(
                    aspectRatio: 1.5,
                    autoPlay: true,
                  ),
                  items: snapshot.data!.docs.map((doc) {
                      String imageUrl = doc['imageUrl']; // Get the image URL from the document
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Card(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  FadeInImage.assetNetwork(
                                    placeholder: 'assets/Images/loading.gif', // Replace with your own loading gif
                                    image: imageUrl,
                                    fit: BoxFit.cover,
                                    imageErrorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                      // You can return any widget you want to display when the image fails to load
                                      return const Text('Error loading image');
                                    },
                                  ),
                                  Text(doc['title']), // This line was outside the Column's children list
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),

          // ... other code ...
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchKeyword = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Latest Records',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
              // For the ListView.builder
              StreamBuilder<QuerySnapshot>(
                stream: patientName.isNotEmpty
                  ? FirebaseFirestore.instance.collection('patients')
                      .doc(patientName)
                      .collection('records')
                      .where('title', isGreaterThanOrEqualTo: _searchKeyword)
                      .snapshots()
                  : Stream.empty(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('There is an error');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.data == null) {
                    return const Text('No data available');
                  }

                  // Retrieve article data from snapshot
                  List<DocumentSnapshot> articles = snapshot.data!.docs;

                  return SizedBox(
                    height: 500, // Adjust this value as needed
                    child: ListView.builder(
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        // Retrieve title and imageUrl data from the article
                        String title = articles[index]['title'];
                        String imageUrl = articles[index]['imageUrl'];
                        Timestamp timestamp = articles[index]['date'];
                        DateTime date = timestamp.toDate();
                        String formattedDate =
                            DateFormat('dd MMMM yyyy').format(date);

                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailRecordPage(
                                  id: articles[index].id,patientName: patientName
                                ),
                              ),
                            );
                          },
                          leading: Container(
                            width: 120,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/Images/loading.gif', // Replace with your own loading gif
                              image: imageUrl,
                              fit: BoxFit.cover,
                              imageErrorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                // You can return any widget you want to display when the image fails to load
                                return const Text('Error loading image');
                                // ignore: dead_code
                                print('Image URL: $imageUrl');
                              },
                            ),
                          ),
                          title: Text(title),
                          subtitle: Text(
                              'Release date: $formattedDate'), // insert the name of the author who made the article
                        );
                      },
                    ),
                  );
                },
              ),
        ]),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
          // Displays a drawer header containing user profile information
            const UserProfileDrawerHeader(),

            // Menu Home
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreenBody()),
                );
              },
            ),

            // Menu Profile
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AccountPage()),
                );
              },
            ),

            // Menu Logout
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
