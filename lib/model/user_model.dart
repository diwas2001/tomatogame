class UserModel {
  String? uid;
  String? name;
  String? email;
  String? password;

  UserModel({this.uid, this.name, this.email, this.password});
  //recceving data form the server
  factory UserModel.formMap(map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
    );
  }
  //sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
