import 'package:flutter/material.dart';

import '../classes/group.dart';

String? _validateEmail(String? value) {
  String pattern = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = RegExp(pattern);
  if (value == null || value.trim().isEmpty) {
    return 'E-Mail ist erforderlich';
  } else if (!regex.hasMatch(value)) {
    return 'Gib eine gültige E-Mail-Adresse ein';
  } else {
    return null;
  }
}

class NameField extends StatelessWidget {
  const NameField({Key? key, required this.type, this.controller}) : super(key: key);

  final String type;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: type,
        prefixIcon: const Icon(Icons.person),
      ),
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return '$type ist erforderlich';
        }
        return null;
      },
    );
  }
}

class ClassField extends StatefulWidget {
  const ClassField({Key? key, this.controller}) : super(key: key);

  final TextEditingController? controller;

  @override
  State<ClassField> createState() => _ClassFieldState();
}

class _ClassFieldState extends State<ClassField> {
  final List<Group> _dropdownItems = Group.values;
  late Group _dropdownValue;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = widget.controller ?? TextEditingController();

    return DropdownButtonFormField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.tag),
      ),
      hint: const Text('Klasse'),
      items: _dropdownItems.map((Group value) => DropdownMenuItem<Group>(
            value: value,
            child: Text(value.name),
          )).toList(),
      onChanged: (Group? newValue) {
        setState(() {
          _dropdownValue = newValue ?? _dropdownValue;
          controller.text = _dropdownValue.name;
        });
      },
      validator: (Group? value) {
        if (value == null) {
          return 'Klasse ist erforderlich';
        }
        return null;
      },
    );
  }
}

class EmailField extends StatelessWidget {
  const EmailField({Key? key, this.controller}) : super(key: key);

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'E-Mail',
        prefixIcon: Icon(Icons.email),
      ),
      validator: (value) => _validateEmail(value),
    );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({Key? key, this.controller}) : super(key: key);

  final TextEditingController? controller;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool passwordObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
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
    );
  }
}

class PasswordConfirmationField extends StatefulWidget {
  const PasswordConfirmationField({Key? key, required this.passwordController}) : super(key: key);

  final TextEditingController passwordController;

  @override
  State<PasswordConfirmationField> createState() => _PasswordConfirmationFieldState();
}

class _PasswordConfirmationFieldState extends State<PasswordConfirmationField> {
  bool passwordObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: passwordObscured,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: 'Passwort wiederholen',
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
        if (value != widget.passwordController.text) {
          return 'Passwort stimmt nicht überein';
        }
        return null;
      },
    );
  }
}
