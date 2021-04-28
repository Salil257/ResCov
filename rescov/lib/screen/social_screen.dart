import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rescov/screen/login/login_screen.dart';
import 'package:like_button/like_button.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import './form/social_form.dart';

import '../utils/color.dart';

import 'package:flutter/services.dart';

class SocialScreen extends StatefulWidget {
  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  Stream<QuerySnapshot>? _stream;

  @override
  void initState() {
    getdata();
  }

  getdata() async {
    _stream = FirebaseFirestore.instance.collection('sociallink').snapshots();
  }

  WebViewPlusController? _controller;
  final _link = TextEditingController();
  double _height = 600;
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
                    'User Need',
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FormsScreen(),
                        ));
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
                      return SizedBox(
                        height: _height,
                        child: WebViewPlus(
                          javascriptChannels: null,
                          initialUrl: doc['link'],
                          onWebViewCreated: (controller) {},
                          onPageFinished: (url) {
                            _controller?.getHeight().then((double height) {
                              print("Height: " + height.toString());
                              setState(() {
                                _height = height;
                              });
                            });
                          },
                          javascriptMode: JavascriptMode.unrestricted,
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
