import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prototype/components/text_field.dart';
import 'package:prototype/components/comment.dart';

import '../helper/helper_methods.dart';

void ViewComment(BuildContext context,String announcement) {
  TextEditingController _myController = TextEditingController();
  AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      btnCancelOnPress: () {
      },
      btnOkOnPress: () {
      },
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
}