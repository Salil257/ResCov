import 'package:flutter/material.dart';
import './login_screen.dart';
import '../../utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;

  final _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false, // set it to false
        body: Container(
          padding: EdgeInsets.only(bottom: 30),
          child: Container(
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
                            "Forgot Password",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                      Center(
                        child: Image.asset("assets/logo1.png"),
                      ),
                    ],
                  ),
                ),
                //header container

                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Form(
                            key: _key,
                            autovalidate: _validate,
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.only(left: 10),
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                validator: (val) {
                                  if (val!.length == 0)
                                    return "Please enter email";
                                  else if (!val.contains("@"))
                                    return "Please enter valid email";
                                  else if (!val.toLowerCase().contains(".com"))
                                    return "Please enter valid email";
                                  else
                                    return null;
                                },
                                controller: _email,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Email",
                                  prefixIcon: Icon(Icons.email),
                                ),
                              ),
                            )),

                        Expanded(
                            child: Center(
                                child: InkWell(
                          onTap: () {
                            if (_key.currentState!.validate()) {
                              _key.currentState!.save();
                              sendPasswordResetEmail(_email.text);
                              SnackBar(
                                  content: Text(
                                      'you have been sent an email of password reset'));
                              waittonaviagte();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            } else {
                              setState(() {
                                _validate = true;
                              });
                            }
                            // Forgot password action
                            // if email not registerd error
                          },
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
                              "Confirm",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ))),

                        // Bottom Text
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Future sendPasswordResetEmail(String email) async {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  waittonaviagte() {
    Future.delayed(Duration(seconds: 1));
    SnackBar(content: Text('Sending to login Page'));
  }
}
