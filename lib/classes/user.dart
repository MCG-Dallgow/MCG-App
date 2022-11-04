import 'package:mcgapp/classes/group.dart';

class AppUser {
  late String firstName;
  late String lastName;
  late String email;
  late Group group;

  AppUser({required this.firstName, required this.lastName, required this.email, required this.group});
}