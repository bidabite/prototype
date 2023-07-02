import 'dart:ffi';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prototype/helper/helper_methods.dart';
import 'package:prototype/pages/profile_page.dart';

import '../components/announcement.dart';
import '../components/comment_view.dart';
import '../components/tag.dart';
import '../components/text_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDemand = true;

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

  void toggleDemand() {
    setState(() {
      isDemand = !isDemand;
    });
  }

  // navigate to profile page
  void goToProfilePage() {
    // go to profile page
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage())
    );
  }

  @override
  Widget build(BuildContext context) {

    TextEditingController _searchController = TextEditingController();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.noHeader,
            animType: AnimType.scale,
            btnCancelOnPress: () {
              setState(() {
                textController.clear();
              });
            },
            btnOkOnPress: () {
              postMessage();
            },
            body: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Make an announcement",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const MyTag(name: "Cleaning", color: Colors.blue),
                          const SizedBox(width: 5),
                          Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[300]!,
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.grey[600]!,
                              size: 15,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            isDemand = !isDemand;
                          });
                        },
                        child: MyTag(name: isDemand?"Demand":"Supply", color: isDemand?Colors.red:Colors.green)
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                          controller: textController,
                          hintText: "Write an announcement...",
                          obscureText: false,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ).show();
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF0052CC),
        mini: true
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
              child: Image.asset(
              'assets/2.png',
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, top: 25),
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
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  offset: const Offset(0, 3),
                                  blurRadius: 0,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(35)
                            ),
                            child: TextField(
                              controller: _searchController,
                              obscureText: false,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 15, top: 10, right: 10, bottom: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Search",
                                hintStyle: TextStyle(color: Colors.grey[600]!),
                                suffixIcon: const Icon(
                                  Icons.search,
                                  color: Color(0xFF0052CC),
                                )
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                offset: Offset(0, 3),
                                blurRadius: 0,
                              ),
                            ],
                            border: Border.all(
                              color: Colors.grey[300]!
                            )
                          ),
                          child: const Icon(
                            Icons.filter_list,
                            color: Color(0xFF0052CC),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // feed
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("User Posts").orderBy("Timestamp", descending: true).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              // get the message
                              final announcement = snapshot.data!.docs[index];
                              return GestureDetector(
                                onTap: () {
                                  ViewComment(context, announcement.id);
                                },
                                child: WallPost(
                                  message: announcement['Message'],
                                  user: announcement['UserEmail'],
                                  postId: announcement.id,
                                  likes: List<String>.from(announcement['Likes'] ?? []),
                                  time: formatData(announcement['Timestamp']),
                                ),
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
                  const SizedBox(height: 20)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
