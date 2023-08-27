import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String email,
    required String avatar,
  }) = _UserModel;

  factory UserModel.fromJson(DocumentSnapshot<Map<String, dynamic>> snapshot) =>
      _$UserModelFromJson(snapshot.data()!);
}
