import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rescov/screen/login/login_screen.dart';
import 'package:like_button/like_button.dart';

import './form/form_screen.dart';

import '../utils/color.dart';

import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Stream<QuerySnapshot>? _stream;

  @override
  void initState() {
    getdata();
  }

  getdata() async {
    _stream = FirebaseFirestore.instance.collection('resource').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        // <2> Pass `Stream<QuerySnapshot>` to stream
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // <3> Retrieve `List<DocumentSnapshot>` from snapshot
            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  iconTheme: IconThemeData(color: orangeLightColors),
                  backgroundColor: Colors.white,
                  centerTitle: true,
                  title: Text(
                    'Resources',
                    style: TextStyle(
                        color: orangeLightColors, fontWeight: FontWeight.bold),
                  ),
                  actions: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: GestureDetector(
                          onTap: () {},
                          // search action

                          child: Icon(
                            Icons.search,
                            size: 26.0,
                          ),
                        )),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    if (FirebaseAuth.instance.currentUser == null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FormScreen(),
                          ));
                    }
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  backgroundColor: orangeLightColors,
                ),
                body: Center(
                  child: Container(
                    child: ListView(
                        children: documents.map((doc) {
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(doc['resource']),
                            SizedBox(height: 8.0),
                            Text(doc['contact']),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  LikeButton(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList()),
                  ),
                ));
          }
          return Scaffold(
              body: Container(
                  child: Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(orangeColors)))));
        });
  }
}
