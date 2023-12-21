import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huskkk/chatBox.dart';
import 'package:huskkk/homePage.dart';
import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _textEditingController = TextEditingController();

  var _contacts;
  var _filteredContacts;
  PermissionStatus? _permissionStatus;

  @override
  void initState() {
    super.initState();
    initializePermission();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> initializePermission() async {
    final status = await Permission.contacts.status;
    setState(() {
      _permissionStatus = status;
    });
    if (_permissionStatus!.isGranted) {
      fetchContacts();
    }
  }

  Future<void> requestContactsPermission() async {
    final status = await Permission.contacts.request();
    setState(() {
      _permissionStatus = status;
    });
    if (_permissionStatus!.isGranted) {
      fetchContacts();
    }
  }

  Future<void> fetchContacts() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').get();

      var contacts = [];

      for (var doc in snapshot.docs) {
        String contactName = doc[
            'username']; // Assuming 'username' is the field for contact name
        String phoneNumber =
            doc['name']; // Assuming 'displayname' is the field for phone number

        var contactInfo = {
          'name': contactName,
          'phoneNumber': phoneNumber,
        };

        contacts.add(contactInfo);
      }

      if (mounted) {
        setState(() {
          _contacts = contacts;
          print(contacts);
          _filteredContacts = _contacts!.toList();
        });
      }

      filterContacts(_textEditingController.text); // Apply initial filtering
    } catch (e) {
      print('Error fetching contacts: $e');
    }
  }

  void filterContacts(String filterText) {
    if (mounted) {
      setState(() {
        if (filterText.isEmpty) {
          _filteredContacts =
              _contacts; // If filter text is empty, show all contacts
        } else {
          _filteredContacts = _contacts
              ?.where((contact) =>
                  contact.displayName
                      ?.toLowerCase()
                      .contains(filterText.toLowerCase()) ==
                  true)
              .toList(); // Filter contacts based on the filter text
        }
      });
    }
  }

  Widget _buildContactsList() {
    if (_permissionStatus == PermissionStatus.denied ||
        _permissionStatus == PermissionStatus.permanentlyDenied) {
      requestContactsPermission(); // Move permission request here

      return _buildPermissionDeniedWidget();
    } else if (_contacts == null) {
      return Center(child: CircularProgressIndicator());
    } else if (_contacts!.isEmpty) {
      return Center(child: Text('No contacts found.'));
    } else {
      print("Contacts: $_contacts");
      return ListView.builder(
        itemCount: _filteredContacts?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          final eachcontact = _filteredContacts![index];
          return ChatCard(
            name: eachcontact["name"] ?? "",
            phoneNumber: eachcontact["phoneNumber"]?.isNotEmpty == true
                ? eachcontact["phoneNumber"] ?? ''
                : '',
          );
        },
      );
    }
  }

  Widget _buildPermissionDeniedWidget() {
    return Column(
      children: [
        ListTile(
          title: Text(
            _permissionStatus == PermissionStatus.denied
                ? 'Contacts permission denied.'
                : 'Contacts permission permanently denied.',
          ),
          subtitle: Text('Please enable contacts permission in app settings.'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    globals.screenWidth = MediaQuery.of(context).size.width;
    globals.screenHeight = MediaQuery.of(context).size.height;
    globals.statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Color(0xff0D5882),
      body: SafeArea(
        child: Container(
          //color: Colors.green,
          height: globals.screenHeight - globals.statusBarHeight,
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff0D5882),
                      Color(0xff0086D1),
                    ],
                  )),
                  height: globals.generalize(50),
                  width: globals.screenWidth,
                  child: Padding(
                    padding:
                        EdgeInsets.fromLTRB(0, 0, globals.generalize(8), 0),
                    child: Row(children: [
                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => HomePage(nav: 1))),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(globals.generalize(4), 0,
                              globals.generalize(4), 0),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: globals.generalize(20),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          //width: globals.screenWidth,
                          height: globals.generalize(40),
                          //color: Colors.yellow,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(40)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 9,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(globals.generalize(12),
                                0, globals.generalize(12), 0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: SizedBox(
                                  child: TextFormField(
                                    controller:
                                        _textEditingController, // Add text controller
                                    onChanged: filterContacts,
                                    decoration: const InputDecoration.collapsed(
                                        hintText: 'Type something here'),
                                    keyboardType: TextInputType.name,
                                  ),
                                )),
                                Icon(
                                  Icons.search,
                                  size: globals.generalize(18),
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ]),
                  )),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: _buildContactsList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatCard extends StatelessWidget {
  final String name;
  final String phoneNumber;

  const ChatCard({
    required this.name,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ChatBox(
            name: name,
            friendNum: phoneNumber.replaceAll(RegExp(r'[^0-9]'), ''),
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          globals.generalize(12),
          globals.generalize(4),
          globals.generalize(12),
          globals.generalize(4),
        ),
        child: Container(
          width: globals.screenWidth,
          height: globals.generalize(50),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5.0,
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              topLeft: Radius.circular(50),
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(globals.generalize(3)),
                child: Container(
                  width: globals.generalize(45),
                  height: globals.generalize(45),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/myPic.jpeg'),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: globals.generalize(5),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    0,
                    globals.generalize(8),
                    0,
                    globals.generalize(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: globals.generalize(15),
                          color: Colors.black,
                          fontFamily: "FredokaOne",
                        ),
                      ),
                      // Expanded(
                      //   child: SizedBox(
                      //     height: 1,
                      //   ),
                      // ),
                      // Text(
                      //   "Thanks for inviting me",
                      //   style: TextStyle(
                      //     fontSize: globals.generalize(10),
                      //     color: Colors.grey[600],
                      //     fontFamily: "FredokaOne",
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(),
              ),
              Padding(
                padding: EdgeInsets.all(globals.generalize(18)),
                child: Text(
                  "10:23",
                  style: TextStyle(
                    fontSize: globals.generalize(10),
                    color: Colors.grey[600],
                    fontFamily: "FredokaOne",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
