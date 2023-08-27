import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'memo.freezed.dart';
part 'memo.g.dart';

@freezed
class Memo with _$Memo {
  const factory Memo({
    required String id,
    required String title,
    required String content,
    required String userId,
    required String userName,
    required String userAvatar,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Memo;

  factory Memo.fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot) =>
      _$MemoFromJson(snapshot.data()!);
}
