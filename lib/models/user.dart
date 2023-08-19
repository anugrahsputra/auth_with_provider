import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String avatar;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
  });

  @override
  List<Object?> get props => [id, name, email, avatar];

  factory UserModel.fromMap(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return UserModel(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      avatar: data['avatar'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(
      json.decode(source) as DocumentSnapshot<Map<String, dynamic>>);
}
