import 'package:flutter/material.dart';

ButtonStyle buttonStyle1 = TextButton.styleFrom(
  padding: EdgeInsets.symmetric(horizontal: 20.0),
  backgroundColor: Colors.lightBlue.shade200.withAlpha(127),
  foregroundColor: Colors.black.withAlpha(200),
  overlayColor: Colors.lightBlue.shade300, 
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
  ),
);