import 'package:flutter/material.dart';
import 'package:mycontacts/provider/contact_provider.dart';
import 'package:mycontacts/provider/hide_provider.dart';
import 'package:provider/provider.dart';

class hide_page extends StatelessWidget {
  const hide_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hide Contacts"),
      ),
      body: Consumer<HideContactProvider>(
        builder: (context, hideContactProvider, _) {
          return ListView(
            children: hideContactProvider.hideContacts.map((e) {
              return Card(
                elevation: 3,
                child: ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, 'detail_page', arguments: e);
                  },
                  title: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(e.name),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.phone,
                          color: Colors.green,
                        ),
                      ),
                      PopupMenuButton(
                        itemBuilder: (context) {
                          return <PopupMenuEntry>[
                            PopupMenuItem(
                              onTap: () {
                                Provider.of<ContactProvider>(context,
                                        listen: false)
                                    .addContact(e);
                                Provider.of<HideContactProvider>(context,
                                        listen: false)
                                    .removeContact(e);
                                Navigator.of(context).pop();
                              },
                              child: Text("Unhide"),
                            ),
                            PopupMenuItem(
                              onTap: () {
                                Provider.of<HideContactProvider>(context,
                                        listen: false)
                                    .removeContact(e);
                              },
                              child: Text("Delete"),
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
