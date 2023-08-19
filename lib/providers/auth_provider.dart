import 'package:auth_with_provider/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel _user = const UserModel(id: '', email: '', name: '', avatar: '');

  UserModel get user => _user;

  bool _loading = false;
  bool get loading => _loading;

  String _id = '';
  String get id => _id;

  String _email = '';
  String get email => _email;

  String _name = '';
  String get name => _name;

  String _avatar =
      'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png';
  String get avatar => _avatar;

  void setLoading(bool val) {
    _loading = val;
    notifyListeners();
  }

  void stopLoading() {
    _loading = false;
    notifyListeners();
  }

  Future<void> geUserDetails(User user) async {
    final DocumentSnapshot<Map<String, dynamic>> snap =
        await _firestore.collection('users').doc(user.uid).get();
    _user = UserModel.fromMap(snap);
  }

  Future<void> refreshUser() async {
    try {
      if (_auth.currentUser != null) {
        await geUserDetails(_auth.currentUser!);
        _user = user;
        _id = user.id;
        _email = user.email;
        _name = user.name;
        _avatar = user.avatar;
      }
    } catch (error) {
      Get.snackbar(
        'User Logged Out',
        'User is currently logged out',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
      );
    }
    notifyListeners();
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      setLoading(true);
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        User signedInUser = userCredential.user!;
        String id = signedInUser.uid;

        UserModel newUser = UserModel(
          id: id,
          email: email,
          name: name,
          avatar: avatar,
        );

        await _firestore
            .collection('users')
            .doc(id)
            .set(newUser.toMap(), SetOptions(merge: true));

        _user = newUser;
        notifyListeners();
        setLoading(false);
        return id;
      } else {
        setLoading(false);
        return 'Please fill all the fields';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'Invalid-email') {
        return 'The email provided is invalid.';
      }
    } catch (e) {
      setLoading(false);
      return e.toString();
    }

    return 'Something went wrong';
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Error occurred";
    try {
      setLoading(true);
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        if (_auth.currentUser != null) {
          await geUserDetails(_auth.currentUser!);
        }

        notifyListeners();
        res = 'success';
      } else {
        res = 'Please fill all the fields';
      }
      setLoading(false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
    } catch (e) {
      setLoading(false);
      return e.toString();
    }

    return res;
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
