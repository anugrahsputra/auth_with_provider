import 'package:auth_with_provider/models/memo/memo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createMemo(Memo memo, String id) async {
    try {
      await _firestore
          .collection('users')
          .doc(id)
          .collection('memo')
          .doc(memo.id)
          .set(memo.toJson());
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Stream<List<Memo>> getMemo(String id) {
    try {
      return _firestore
          .collection('users')
          .doc(id)
          .collection('memo')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
        return snapshot.docs
            .map((QueryDocumentSnapshot<Map<String, dynamic>> e) {
          return Memo.fromJson(e);
        }).toList();
      });
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
