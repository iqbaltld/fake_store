import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  @JsonKey(name: 'name')
  final UserNameModel name;

  UserModel({
    required super.id,
    required super.email,
    required super.username,
    required this.name,
    required super.phone,
  }) : super(firstName: name.firstname, lastName: name.lastname);

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable()
class UserNameModel {
  final String firstname;
  final String lastname;

  const UserNameModel({required this.firstname, required this.lastname});

  factory UserNameModel.fromJson(Map<String, dynamic> json) =>
      _$UserNameModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserNameModelToJson(this);
}
