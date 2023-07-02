import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prototype/components/comment_button.dart';
import 'package:prototype/components/tag.dart';
import 'package:prototype/components/up_button.dart';
import 'package:prototype/components/comment.dart';

import '../helper/helper_methods.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;
  final String time;
  const WallPost({Key? key, required this.message, required this.user, required this.postId, required this.likes, required this.time}) : super(key: key);

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {

  // user
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  // comment text controller
  final _commentTextController = TextEditingController();


  @override
  void inistState() {
    super.initState();
    setState(() {
      isLiked = widget.likes.contains(currentUser.email);
    });
  }

  // toggle like
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    // Access the document in Firebase
    DocumentReference postRef = FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isLiked) {
      // if the post is now liked, add the user's email to the 'Likes' field
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      // if the post is now unliked, remove the user's email from the 'Likes' field
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1.0
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            offset: const Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // announcement
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // user picture
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .doc(widget.user)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text(
                        "",
                        style: TextStyle(color: Colors.grey),
                      );
                    }
                    String image = snapshot.data!.get('image');
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 150,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0052CC),
                        ),
                        child: Image.network(
                          image, // Replace with the URL of your network image
                          fit: BoxFit.cover, // Adjust the fit as needed
                        ),
                      ),
                    );
                  }
              ),

              // tags
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        MyTag(name: "Food", color: Colors.lightGreen),
                        SizedBox(width: 5),
                        MyTag(name: "Catering", color: Colors.orange),
                      ],
                    ),
                    MyTag(name: "Demand", color: Colors.red),
                  ],
                ),
              ),

              SizedBox(height: 5),

              // message
              Text(
                widget.message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w800
                )
              ),

              const SizedBox(height: 5),
              // user
              Row(
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Users")
                          .doc(widget.user)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Text(
                            "",
                            style: TextStyle(color: Colors.grey),
                          );
                        }
                        String name = snapshot.data!.get('username');
                        return Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      }
                  ),
                ],
              ),

              const SizedBox(height: 5),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "500+ connections",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0858CE)
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(widget.time, style: TextStyle(color: Colors.grey[500]))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      // up button
                      LikeButton(isLiked: isLiked, onTap: toggleLike),

                      const SizedBox(height: 5),

                      // up count
                      Text(
                        widget.likes.length.toString(),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      CommentButton(),
                      // comment count
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("User Posts")
                            .doc(widget.postId)
                            .collection("Comments")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Text(
                              "",
                              style: TextStyle(color: Colors.grey),
                            );
                          }
                          return Text(
                            snapshot.data!.docs.length.toString(),
                            style: TextStyle(color: Colors.grey),
                          );
                        }
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
