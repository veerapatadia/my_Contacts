import 'dart:io';
import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mycontacts/provider/AppTheme_provider.dart';
import 'package:mycontacts/provider/contact_provider.dart';
import 'package:mycontacts/provider/hide_provider.dart';
import 'package:mycontacts/provider/image_provider.dart';
import 'package:mycontacts/provider/stepper_provider.dart';
import 'package:provider/provider.dart';

class home_page extends StatefulWidget {
  const home_page({super.key});

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Phone",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Switch(
            value: Provider.of<ThemeProvider>(context).isDark,
            onChanged: (val) {
              Provider.of<ThemeProvider>(context, listen: false).changeTheme();
            },
          ),
          IconButton(
            onPressed: () {
              Provider.of<StepperProvider>(context, listen: false)
                  .clearFields();
              // Provider.of<StepperProvider>(context, listen: false)
              //     .nameController
              //     .clear();
              // Provider.of<StepperProvider>(context, listen: false)
              //     .emailController
              //     .clear();
              // Provider.of<StepperProvider>(context, listen: false)
              //     .contactController
              //     .clear();
              // Provider.of<imageProvider>(context, listen: false)
              //     .();
              // Provider.of<StepperProvider>(context, listen: false).step = 0;
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertBox();
                  });
            },
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('search_page');
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () async {
              final LocalAuthentication auth = LocalAuthentication();
              bool isAuth = await auth.authenticate(
                localizedReason: "Please authenticate to show hidden contacts",
                options: AuthenticationOptions(),
              );

              if (isAuth) {
                Navigator.of(context).pushNamed('hide_page');
              }
            },
            icon: Icon(Icons.archive_outlined),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('favourite_page');
            },
            icon: Icon(Icons.star),
          ),
        ],
      ),
      body: Consumer<ContactProvider>(
        builder: (context, contactProvider, _) {
          return AlphabetScrollView(
            list: contactProvider.allContacts
                .map((e) => AlphaModel(e.name))
                .toList(),
            alignment: LetterAlignment.right,
            itemExtent: 100,
            selectedTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            unselectedTextStyle: TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
            itemBuilder: (context, index, name) {
              final contact = contactProvider.allContacts[index];
              return Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 5),
                child: Card(
                  elevation: 3,
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed('detail_page', arguments: contact);
                    },
                    subtitle: Row(
                      children: [
                        Consumer<imageProvider>(
                          builder: (context, imageProvider, _) {
                            return CircleAvatar(
                              radius: 30,
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
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            contact.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.phone,
                            color: Colors.green,
                          ),
                        ),
                        PopupMenuButton(
                          itemBuilder: (context) {
                            return <PopupMenuEntry>[
                              PopupMenuItem(
                                onTap: () {
                                  Future.microtask(() {
                                    Provider.of<HideContactProvider>(context,
                                            listen: false)
                                        .addContact(contact);
                                    Provider.of<ContactProvider>(context,
                                            listen: false)
                                        .deleteContact(contact);
                                  });
                                },
                                child: const Text("Hide"),
                              ),
                              PopupMenuItem(
                                onTap: () {
                                  Future.microtask(() {
                                    Provider.of<ContactProvider>(context,
                                            listen: false)
                                        .deleteContact(contact);
                                  });
                                },
                                child: const Text("Delete"),
                              ),
                            ];
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AlertBox extends StatelessWidget {
  const AlertBox({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Contact"),
      content: Container(
        height: 400,
        width: 400,
        child:
            Consumer<StepperProvider>(builder: (context, stepperProvider, _) {
          return Stepper(
            currentStep: stepperProvider.step,
            controlsBuilder: (context, _) {
              return Container(
                margin: EdgeInsets.only(top: 7),
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 95,
                      margin: EdgeInsets.only(right: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          stepperProvider.forwardStep(context);
                        },
                        child:
                            Text((stepperProvider.step == 3) ? "Save" : "Next"),
                      ),
                    ),
                    (stepperProvider.step == 0)
                        ? Container()
                        : Container(
                            height: 40,
                            width: 95,
                            child: OutlinedButton(
                              onPressed: () {
                                stepperProvider.backwardStep();
                              },
                              child: Text("Cancel"),
                            ),
                          ),
                  ],
                ),
              );
            },
            steps: [
              Step(
                title: const Text("Profile Photo"),
                content: Consumer<imageProvider>(
                  builder: (context, imageProvider, _) {
                    return Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: stepperProvider.imagePath != null
                              ? FileImage(File(stepperProvider.imagePath!))
                              : null,
                          child: stepperProvider.imagePath == null
                              ? IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text("Pick Image"),
                                            content: const Text(
                                                "Choose Image From Gallery or Camera"),
                                            actions: [
                                              FloatingActionButton(
                                                mini: true,
                                                onPressed: () async {
                                                  await imageProvider
                                                      .pickPhoto();
                                                  if (imageProvider
                                                          .pickImagePath !=
                                                      null) {
                                                    stepperProvider.setImagePath(
                                                        imageProvider
                                                            .pickImagePath!);
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                elevation: 3,
                                                child: const Icon(
                                                    Icons.camera_alt),
                                              ),
                                              FloatingActionButton(
                                                mini: true,
                                                onPressed: () async {
                                                  await imageProvider
                                                      .pickImage();
                                                  if (imageProvider
                                                          .pickImagePath !=
                                                      null) {
                                                    stepperProvider.setImagePath(
                                                        imageProvider
                                                            .pickImagePath!);
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                elevation: 3,
                                                child: const Icon(Icons.image),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  icon: const Icon(Icons.camera_alt),
                                )
                              : null,
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              ),
              Step(
                title: Text("Name"),
                content: Container(
                  padding: EdgeInsets.only(left: 5),
                  child: TextField(
                    controller: stepperProvider.nameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Enter name"),
                  ),
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Step(
                title: Text("Contact"),
                content: Container(
                  padding: EdgeInsets.only(left: 5),
                  child: TextField(
                    controller: stepperProvider.contactController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Enter contact"),
                  ),
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Step(
                title: Text("Email"),
                content: Container(
                  padding: EdgeInsets.only(left: 5),
                  child: TextField(
                    controller: stepperProvider.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Enter email"),
                  ),
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
