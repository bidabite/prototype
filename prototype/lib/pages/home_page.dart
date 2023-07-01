import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prototype/components/drawer.dart';
import 'package:prototype/components/text_field.dart';
import 'package:prototype/helper/helper_methods.dart';
import 'package:prototype/pages/profile_page.dart';

import '../components/announcement.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  // text controller
  final textController = TextEditingController();

  // sign user out
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  // post announcement
  void postMessage() {
    // only post if there is something in the textfield
    if (textController.text.isNotEmpty) {
      // store in firebase
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'Timestamp': Timestamp.now(),
        'Likes': []
        }
      );
    }

    // clear the textfield
    setState(() {
      textController.clear();
    });
  }

  // navigate to profile page
  void goToProfilePage() {
    // pop menu drawer
    Navigator.pop(context);

    // go to profile page
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage())
    );
  }

  @override
  Widget build(BuildContext context) {

    TextEditingController _searchController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF0052CC),
        elevation: 0,
        title: const Text("E N D E M A N D"),
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
      ),
      body: Stack(
        children: [
          Positioned(
            top: -25,
              child: Image.asset(
              'assets/2.png',
            ),
          ),
          Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 25),
                      child: Text(
                        "CONNECT",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 40,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 20),
                  child: TextField(
                    controller: _searchController,
                    obscureText: false,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 15, top: 10, right: 10, bottom: 10),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF0052CC)),
                            borderRadius: BorderRadius.circular(35)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(35)
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Search",
                        suffixIcon: Icon(Icons.search),
                        suffixIconColor: Color(0xFF0052CC),
                        hintStyle: TextStyle(color: Colors.grey[600]!)
                    ),
                  ),
                ),

                // feed
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("User Posts").orderBy("Timestamp", descending: false).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            // get the message
                            final announcement = snapshot.data!.docs[index];
                            return WallPost(
                              message: announcement['Message'],
                              user: announcement['UserEmail'],
                              postId: announcement.id,
                              likes: List<String>.from(announcement['Likes'] ?? []),
                              time: formatData(announcement['Timestamp']),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),

                // // post announcement
                // Padding(
                //   padding: const EdgeInsets.all(25.0),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: MyTextField(
                //           controller: textController,
                //           hintText: "Write an announcement...",
                //           obscureText: false,
                //         ),
                //       ),
                //
                //       // post button
                //       IconButton(onPressed: postMessage, icon: const Icon(Icons.arrow_circle_up))
                //     ],
                //   ),
                // ),

                // logged in as
                Text(
                  "Logged in as: ${currentUser.email!}",
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 50)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
