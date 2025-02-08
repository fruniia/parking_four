import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({super.key});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.password_rounded),
        labelText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(
            _isObscure
                ? Icons.visibility_off_rounded
                : Icons.visibility_rounded,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter password' : null,
      obscureText: _isObscure,
    );
  }
}
