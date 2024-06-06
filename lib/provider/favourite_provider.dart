import 'package:flutter/material.dart';
import 'package:mycontacts/model/contact.dart';

class FavoriteProvider with ChangeNotifier {
  List<Contact> _favoriteContacts = [];
  bool isFavourite = false;

  List<Contact> get favoriteContacts => _favoriteContacts;

  void addFavorite(Contact contact) {
    if (!_favoriteContacts.contains(contact)) {
      _favoriteContacts.add(contact);
      notifyListeners();
    }
  }

  void removeFavorite(Contact contact) {
    if (_favoriteContacts.contains(contact)) {
      _favoriteContacts.remove(contact);
      notifyListeners();
    }
  }
}
