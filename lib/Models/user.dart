import 'package:hive/hive.dart';

part 'user.g.dart'; 

@HiveType(typeId: 1)
class User {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String password;

  @HiveField(4)
  final String userType;

  @HiveField(5)
  final String? organizationCode;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.userType,
    this.organizationCode,
  });
}
