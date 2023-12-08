import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'GameHome.dart';
import 'RegisterPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscureText = false;

  @override
  void initState() {
    // This method is called when the state object is created.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[300],
      appBar: AppBar(
        title: const Text(
          'Login Page',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Welcome Back !",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Image.asset("assets/tomato.png"),
              const SizedBox(
                height: 30,
              ),
              // Text field for entering email
              TextFormField(
                autofocus: false,
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                cursorColor: Colors.black,
                style: TextStyle(color: Colors.black.withOpacity(0.9)),
                decoration: InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
              // Text field for entering password
              TextFormField(
                obscureText: !_obscureText,
                autofocus: false,
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                cursorColor: Colors.black,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.9),
                ),
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off),
                  ),
                ),
              ),
              const SizedBox(height: 35),
              const SizedBox(width: 40),
              Row(
                children: [
                  const SizedBox(
                    width: 40,
                  ),
                  // Button to navigate to the registration page
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()));
                    },
                    child: const Text('Register'),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red.withOpacity(0.5),
                        elevation: 25,
                        shadowColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  const SizedBox(
                    width: 70,
                  ),
                  // Button to initiate the login process
                  ElevatedButton(
                    onPressed: () {
                      signIn();
                    },
                    child: const Text('Login'),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue.withOpacity(0.5),
                        elevation: 25,
                        shadowColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    // style: ElevatedButton.styleFrom(
                    //   primary: Colors.red, // Button background color
                    //   onPrimary: Colors.grey, // Text color
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(20),
                    //   ),
                    // ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to handle the sign-in process
  Future signIn() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      try {
        // Sign in with email and password using Firebase Authentication
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            )
            .then((value) => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => GameHome())));
        setState(() {});
      } on FirebaseAuthException catch (e) {
        // Handle Firebase Authentication exceptions
        print(e);
      }
    } else if (emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      // Show a snack bar if email or password is empty
      const SnackBar(
        content: Text(
          'Please enter your credentials',
          style: TextStyle(color: Colors.black),
        ),
      );
    }
  }
}
