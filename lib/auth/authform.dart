import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: unnecessary_import
import 'package:flutter/services.dart';

class AuthForm extends StatefulWidget {
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  bool isLoginPage = false;

  startauthentication() async {
    final validity = _formkey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (validity) {
      _formkey.currentState.save();
      submitForm(_email, _password, _username);
    }
  }

  submitForm(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    UserCredential authResult;
    try {
      if (isLoginPage) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String uid = authResult.user.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({'username': username, 'email': email});
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(30),
            height: 200,
            child: Image.asset('assets/todo.png'),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isLoginPage)
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Incorrect Username';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                              borderSide: new BorderSide()),
                          labelText: "Enter username",
                          labelStyle: GoogleFonts.roboto()),
                    ),
                  SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Incorrect Email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                            borderSide: new BorderSide()),
                        labelText: "Enter Email",
                        labelStyle: GoogleFonts.roboto()),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Incorrect pasword';
                      } else if (value.length < 6) {
                        return 'Minmum 6 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                            borderSide: new BorderSide()),
                        labelText: "Enter Password",
                        labelStyle: GoogleFonts.roboto()),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    height: 60,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: ElevatedButton(
                        child: isLoginPage
                            ? Text(
                                'Login',
                                style: GoogleFonts.roboto(fontSize: 16),
                              )
                            : Text(
                                'SignUp',
                                style: GoogleFonts.roboto(fontSize: 16),
                              ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor),
                        onPressed: () {
                          startauthentication();
                        }),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isLoginPage = !isLoginPage;
                        });
                      },
                      child: isLoginPage
                          ? Text(
                              'Not a User?',
                              style: GoogleFonts.roboto(
                                  fontSize: 16, color: Colors.blue),
                            )
                          : Text(
                              'Already a User?',
                              style: GoogleFonts.roboto(
                                  fontSize: 16, color: Colors.blue),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
