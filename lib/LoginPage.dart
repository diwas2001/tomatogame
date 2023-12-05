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
    // TODO: implement initState
    super.initState();
  }

  /* void dispose(){
    emailController.dispose();
    passwordController.dispose();

  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent[300],
      appBar: AppBar(
        title: const Text(
          'Login Page',
          style: TextStyle(color: Colors.black),
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
              TextFormField(
                autofocus: false,
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                cursorColor: Colors.black,
                style: TextStyle(color: Colors.black.withOpacity(0.9)),
                decoration: InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
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
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()));
                      // Implement your authentication logic here
                    },
                    child: const Text('Register'),
                  ),
                  const SizedBox(
                    width: 70,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      signIn();
                      // Implement your authentication logic here
                    },
                    //login button
                    child: const Text('Login'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future signIn() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            )
            .then((value) => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => GameHome())));
        setState(() {});
      } on FirebaseAuthException catch (e) {
        print(e);
      }
    } else if (emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      const SnackBar(
        content: Text(
          'Please enter your credentials',
          style: TextStyle(color: Colors.black),
        ),
      );
    }
  }
}
