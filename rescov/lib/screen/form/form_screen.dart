import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/color.dart';

import '../home_screen.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _name = TextEditingController();
  final _contact = TextEditingController();
  final _address = TextEditingController(); //address to price
  final _resourceName = TextEditingController();
  final _remark = TextEditingController(); // quantity
  //  remarks

  Future<void>? addpackage(_name, _contact, _address, _resourceName, _remark) {
    FirebaseFirestore.instance.collection('resource').doc().set({
      'remark': _remark,
      'firmName': _name,
      'contact': _contact,
      'address': _address,
      'resource': _resourceName,
    });
  }

  @override
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: orangeLightColors),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'New Contact',
            style: TextStyle(
                color: orangeLightColors, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  // search action

                  child: Icon(
                    Icons.close,
                    size: 26.0,
                  ),
                )),
          ],
        ),
        body: Form(
            key: _key,
            autovalidate: _validate,
            child: Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                child:
                    Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: _textInput(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "* Required";
                          }
                        },
                        hint: "Resource Name",
                        icon: Icons.medical_services,
                        controller: _resourceName),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      child: _textInput(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "* Required";
                          }
                        },
                        hint: "Address",
                        icon: Icons.label_important,
                        controller: _address,
                      )),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: _textInput(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "* Required";
                          }
                        },
                        hint: "Contact",
                        icon: Icons.monetization_on,
                        controller: _contact),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: _textInput(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "* Required";
                          }
                        },
                        hint: "Firm Name",
                        icon: Icons.shopping_cart,
                        controller: _name),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.only(left: 10),
                      child: TextFormField(
                        maxLines: 10,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Remarks",
                        ),
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 30),
                      child: FlatButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Confirmation"),
                                  content:
                                      Text("Are you sure you want to submit ?"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(
                                        'No',
                                        style:
                                            TextStyle(color: orangeLightColors),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        'Yes',
                                        style:
                                            TextStyle(color: orangeLightColors),
                                      ),
                                      onPressed: () {
                                        if (_key.currentState!.validate()) {
                                          _key.currentState!.save();

                                          addpackage(
                                              _name.text,
                                              _contact.text,
                                              _address.text,
                                              _resourceName.text,
                                              _remark.text);

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeScreen()),
                                          );
                                        } else {
                                          setState(() {
                                            _validate = true;
                                            Navigator.of(context).pop();
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        ),
                        color: orangeLightColors,
                        minWidth: 150,
                        height: 45,
                      ))
                ]))));
  }
}

Widget _textInput({controller, hint, icon, validator}) {
  return Container(
    margin: EdgeInsets.only(top: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      color: Colors.white,
    ),
    padding: EdgeInsets.only(left: 10),
    child: TextFormField(
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
    ),
  );
}
