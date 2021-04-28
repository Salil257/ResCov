import 'package:flutter/material.dart';
import './login_screen.dart';
import './profile.dart';
import '../../utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  final _email = TextEditingController();
  final _pass = TextEditingController();

  @override
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.only(bottom: 30),
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [orangeColors, orangeLightColors],
                      end: Alignment.bottomCenter,
                      begin: Alignment.topCenter),
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(100))),
              child: Stack(
                children: <Widget>[
                  Positioned(
                      bottom: 20,
                      right: 20,
                      child: Text(
                        "REGISTER",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                  Center(
                    child: Image.asset("assets/logo1.png"),
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Form(
                  key: _key,
                  autovalidate: _validate,
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.only(left: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (val!.isEmpty)
                                return "Please enter email";
                              else if (!val.contains("@"))
                                return "Please enter valid email";
                              else if (!val.toLowerCase().contains(".com"))
                                return "Please enter valid email";
                            },
                            controller: _email,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email",
                              prefixIcon: Icon(Icons.email),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.only(left: 10),
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "* Required";
                              } else if (value.length < 6) {
                                return "Password should be of atleast 6 characters";
                              }
                            },
                            obscureText: true,
                            controller: _pass,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              prefixIcon: Icon(Icons.vpn_key),
                            ),
                          ),
                        ),
                        Expanded(
                            child: Center(
                                child: InkWell(
                          onTap: () {
                            if (_key.currentState!.validate()) {
                              _key.currentState!.save();
                              _registerAccount(_email.text, _pass.text);

                              if (FirebaseAuth.instance.currentUser != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfilePage()),
                                );
                              }
                            } else {
                              setState(() {
                                _validate = true;
                              });
                            }
                          },
                          // Validate returns true if the form is valid, or false otherwise.

                          child: Container(
                            width: double.infinity,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [orangeColors, orangeLightColors],
                                  end: Alignment.centerLeft,
                                  begin: Alignment.centerRight),
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "REGISTER",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ))),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            },
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: "Already a member ? ",
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                    text: "Login",
                                    style: TextStyle(color: orangeColors)),
                              ]),
                            ))
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  _registerAccount(
    String email,
    String password,
  ) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      return Scaffold(
        body: Text('ERROR'),
      );
    }
  }
}
