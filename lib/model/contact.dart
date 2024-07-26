import 'package:flutter/material.dart';

class Contact {
  String name;
  String contact;
  String email;
  String? imagePath;

  Contact({
    required this.name,
    required this.contact,
    required this.email,
    this.imagePath,
  });

  get image => null;
}
