import 'package:flutter/material.dart';

ButtonStyle buttonStyle1 = TextButton.styleFrom(
  padding: EdgeInsets.symmetric(horizontal: 20.0),
  backgroundColor: const Color(0xFF67C090),
  foregroundColor: const Color(0xFF3D7155),
  overlayColor: const Color(0xFF509570), 
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
  ),
  textStyle: TextStyle(
    fontWeight: FontWeight.bold,
  )
);