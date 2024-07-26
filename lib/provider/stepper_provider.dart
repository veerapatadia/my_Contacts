import 'package:flutter/material.dart';
import 'package:mycontacts/model/contact.dart';
import 'package:mycontacts/provider/contact_provider.dart';
import 'package:provider/provider.dart';

class StepperProvider extends ChangeNotifier {
  int step = 0;
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String? imagePath;

  void forwardStep(BuildContext context) {
    if (step == 3) {
      Contact contact = Contact(
        name: nameController.text,
        contact: contactController.text,
        email: emailController.text,
        imagePath: imagePath,
      );
      Provider.of<ContactProvider>(context, listen: false).addContact(contact);
      Navigator.pop(context);
    }
    if (step < 3) {
      step++;
    }
    notifyListeners();
  }

  void backwardStep() {
    if (step > 0) {
      step--;
    }
    notifyListeners();
  }

  void clearFields() {
    nameController.clear();
    contactController.clear();
    emailController.clear();
    imagePath = null;
    step = 0;
    notifyListeners();
  }

  void setImagePath(String path) {
    imagePath = path;
    notifyListeners();
  }
}
