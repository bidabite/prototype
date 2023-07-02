import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prototype/components/text_field.dart';
import 'package:prototype/components/comment.dart';

import '../helper/helper_methods.dart';
import '../pages/visit_profile.dart';

// add a comment
void addComment(String commentText, String postId) {
  final currentUser = FirebaseAuth.instance.currentUser!;
  FirebaseFirestore.instance
      .collection("User Posts")
      .doc(postId)
      .collection("Comments")
      .add({
    "CommentText": commentText,
    "CommentedBy": currentUser.email,
    "CommentTime": Timestamp.now()
  });
}

void ViewComment(BuildContext context, String announcement) {
  TextEditingController _myController = TextEditingController();
  AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      btnCancelOnPress: () {
      },
      btnOkOnPress: () {
        addComment(_myController.text, announcement);
      },
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('User Posts')
                  .doc(announcement)
                  .get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Data is still loading
                  return Text('');
                }
                if (snapshot.hasError) {
                  // Error occurred while fetching data
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  // No data found
                  return Text('No data found');
                }
                // Data retrieved successfully
                final data = snapshot.data!.data() as Map<String, dynamic>;
                // Access the fields of the document
                final post = data['Message'] as String;
                final email = data['UserEmail'] as String;
                final time = formatData(data['Timestamp']);

                return Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("Users")
                              .doc(email)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Text(
                                "",
                                style: TextStyle(color: Colors.grey),
                              );
                            }
                            final link = snapshot.data!.get('image');
                            final username = snapshot.data!.get('username');
                            final about = snapshot.data!.get('bio');
                            return  GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => VisitPage(image: link, bio: about, name: username,)));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: ClipOval(
                                        child: Image.network(
                                          link,
                                          fit: BoxFit.cover,
                                        )
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        username,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                            color: Colors.grey[600]
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        time,
                                        style: TextStyle(
                                          color: Colors.grey[600]
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          }
                      ),
                      const SizedBox(height: 10),
                      Text(post, maxLines: 10),
                    ],
                  ),
                );
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("User Posts")
                  .doc(announcement)
                  .collection("Comments")
                  .orderBy("CommentTime", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                // show loading circle if no data yet
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator()
                  );
                }
                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: snapshot.data!.docs.map((doc) {
                    // get the comment
                    final commentData = doc.data() as Map<String, dynamic>;

                    return Comment(
                      text: commentData["CommentText"],
                      user: commentData["CommentedBy"],
                      time: formatData(commentData["CommentTime"])
                    );
                  }).toList(),
                );
              }
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                    controller: _myController,
                    hintText: "Write a comment",
                    obscureText: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      )
  ).show();
}