import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mcgapp/enums/group.dart';
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

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _groupController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _password = '';

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
              child: NameField(type: 'Vorname', controller: _firstnameController),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: NameField(type: 'Nachname', controller: _lastnameController),
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
              child: PasswordField(
                controller: _passwordController,
                onChanged: (value) => setState(() {
                  _password = value;
                }),
              ),
            ),
            PasswordStrengthIndicator(password: _password),
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
                    dynamic response = await Auth().handleSignUpWithEmailAndPassword(
                      _emailController.text,
                      _passwordController.text,
                      _firstnameController.text,
                      _lastnameController.text,
                      _groupController.text,
                    );

                    if (!mounted) return;

                    if (response is String) {
                      setState(() {
                        _firebaseMessage = response;
                      });
                    } else if (response is User) {
                      AppUser user = AppUser(
                        firstname: _firstnameController.text,
                        lastname: _lastnameController.text,
                        email: _emailController.text,
                        group: Group.fromName(_groupController.text)!,
                      );
                      AppUser.saveUser(user);

                      await Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false)
                          .then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          elevation: 6.0,
                          backgroundColor: Theme.of(context).primaryColor,
                          behavior: SnackBarBehavior.floating,
                          content: const Text(
                            'Willkommen, du bist jetzt registriert',
                            style: TextStyle(color: Colors.white),
                          ),
                        ));
                      });
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
