import 'dart:async';
import 'dart:developer';

import 'package:auth_with_provider/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> _userFromFirebase(User? user) async {
    if (user == null) {
      return null;
    }

    try {
      final snapshot = await _firestore.collection('users').doc(user.uid).get();
      if (snapshot.exists) {
        final userData = snapshot.data();
        if (userData != null) {
          return UserModel(
            id: user.uid,
            email: user.email!,
            name: userData['name'],
            avatar: userData['avatar'],
          );
        }
      }
    } catch (e) {
      log('Error getting user data: $e');
    }
    return null;
  }

  Stream<UserModel?> get user {
    return _firebaseAuth.authStateChanges().asyncMap(_userFromFirebase);
  }

  Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        final id = userCredential.user!.uid;

        final snapshot = await _firestore.collection('users').doc(id).get();
        if (snapshot.exists) {
          final userData = snapshot.data();
          if (userData != null) {
            return UserModel(
              id: id,
              email: email,
              name: userData['name'],
              avatar: userData['avatar'],
            );
          }
        }
        await _firestore.collection('users').doc(id).set({
          'email': email,
          'password': password,
        });
      }
    } catch (e) {
      log('Error signing in: $e');
    }
    return null;
  }

  Future<UserModel?> createUserWithEmailAndPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        final UserCredential userCredential =
            await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        UserModel user = UserModel(
            id: userCredential.user!.uid,
            email: email,
            name: name,
            avatar:
                'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png');

        await _firestore.collection('users').doc(user.id).set(user.toMap());

        return user;
      }
    } catch (e) {
      log('Error creating user with email and password: $e');
    }

    return null;
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      log('Error signing out: $e');
    }
  }
}
