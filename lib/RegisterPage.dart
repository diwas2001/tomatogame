import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tomotogame/LoginPage.dart';

import 'model/user_model.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration Page',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
          validator: (value) {
            RegExp regex = new RegExp(r'^.{3,}$');
            if (value!.isEmpty) {
            return ("username cannot be Empty");
          }
           if (!regex.hasMatch(value)) {
            return ("Enter Valid username(Min. 3 Character)");
          }
          return null;
          },
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    RegExp regex = new RegExp(r'^.{3,}$');
                    if (value!.isEmpty) {
                      return ("username cannot be Empty");
                    }
                    if (!regex.hasMatch(value)) {
                      return ("Enter Valid username(Min. 3 Character)");
                    }
                    return null;
                  },
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12.0),
              TextFormField(
              validator: (value) {
              RegExp regex = new RegExp(r'^.{3,}$');
              if (value!.isEmpty) {
              return ("username cannot be Empty");
              }
              if (!regex.hasMatch(value)) {
              return ("Enter Valid username(Min. 3 Character)");
              }
              return null;
              },
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12.0),
              TextFormField(
                validator: (value) {
                  RegExp regex = new RegExp(r'^.{3,}$');
                  if (value!.isEmpty) {
                    return ("username cannot be Empty");
                  }
                  if (!regex.hasMatch(value)) {
                    return ("Enter Valid username(Min. 3 Character)");
                  }
                  return null;
                },
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Validate input and process registration logic here
                  String name = _nameController.text;
                  String email = _emailController.text;
                  String password = _passwordController.text;
                  String confirmPassword = _confirmPasswordController.text;

                  if (password == confirmPassword) {
                    // Registration logic here
                    Register(name, email, password);
                    // You can add your authentication logic or API calls here
                    //print('Registration successful: Name - $name, Email - $email, Password - $password');
                  } else {
                    // Passwords do not match
                    print('Passwords do not match');
                  }

                },

                child: Text('Register'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Background color
                  onPrimary: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> Register(String name, String email,String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth.createUserWithEmailAndPassword(email: email, password: password)
       .then((value) => {
         postDetailsToFirestore(),
       }).catchError((e)
       {
         Fluttertoast.showToast(msg: e!.message);
       });

    }
  }
  postDetailsToFirestore()async {
    //calling our firestore
    //calling our user model
    //sending these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();
    //writing all the values
    userModel.uid = user!.uid;
    userModel.name = _nameController.text;
    userModel.email= _emailController.text;
    userModel.password = _passwordController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.pushAndRemoveUntil(
    (context),
    MaterialPageRoute(builder: (context) => LoginPage()),(route) => false);

  }
}
