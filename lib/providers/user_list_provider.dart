import 'package:auth_with_provider/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsersListProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<UserModel> _users = [];

  List<UserModel> get users => _users;

  Stream<List<UserModel>> get usersStream {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => UserModel.fromMap(doc)).toList();
    });
  }

  Future<void> refreshUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      _users.clear();
      _users.addAll(snapshot.docs.map((doc) => UserModel.fromMap(doc)));
      notifyListeners();
    } catch (error) {
      debugPrint('Error getting users: $error');
    }
  }
}
