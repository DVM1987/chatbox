// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, avoid_print, prefer_const_literals_to_create_immutables, unnecessary_cast, use_build_context_synchronously

import 'package:chatbox/providers/user_provider.dart';
import 'package:chatbox/views/screens/chat_screen.dart';
import 'package:chatbox/views/screens/onboarding_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YourScreen extends StatefulWidget {
  @override
  State<YourScreen> createState() => _YourScreenState();
}

class _YourScreenState extends State<YourScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showSearch = false;
  final List<Map<String, String>> data = [
    {
      'name': 'Alice',
      'imageUrl':
          'https://plus.unsplash.com/premium_photo-1658527049634-15142565537a?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8YXZhdGFyfGVufDB8fDB8fHww'
    },
    {
      'name': 'Bob',
      'imageUrl':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8YXZhdGFyfGVufDB8fDB8fHww'
    },
    {
      'name': 'Charlie',
      'imageUrl':
          'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8YXZhdGFyfGVufDB8fDB8fHww'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<User?>(
      builder: (context, user, _) {
        if (user != null) {
          return Scaffold(
            backgroundColor: Color(0xFF24786D),
            appBar: AppBar(
              backgroundColor: Color(0xFF24786D),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      setState(() {
                        _showSearch = !_showSearch;
                      });
                    },
                    child: Image.asset(
                      'assets/images/Group 370.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  Expanded(
                    child: _showSearch
                        ? TextField(
                            controller: _searchController,
                            onSubmitted: (value) async {
                              final users = await searchUsers(value);
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Color(
                                    0xFF121414), // Set the background color
                                builder: (context) {
                                  return ListView(
                                    children: users
                                        .map((user) => ListTile(
                                              title: GestureDetector(
                                                onTap: () {
                                                  String? userId = user[
                                                      'email']; // Use 'email' as the user ID
                                                  if (userId != null) {
                                                    Provider.of<UserProvider>(
                                                            context,
                                                            listen: false)
                                                        .updateSelectedUserId(
                                                            userId);
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChatScreen(),
                                                      ),
                                                    );
                                                  } else {
                                                    print('User ID is null');
                                                  }
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    CircleAvatar(),
                                                    SizedBox(
                                                        width:
                                                            10), // Add some space between the avatar and the text
                                                    // Check if the user name is not null before using it
                                                    Text(
                                                      user['name'] ?? 'Unknown',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  );
                                },
                              );
                            },
                            decoration: InputDecoration(
                              labelText: 'Search',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Set border radius
                                borderSide: BorderSide(
                                  color: Colors.white, // Set border color
                                  width: 2.0, // Set border width
                                ),
                              ),
                            ),
                          )
                        : Text(
                            'Home',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8YXZhdGFyfGVufDB8fDB8fHww'),
                    radius: 20,
                  ),
                ],
              ),
            ),
            body: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    top: 40,
                    left: 20,
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right: 20,
                        ),
                        child: Column(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 2,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 35,
                                    backgroundColor: Colors.transparent,
                                    child: CircleAvatar(
                                      radius: 33,
                                      backgroundImage: NetworkImage(
                                          data[index]['imageUrl']!),
                                    ),
                                  ),
                                ),
                                if (index == 0)
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Image.asset(
                                      'assets/images/Group 46.png',
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              data[index]['name']!,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height / 5,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF121414),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 50, left: 20, right: 20),
                        child: Dismissible(
                          key: Key('message1'),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            // Show a dialog or another UI to confirm the dismissal
                            final bool? result = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirm"),
                                  content: const Text(
                                      "Are you sure you wish to delete this item?"),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text("DELETE")),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text("CANCEL"),
                                    ),
                                  ],
                                );
                              },
                            );
                            return result;
                          },
                          onDismissed: (direction) {
                            if (direction == DismissDirection.endToStart) {
                              // Handle the dismissal
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Item dismissed")),
                              );
                            }
                          },
                          background: Container(
                            color: Color(0xFF797C7B).withOpacity(0.2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.notifications),
                                    color: Colors.black,
                                    onPressed: () {
                                      print('Notification button pressed');
                                    },
                                  ),
                                ),
                                SizedBox(width: 20),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.white,
                                    onPressed: () {
                                      print('Delete button pressed');
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          child: Row(
                            children: [
                              Stack(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8YXZhdGFyfGVufDB8fDB8fHww'),
                                    radius: 30,
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Alex LInderson',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'How are you doing today?',
                                    style: TextStyle(
                                      color: Color(0xFF797C7B),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    '2 min ago',
                                    style: TextStyle(
                                      color: Color(0xFF797C7B),
                                    ),
                                  ),
                                  Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '3',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xFF797C7B),
                    width: 0.5,
                  ),
                ),
              ),
              child: BottomNavigationBar(
                elevation: 20.0,
                backgroundColor: Color(0xFF121414),
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.business),
                    label: 'Business',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.school),
                    label: 'School',
                  ),
                ],
              ),
            ),
          ); // Your existing home screen
        } else {
          return OnboardingScreen(); // Your login or register screen
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    try {
      final usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: query)
          .get();
      return usersSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error searching users: $e');
      return [];
    }
  }
}
