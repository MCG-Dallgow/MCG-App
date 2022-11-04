import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mcgapp/classes/group.dart';
import 'package:mcgapp/classes/user.dart';
import 'package:mcgapp/logic/auth.dart';

import '../../widgets/text_fields.dart';
import '../home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  static const routeName = '/signin/signup';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _groupController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _firebaseMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 32, bottom: 24),
              child: Center(
                child: Text(
                  'Neues Konto',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: NameField(type: 'Vorname', controller: _firstNameController),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: NameField(type: 'Nachname', controller: _lastNameController),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ClassField(controller: _groupController),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: EmailField(controller: _emailController),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: PasswordField(controller: _passwordController),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: PasswordConfirmationField(passwordController: _passwordController),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                child: const Text('Konto erstellen'),
                onPressed: () async {
                  setState(() {
                    _firebaseMessage = '';
                  });

                  if (_formKey.currentState?.validate() ?? false) {
                    dynamic response =
                        await Auth().handleSignUpWithEmailAndPassword(_emailController.text, _passwordController.text);

                    if (!mounted) return;

                    if (response is String) {
                      setState(() {
                        _firebaseMessage = response;
                      });
                    } else if (response is User) {
                      AppUser user = AppUser(
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        email: _emailController.text,
                        group: Group.fromName(_groupController.text)!,
                      );
                      AppUser.saveUser(user);

                      Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
                    }
                  }
                },
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _firebaseMessage,
                  style: TextStyle(color: Theme.of(context).errorColor, fontSize: 12),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  child: Row(mainAxisSize: MainAxisSize.min, children: const [
                    Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(Icons.arrow_back),
                    ),
                    Text('Mit vorhandenem Konto anmelden'),
                  ]),
                  onPressed: () {
                    Navigator.pop(context);
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
