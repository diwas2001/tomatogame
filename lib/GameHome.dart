import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'LoginPage.dart';

/// Widget representing the main game screen.
class GameHome extends StatefulWidget {
  const GameHome({Key? key}) : super(key: key);

  @override
  State<GameHome> createState() => _GameHomeState();
}

/// Private state class for the GameHome widget.
class _GameHomeState extends State<GameHome> {
  int score = 0; // Initialize the score
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              // Function to logout when the logout button is pressed
              await _logout(context);
            },
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.red,
            ),
          )
        ],
        elevation: 0,
        backgroundColor: Colors.blueGrey,
        title: const Text(
          "Tomato Game",
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                fit: StackFit.loose,
                clipBehavior: Clip.hardEdge,
                children: [
                  // Display the current score
                  Text(
                    "Score : $score",
                    style:
                        TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                  ),
                  // Display an image asset for the score
                  Image.asset(
                    'assets/score.png',
                    width: 200,
                    height: 150,
                  ),
                ],
              ),
              // Use FutureBuilder to fetch and display game data from an API
              FutureBuilder<GameData>(
                future: fetchGameDataFromAPI(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text("No data available."));
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          fit: StackFit.passthrough,
                          clipBehavior: Clip.hardEdge,
                          children: [
                            // Display an image frame
                            Image.asset(
                              'assets/frame.png',
                            ),
                            // Display the question image fetched from the API
                            Image.network(
                              snapshot.data!.imageUrl,
                              width: 240,
                              errorBuilder: (context, error, stackTrace) {
                                // Handle image loading errors
                                return Column(
                                  children: [
                                    Text("Failed to load the image."),
                                    Text("Error: ${error.toString()}"),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      // Text field for user's answer
                      TextFormField(
                        controller: answerController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Enter your answer',
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      // Button to check the user's answer
                      ElevatedButton(
                        onPressed: () {
                          // Check the user's answer
                          checkAnswer(snapshot.data!.solution);
                        },
                        child: const Text('Check Answer'),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green.withOpacity(0.5),
                            elevation: 25,
                            shadowColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Function to handle user logout
  Future<void> _logout(BuildContext context) async {
    try {
      // Sign out the current user
      await _auth.signOut();

      // Navigate to the login screen or any other screen you prefer
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    } catch (e) {
      // Handle any errors that might occur during logout
      print('Error during logout: $e');
    }
  }

  /// Function to fetch game data from an API
  Future<GameData> fetchGameDataFromAPI() async {
    final response = await http.get(
      Uri.parse('https://marcconrad.com/uob/tomato/api.php?out=json'),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      GameData gameData = createGameData(responseJson);
      print(gameData.solution);
      return gameData;
    } else {
      // Throw an exception if data loading fails
      throw Exception('Failed to load data from the API');
    }
  }

  /// Function to create GameData object from API response
  GameData createGameData(Map<String, dynamic> data) {
    String imageUrl = data["question"];
    String solution = data["solution"].toString();
    return GameData(
      imageUrl: imageUrl,
      solution: solution,
    );
  }

  /// Function to check the user's answer
  void checkAnswer(String correctAnswer) {
    String userAnswer = answerController.text.trim();
    if (userAnswer.toLowerCase() == correctAnswer.toLowerCase()) {
      // User's answer is correct
      Fluttertoast.showToast(
        msg: "Correct Answer",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print('Correct Answer!');
      setState(() {
        score++;
        // Fetch new game data after correct answer
        fetchGameDataFromAPI();
        answerController.clear();
      });
    } else {
      // User's answer is incorrect
      Fluttertoast.showToast(
        msg: "Incorrect Answer",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print('Incorrect Answer!');
    }
  }
}

/// Class to represent game data (question image URL and correct answer)
class GameData {
  final String imageUrl;
  final String solution;

  GameData({required this.imageUrl, required this.solution});
}
