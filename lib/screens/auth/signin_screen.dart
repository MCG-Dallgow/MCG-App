import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mcgapp/main.dart';
import 'package:mcgapp/screens/auth/signup_screen.dart';
import 'package:mcgapp/screens/home_screen.dart';
import 'package:mcgapp/widgets/text_fields.dart';

import '../../logic/auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  static const String routeName = '/signin';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _firebaseMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
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
              child: EmailField(controller: _emailController),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: PasswordField(controller: _passwordController),
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
                    setState(() {
                      _firebaseMessage = '';
                    });

                    if (_formKey.currentState?.validate() ?? false) {
                      dynamic response = await Auth().handleSignInWithEmailAndPassword(
                          _emailController.text.trim(), _passwordController.text.trim());

                      if (!mounted) return;

                      if (response is String) {
                        setState(() {
                          _firebaseMessage = response;
                        });
                      } else if (response is User) {
                        Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                      }
                    }
                  },
                )
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _firebaseMessage,
                  style: TextStyle(color: Theme.of(context).errorColor, fontSize: 12),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: ElevatedButton(
                  child: Row(mainAxisSize: MainAxisSize.min, children: const [
                    Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(Icons.add),
                    ),
                    Text('Neues Konto erstellen'),
                  ]),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      SignUpScreen.routeName,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
