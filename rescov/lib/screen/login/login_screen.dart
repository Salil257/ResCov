import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../home_screen.dart';
import '.././login/forgot_password.dart';
import '.././login/registration_screen.dart';
import '../../utils/color.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    _firebase();
  }

  Future<void> _firebase() async {
    await Firebase.initializeApp();
  }

  @override
  final _email = TextEditingController();
  final _pass = TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;

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
                            "LOGIN",
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
                            autovalidate: _validate,
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
                        ),

                        Container(
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.only(left: 10),
                          child: TextFormField(
                            autovalidate: _validate,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "* Required";
                              } else if (value.length < 6) {
                                return "Password should be atleast 6 characters";
                              } else
                                return null;
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

                        Container(
                            margin: EdgeInsets.only(top: 10),
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgotPassword()),
                                );
                              },
                              child: Text(
                                "Forgot Password?",
                              ),
                            )),

                        Expanded(
                            child: Center(
                                child: InkWell(
                          onTap: () {
                            if (_key.currentState!.validate()) {
                              _key.currentState!.save();
                              signInWithEmailAndPassword(
                                  _email.text, _pass.text);
                              if (FirebaseAuth.instance.currentUser != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()),
                                );
                              }
                            } else {
                              setState(() {
                                _validate = true;
                              });
                            }
                            // Validate returns true if the form is valid, or false otherwise.
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
                              "LOGIN",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ))),

                        // Bottom Text
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegistrationPage()),
                              );
                            },
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: "New to Syzygy ? ",
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                    text: "Register",
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
        ));
  }
}

signInWithEmailAndPassword(
  String email,
  String password,
) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  } on FirebaseAuthException catch (e) {
    return Scaffold(
        body: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(orangeColors)));
  }
}
