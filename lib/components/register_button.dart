import 'package:bifind_app/styles/buttons_style.dart';
import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: buttonStyle1,
      onPressed: () {
        print("FUCK");
      },
      child: const Text("Register"),
    );
  }
}
