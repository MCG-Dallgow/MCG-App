import 'package:flutter/material.dart';

class NameField extends StatelessWidget {
  const NameField({Key? key, required this.label, this.controller}) : super(key: key);

  final String label;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        prefixIcon: const Icon(Icons.person),
      ),
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return '$label ist erforderlich';
        }
        return null;
      },
    );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({Key? key, this.controller, this.label = 'Passwort', this.onChanged}) : super(key: key);

  final TextEditingController? controller;
  final String label;
  final dynamic onChanged;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _passwordObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _passwordObscured,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: widget.label,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(_passwordObscured ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() {
            _passwordObscured = !_passwordObscured;
          }),
        ),
      ),
      onChanged: widget.onChanged,
      validator: (String? value) {
        if ((value ?? '').trim().isEmpty) {
          return '${widget.label} ist erforderlich';
        }
        return null;
      },
    );
  }
}
