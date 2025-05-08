import 'package:hive/hive.dart';

part 'user.g.dart'; 
// This is a model class for a user in the Donezo app
@HiveType(typeId: 1)
class User {
  // This is the unique identifier for the user
  @HiveField(0)
  final String id;

// This is the name of the user
  @HiveField(1)
  final String name;

// This is the email address of the user
  @HiveField(2)
  final String email;

// This is the password of the user
  @HiveField(3)
  final String password;



// This is the constructor for the User class
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });
}
