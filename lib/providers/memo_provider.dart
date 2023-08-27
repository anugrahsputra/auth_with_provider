import 'package:auth_with_provider/models/memo/memo.dart';
import 'package:auth_with_provider/service/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class MemoProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirestoreService _firestoreService = FirestoreService();
  var uuid = const Uuid().v4();

  final List<Memo> _memos = [];

  List<Memo> get memos => _memos;

  final Memo _memo = Memo(
    id: '',
    title: '',
    content: '',
    userId: '',
    userName: '',
    userAvatar: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  Memo get memo => _memo;

  final String _id = '';
  final String _title = '';
  final String _content = '';
  final String _userId = '';
  final String _userName = '';
  final String _userAvatar = '';
  final DateTime _createdAt = DateTime.now();
  final DateTime _updatedAt = DateTime.now();

  String get id => _id;
  String get title => _title;
  String get content => _content;
  String get userId => _userId;
  String get userName => _userName;
  String get userAvatar => _userAvatar;
  DateTime get createdAt => _createdAt;
  DateTime get updatedAt => _updatedAt;

  Future<void> createMemo(
      {required String userid,
      required String userName,
      required String userAvatar,
      required String title,
      required String content}) async {
    try {
      Memo memo = Memo(
        id: uuid,
        title: title,
        content: content,
        userId: userid,
        userName: userName,
        userAvatar: userAvatar,
        createdAt: _createdAt,
        updatedAt: _updatedAt,
      );
      await _firestoreService.createMemo(memo, userid);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Stream<List<Memo>> getMemo(String id) {
    try {
      return _firestoreService.getMemo(id);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> refreshMemo(String id) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(id)
          .collection('memos')
          .get();
      _memos.clear();
      _memos.addAll(snapshot.docs.map((doc) => Memo.fromJson(doc)));
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
