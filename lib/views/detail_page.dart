import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycontacts/model/contact.dart';
import 'package:mycontacts/provider/contact_provider.dart';
import 'package:mycontacts/provider/favourite_provider.dart';
import 'package:mycontacts/provider/image_provider.dart';
import 'package:mycontacts/provider/stepper_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    Contact contact = ModalRoute.of(context)!.settings.arguments as Contact;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Consumer<FavoriteProvider>(
            builder: (context, favoriteProvider, child) {
              bool isFavorite = favoriteProvider.isFavorite(contact);
              return IconButton(
                onPressed: () {
                  favoriteProvider.toggleFavorite(contact);
                },
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                ),
              );
            },
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  final stepperProvider =
                      Provider.of<StepperProvider>(context, listen: false);
                  stepperProvider.nameController =
                      TextEditingController(text: contact.name);
                  stepperProvider.contactController =
                      TextEditingController(text: contact.contact);
                  stepperProvider.emailController =
                      TextEditingController(text: contact.email);

                  return AlertDialog(
                    title: Text("Edit Contact"),
                    content: Consumer<StepperProvider>(
                      builder: (context, provider, child) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: provider.nameController,
                              decoration: InputDecoration(labelText: "Name"),
                            ),
                            TextField(
                              controller: provider.contactController,
                              decoration: InputDecoration(labelText: "Contact"),
                            ),
                            TextField(
                              controller: provider.emailController,
                              decoration: InputDecoration(labelText: "Email"),
                            ),
                          ],
                        );
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          final provider = Provider.of<StepperProvider>(context,
                              listen: false);
                          contact.name = provider.nameController.text;
                          contact.contact = provider.contactController.text;
                          contact.email = provider.emailController.text;
                          Navigator.of(context).pop();
                        },
                        child: Text("Save"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.edit),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                Provider.of<ContactProvider>(context, listen: false)
                    .deleteContact(contact);
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (route) => false);
              },
              icon: Icon(Icons.delete),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Consumer<imageProvider>(
              builder: (context, imageProvider, _) {
                return CircleAvatar(
                  radius: 70,
                  backgroundImage: contact.imagePath != null
                      ? FileImage(File(contact.imagePath!))
                      : null,
                  child: contact.imagePath == null
                      ? Text(
                          contact.name[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      : null,
                );
              },
            ),
            SizedBox(height: 16),
            Text(
              contact.name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              "Mobile +91 ${contact.contact}",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.phone, color: Colors.white, size: 25),
                    onPressed: () async {
                      await launchUrl(Uri.parse("tel:${contact.contact}"));
                    },
                  ),
                ),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.message, color: Colors.white, size: 25),
                    onPressed: () async {
                      await launchUrl(Uri.parse("sms:${contact.contact}"));
                    },
                  ),
                ),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.email, color: Colors.white, size: 25),
                    onPressed: () async {
                      await launchUrl(Uri.parse(
                          "mailto:${contact.email}?subject=Dummy&body=This is dummy contact"));
                    },
                  ),
                ),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.share, color: Colors.white, size: 25),
                    onPressed: () {
                      ShareExtend.share(
                          "Name:${contact.name}\nContact:${contact.contact}",
                          "text");
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
