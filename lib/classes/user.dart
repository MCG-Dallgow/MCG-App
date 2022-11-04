import 'package:mcgapp/classes/group.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUser {
  late String firstName;
  late String lastName;
  late String email;
  late Group group;

  AppUser({required this.firstName, required this.lastName, required this.email, required this.group});

  static late AppUser _user;

  static AppUser get user => _user;

  static Future<void> saveUser(AppUser user) async {
    _user = user;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> encodedUser = [user.firstName, user.lastName, user.email, user.group.name];
    prefs.setStringList('user', encodedUser);
  }

  static Future<void> clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setStringList('user', []);
  }

  static Future<void> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> encodedUser = prefs.getStringList('user') ?? [];
    if (encodedUser.length == 4 && Group.fromName(encodedUser[3]) != null) {
      _user = AppUser(
        firstName: encodedUser[0],
        lastName: encodedUser[1],
        email: encodedUser[2],
        group: Group.fromName(encodedUser[3])!,
      );
    }
  }
}