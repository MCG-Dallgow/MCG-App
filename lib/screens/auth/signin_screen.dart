import 'package:flutter/material.dart';
import 'package:mcgapp/main.dart';
import 'package:mcgapp/widgets/text_fields.dart';
import 'package:mcgapp/logic/api.dart';

import '../../classes/course.dart';
import '../../classes/user.dart';
import '../home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  static const String routeName = '/signin';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AppUser.loadUser();
      if (AppUser.user != null) {
        group = AppUser.user!.group;
        loadCourses();

        if (!mounted) return;
        await Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 64, bottom: 24),
              child: Center(
                child: Text(
                  'MCG-App',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: NameField(label: 'WebUntis-Benutzername', controller: _usernameController),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: PasswordField(label: 'WebUntis-Passwort', controller: _passwordController),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.only())),
                  child: Text(
                    'Passwort zurücksetzen',
                    style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color ?? themeManager.colorStroke),
                  ),
                  onPressed: () {},
                ),
                ElevatedButton(
                  child: const Text('Einloggen'),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      String username = _usernameController.text.trim();
                      String password = _passwordController.text.trim();
                      // log in logic
                      String loginResponse = await API.login(username, password);

                      switch (loginResponse) {
                        case 'user does not exist':
                          String signupResponse = await API.signup(username, password);
                          switch (signupResponse) {
                            case 'success':
                              await API.login(username, password);
                              break;
                            case 'invalid credentials':
                              setState(() {
                                _errorMessage = 'Die eingegebenen Anmeldedaten sind ungültig';
                              });
                              return;
                            case 'error':
                              setState(() {
                                _errorMessage = 'Ein Fehler ist aufgetreten';
                              });
                              return;
                          }
                          break;
                        case 'invalid credentials':
                          setState(() {
                            _errorMessage = 'Die eingegebenen Anmeldedaten sind ungültig';
                          });
                          return;
                        case 'error':
                          setState(() {
                            _errorMessage = 'Ein Fehler ist aufgetreten';
                          });
                          return;
                      }
                      if (!mounted) return;
                      await Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false)
                          .then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          elevation: 6.0,
                          backgroundColor: Theme.of(context).primaryColor,
                          behavior: SnackBarBehavior.floating,
                          content: const Text(
                            'Willkommen, du bist jetzt angemeldet',
                            style: TextStyle(color: Colors.white),
                          ),
                        ));
                      });
                    }
                  },
                )
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Theme.of(context).errorColor, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
