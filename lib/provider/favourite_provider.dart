import 'package:flutter/material.dart';
import 'package:mycontacts/model/contact.dart';

class FavoriteProvider with ChangeNotifier {
  List<Contact> _favoriteContacts = [];

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

  bool isFavorite(Contact contact) {
    return _favoriteContacts.contains(contact);
  }

  void toggleFavorite(Contact contact) {
    if (isFavorite(contact)) {
      removeFavorite(contact);
    } else {
      addFavorite(contact);
    }
  }
}
