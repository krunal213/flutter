// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.token,
  });

  String token;

  factory User.fromJson(Map<String, dynamic> json) => User(
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
  };
}
