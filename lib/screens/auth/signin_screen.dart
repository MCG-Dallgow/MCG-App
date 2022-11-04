import 'package:flutter/material.dart';
import 'package:mcgapp/main.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  static const String routeName = '/signin';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

String? validateEmail(String? value) {
  String pattern = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = RegExp(pattern);
  if (value == null || value.isEmpty) {
    return 'E-Mail ist erforderlich';
  } else if (!regex.hasMatch(value)) {
    return 'Gib eine gültige E-Mail-Adresse ein';
  } else {
    return null;
  }
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  bool passwordObscured = true;

  @override
  void initState() {
    super.initState();
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
              )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'E-Mail',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) => validateEmail(value),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextFormField(
                obscureText: passwordObscured,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Passwort',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(passwordObscured ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() {
                      passwordObscured = !passwordObscured;
                    }),
                  ),
                ),
                validator: (String? value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Passwort ist erforderlich';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(), //only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.only())),
                    child: Text(
                      'Passwort zurücksetzen',
                      style: TextStyle(color: themeManager.colorStroke),
                    ),
                    onPressed: () {},
                  ),
                  ElevatedButton(
                    child: const Text('Einloggen'),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {}
                    },
                  )
                ],
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
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
