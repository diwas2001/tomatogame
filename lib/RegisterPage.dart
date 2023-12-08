import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tomotogame/LoginPage.dart';

import 'model/user_model.dart';

/// Entry point of the application.
void main() => runApp(const MyApp());

/// The main application widget for the registration page.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration Page',
      theme: ThemeData(
        primaryColor: Colors.grey,
      ),
      home: const RegisterPage(),
    );
  }
}

/// Widget representing the registration page.
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

/// State class for the RegisterPage widget.
class _RegisterPageState extends State<RegisterPage> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.blueGrey, // App Bar background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                validator: (value) {
                  RegExp regex = RegExp(r'^.{3,}$');
                  if (value!.isEmpty) {
                    return ("Username cannot be empty");
                  }
                  if (!regex.hasMatch(value)) {
                    return ("Enter a valid username (Min. 3 characters)");
                  }
                  return null;
                },
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  RegExp regex = RegExp(r'^.{3,}$');
                  if (value!.isEmpty) {
                    return ("Email cannot be empty");
                  }
                  if (!regex.hasMatch(value)) {
                    return ("Enter a valid email address");
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                validator: (value) {
                  RegExp regex = RegExp(r'^.{3,}$');
                  if (value!.isEmpty) {
                    return ("Password cannot be empty");
                  }
                  if (!regex.hasMatch(value)) {
                    return ("Enter a valid password (Min. 3 characters)");
                  }
                  return null;
                },
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                validator: (value) {
                  RegExp regex = RegExp(r'^.{3,}$');
                  if (value!.isEmpty) {
                    return ("Confirm Password cannot be empty");
                  }
                  if (!regex.hasMatch(value)) {
                    return ("Enter a valid password (Min. 3 characters)");
                  }
                  return null;
                },
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Validate input and process registration logic here
                  String name = _nameController.text;
                  String email = _emailController.text;
                  String password = _passwordController.text;
                  String confirmPassword = _confirmPasswordController.text;

                  if (password == confirmPassword) {
                    // Registration logic here
                    register(name, email, password);
                  } else {
                    // Passwords do not match
                    print('Passwords do not match');
                  }
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.blue.withOpacity(0.5),
                    elevation: 25,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Function to handle user registration.
  Future<void> register(String name, String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                postDetailsToFirestore(),
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  /// Function to post user details to Firestore after successful registration.
  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();
    userModel.uid = user!.uid;
    userModel.name = _nameController.text;
    userModel.email = _emailController.text;
    userModel.password = _passwordController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.pushAndRemoveUntil((context),
        MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
  }
}
