import 'package:mcgapp/enums/group.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUser {
  late String username;
  late String password;
  late String firstname;
  late String lastname;
  late Group group;

  AppUser({
    required this.username,
    required this.password,
    required this.firstname,
    required this.lastname,
    required this.group,
  });

  static AppUser? _user;

  static AppUser? get user => _user;

  static Future<void> saveUser(AppUser user) async {
    _user = user;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> encodedUser = [
      user.username,
      user.password,
      user.firstname,
      user.lastname,
      user.group.name,
    ];
    prefs.setStringList('user', encodedUser);
  }

  static Future<void> clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setStringList('user', []);
  }

  static Future<void> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> encodedUser = prefs.getStringList('user') ?? [];
    if (encodedUser.length == 5 && Group.fromName(encodedUser[3]) != null) {
      _user = AppUser(
        username: encodedUser[0],
        password: encodedUser[1],
        firstname: encodedUser[2],
        lastname: encodedUser[3],
        group: Group.fromName(encodedUser[4])!,
      );
    }
  }
}
