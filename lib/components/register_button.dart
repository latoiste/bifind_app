import 'package:bifind_app/styles/buttons_style.dart';
import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key, required this.onPressed});

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: buttonStyle1,
      onPressed: onPressed,
      child: const Text("Register"),
    );
  }
}
