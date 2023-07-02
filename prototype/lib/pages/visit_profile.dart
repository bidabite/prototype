import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prototype/components/buttons.dart';

class VisitPage extends StatelessWidget {
  final String image;
  final String bio;
  final String name;
  const VisitPage({super.key, required this.image, required this.bio, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF0052CC),
        onPressed: () {  },
        child: Icon(Icons.message, color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            toolbarHeight: 70,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(300),
              child: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
                  child: Text(
                    name,
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900), maxLines: 2, overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            pinned: true,
            backgroundColor: Color(0xFF0052CC),
            expandedHeight: 540,
            collapsedHeight: kToolbarHeight+54,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                width: double.maxFinite,
                color: Colors.white,
                child: Image.network(
                  "https://firebasestorage.googleapis.com/v0/b/enstacksolution.appspot.com/o/Mang%20Larry's%20Isawan%20UP.jpg?alt=media&token=149ac842-94df-4849-80aa-4633f9f1a01a",
                  fit: BoxFit.cover,
                )
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.place, color: Color(0xFF0052CC), size: 15,),
                      SizedBox(width: 5),
                      Text("Diliman, Quezon City")
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.phone, color: Color(0xFF0052CC), size: 15),
                          SizedBox(width: 5),
                          Text("0945 836 5250")
                        ],
                      ),
                      SizedBox(width: 15),
                      Row(
                        children: [
                          Icon(Icons.email, color: Color(0xFF0052CC), size: 15),
                          SizedBox(width: 5),
                          Text("manglarry@gmail.com")
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                            color: const Color(0xFF0052CC),
                            borderRadius: BorderRadius.circular(25)
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              Icon(Icons.add, color: Colors.white,),
                              SizedBox(width: 10),
                              Text(
                                "Connect",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Text("500+ connections", style: TextStyle(color: Color(0xFF0052CC), fontWeight: FontWeight.w700, fontSize: 15),)
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(thickness: 1.5),
                  const SizedBox(height: 10),
                  Text(
                    "About",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 23
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
