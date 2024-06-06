import 'package:flutter/material.dart';
import 'package:mycontacts/model/contact.dart';

class ContactProvider extends ChangeNotifier {
  List<Contact> allContacts = [];

  void addContact(Contact contact) {
    allContacts.add(contact);
    notifyListeners();
  }

  void deleteContact(Contact contact) {
    allContacts.remove(contact);
    notifyListeners();
  }

  void updateContact(Contact contact) {}
}
