/// Class representing a user model.
class UserModel {
  String? uid;
  String? name;
  String? email;
  String? password;

  /// Constructor for the UserModel class.
  UserModel({this.uid, this.name, this.email, this.password});

  /// Factory method to create a UserModel instance from a map of data received from the server.
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
    );
  }

  /// Method to convert the UserModel instance to a map for sending data to the server.
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
