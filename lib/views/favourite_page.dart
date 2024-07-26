import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mycontacts/provider/favourite_provider.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Contacts'),
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, favoriteProvider, child) {
          if (favoriteProvider.favoriteContacts.isEmpty) {
            return Center(child: Text('No favorite contacts'));
          }

          return ListView.builder(
            itemCount: favoriteProvider.favoriteContacts.length,
            itemBuilder: (context, index) {
              final contact = favoriteProvider.favoriteContacts[index];
              return ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: contact.imagePath != null
                      ? FileImage(File(contact.imagePath!))
                      : null,
                  child: contact.imagePath == null
                      ? Text(contact.name[0].toUpperCase())
                      : null,
                ),
                title: Text(contact.name),
                subtitle: Text(contact.contact),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    favoriteProvider.removeFavorite(contact);
                  },
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    'detail_page',
                    arguments: contact,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
