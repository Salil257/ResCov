import 'package:flutter/material.dart';
import '../../utils/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home_screen.dart';
import '../login/login_screen.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _phone = TextEditingController();
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _gstin = TextEditingController();
  final _companyName = TextEditingController();
  final _pin = TextEditingController();
  String? _role = null;

  @override
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: orangeLightColors,
        body: Container(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
              Container(
                  padding: EdgeInsets.only(top: 30),
                  child: Center(child: Image.asset("assets/logo1.png"))),
              SizedBox(
                height: 30,
              ),
              Hero(
                tag: 'Proile',
                child: Text(
                  "PROFILE",
                  style: TextStyle(
                    fontFamily: 'TitilliumWeb',
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.only(left: 10),
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "* Required";
                                }
                              },
                              controller: _name,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Full Name",
                                prefixIcon: Icon(Icons.person),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.only(left: 10),
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "* Required";
                                }
                              },
                              controller: _phone,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Phone Number",
                                prefixIcon: Icon(Icons.phone),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: _textInput(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "* Required";
                                  }
                                },
                                hint: "Company Name",
                                icon: Icons.business_center,
                                controller: _companyName),
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
                                icon: Icons.domain_outlined,
                                controller: _address),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: _textInput(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "* Required";
                                  } else if (value.length != 6) {
                                    return "Pin should be of 6 characters";
                                  }
                                },
                                hint: "Pincode",
                                icon: Icons.location_on,
                                controller: _pin),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: _textInput(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "* Required";
                                  }
                                },
                                hint: "GSTIN Number",
                                icon: Icons.local_play_outlined,
                                controller: _gstin),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Colors.white,
                            ),
                            child: DropdownButtonFormField(
                              icon: Icon(Icons.arrow_drop_down_circle_outlined),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(left: 20, right: 20),
                                border: InputBorder.none,
                              ),
                              value: _role,
                              elevation: 5,
                              style: TextStyle(color: Colors.black),
                              items: <String>[
                                'Manufacturer',
                                'Supplier',
                                'Shipper',
                                'Wholesaler',
                                'Retailer',
                                'Other',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                  },
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              hint: Text(
                                "Please choose your role in supplychain",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              onChanged: (String? value) {
                                setState(() {
                                  _role = value;
                                });
                              },
                            ),
                          ),
                          Expanded(
                              child: Center(
                                  child: InkWell(
                            onTap: () {
                              if (_key.currentState!.validate()) {
                                _key.currentState!.save();
                                _addpackage(
                                    _name.text,
                                    _phone.text,
                                    _address.text,
                                    _gstin.text,
                                    _role.toString(),
                                    _companyName.text,
                                    _pin.text);

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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                  );
                                });
                              }
                            },

                            // Validate Profile details and add to database
                            // Redirect to HomePage
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              width: double.infinity,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "SUBMIT",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: orangeColors,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ))),
                        ],
                      ),
                    ),
                  ))
            ])));
  }

  Future<void>? _addpackage(String _name, String _phone, String _address,
      String _gstin, String _pin, String _role, String _companyName) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'Name': _name,
      'Phone': _phone,
      'Company Name': _companyName,
      'Pin': _pin,
      'GSTIN': _gstin,
      'Address': _address,
      'Role': _role
    });
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
