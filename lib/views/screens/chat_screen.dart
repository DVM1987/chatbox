// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, unused_local_variable, use_build_context_synchronously, avoid_print, prefer_final_fields

// import 'package:chatbox/models/message_bubble.dart';
import 'dart:async';

import 'package:chatbox/models/message_bubble.dart';
import 'package:chatbox/providers/user_provider.dart';
import 'package:chatbox/views/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
// import 'package:flutter/rendering.dart';

// import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _shouldShowNewMessagePopup = false;
  int _currentMessageCount = 0;
  StreamController<int> _messageCountController = StreamController<int>();
  final ValueNotifier<bool> _isTyping = ValueNotifier<bool>(false);
  // late StreamSubscription _typingIndicatorSubscription;

  @override
  void initState() {
    super.initState();
    // _textController.addListener(_handleTextChanged);
    _scrollController.addListener(_scrollListener);
    _messageCountController.stream.listen((messageCount) {
      if (messageCount > _currentMessageCount &&
          _scrollController.hasClients &&
          _scrollController.position.pixels !=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.isScrollingNotifier.value) {
        setState(() {
          _shouldShowNewMessagePopup = true;
        });
      }
      _currentMessageCount = messageCount;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    // _textController.removeListener(_handleTextChanged);
    _messageCountController.close();

    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        setState(() {
          _shouldShowNewMessagePopup = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final selectedUserEmail = userProvider.selectedUserId;
    final currentUserEmail = userProvider.user?.email;

    print('Selected User Email: $selectedUserEmail');
    print(currentUserEmail);

    /// Get current user email

    // Check the selected use
    return Scaffold(
      backgroundColor: Color(0xFF121414),

      // backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Color(0xFF121414),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () async {
                String? email = FirebaseAuth.instance.currentUser?.email;
                if (email != null) {
                  // User is logged in, set them offline before logging out
                  await Provider.of<UserProvider>(context, listen: false)
                      .setUserOffline(email);
                }
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
            title: Row(
              children: [
                Stack(
                  children: <Widget>[
                    CircleAvatar(
                      // Replace with your desired image
                      backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8YXZhdGFyfGVufDB8fDB8fHww'),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jhon Abraham',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(selectedUserEmail)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            final data =
                                snapshot.data!.data() as Map<String, dynamic>?;
                            final isOnline =
                                data != null && data.containsKey('isOnline')
                                    ? data['isOnline']
                                    : false;
                            final lastActive = data != null &&
                                    data.containsKey('lastActive')
                                ? (data['lastActive'] as Timestamp?)?.toDate()
                                : null;
                            final timeAgo = lastActive != null
                                ? timeago.format(lastActive)
                                : 'Offline';
                            return StreamBuilder<bool>(
                              stream: selectedUserEmail != null
                                  ? Provider.of<UserProvider>(context,
                                          listen: false)
                                      .isUserTyping(selectedUserEmail)
                                  : Stream.value(false),
                              builder: (context, snapshot) {
                                final isTyping =
                                    snapshot.hasData && snapshot.data == true;
                                if (isTyping) {
                                  return Text(
                                    'Typing...',
                                    style: TextStyle(
                                      color: Color(0xFF797C7B),
                                      fontSize: 12,
                                    ),
                                  );
                                } else if (isOnline) {
                                  return Text(
                                    'Active now',
                                    style: TextStyle(
                                      color: Color(0xFF797C7B),
                                      fontSize: 12,
                                    ),
                                  );
                                } else if (lastActive != null &&
                                    DateTime.now()
                                            .difference(lastActive)
                                            .inHours <=
                                        3) {
                                  return Text(
                                    timeAgo,
                                    style: TextStyle(
                                      color: Color(0xFF797C7B),
                                      fontSize: 12,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    'Offline',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  );
                                }
                              },
                            );
                          } else {
                            return Text(
                              'Offline',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            );
                          }
                        },
                      )
                      // StreamBuilder<bool>(
                      //   stream: selectedUserEmail != null
                      //       ? Provider.of<UserProvider>(context, listen: false)
                      //           .isUserTyping(selectedUserEmail)
                      //       : Stream.value(
                      //           false), // provide a default stream if selectedUserEmail is null
                      //   builder: (context, snapshot) {
                      //     if (snapshot.hasData && snapshot.data == true) {
                      //       return Text(
                      //         'Typing...',
                      //         style: TextStyle(
                      //           color: Color(0xFF797C7B),
                      //           fontSize: 12,
                      //         ),
                      //       );
                      //     } else {
                      //       return Text(
                      //         'Active now',
                      //         style: TextStyle(
                      //           color: Color(0xFF797C7B),
                      //           fontSize: 12,
                      //         ),
                      //       );
                      //     }
                      //   },
                      // ),
                      // Add more Text widgets here if you want to display more information
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.phone,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Add your code here to handle the phone button press
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.videocam_sharp,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Add your code here to handle the camera button press
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<DocumentSnapshot>>(
              stream: userProvider.getChatMessages(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                if (snapshot.data?.length != _currentMessageCount) {
                  _currentMessageCount = snapshot.data?.length ?? 0;
                  _messageCountController.add(_currentMessageCount);
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        reverse: true,
                        controller: _scrollController,
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          final message =
                              snapshot.data?.reversed.toList()[index];
                          final messageText = message?['message'];
                          final messageSender = message?['fromUserEmail'];
                          final messageTime =
                              message?['timestamp'].toDate().toString() ??
                                  'N/A';
                          final isCurrentUser =
                              messageSender == currentUserEmail;
                          if (messageText != null &&
                              messageSender != null &&
                              messageText.isNotEmpty) {
                            return MessageBubble(
                              messageText: messageText,
                              messageSender: messageSender,
                              messageTime: messageTime,
                              isCurrentUser: isCurrentUser,
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                    if (_shouldShowNewMessagePopup)
                      GestureDetector(
                        onTap: () {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeOut,
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          color: Colors.blue,
                          child: Text('New messages'),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          _buildTextComposer(context),
        ],
      ),
    );
  }

  Widget _buildTextComposer(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Image.asset(
                'assets/images/Clip.png', // Replace with your image asset path
                width: 24,
                height: 24,
              ),
              onPressed: () {
                // Add your code here to handle the camera button press
              },
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Color(0xFF192222),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ValueListenableBuilder<bool>(
                  valueListenable: _isTyping,
                  builder: (context, isTyping, _) {
                    final currentUserEmail = userProvider.user?.email;

                    if (currentUserEmail != null) {
                      userProvider
                          .setUserTyping(currentUserEmail, isTyping)
                          .catchError((error) {
                        print('Failed to update isTyping status: $error');
                      });
                    }

                    return TextField(
                      controller: _textController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Write your message",
                        hintStyle: TextStyle(color: Colors.white54),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        suffixIcon: Image.asset(
                          'assets/images/Vector1.png', // Updated path
                          color: Colors.white54,
                          width: 24,
                          height: 24,
                        ),
                      ),
                      onChanged: (text) {
                        _isTyping.value = text.trim().isNotEmpty;
                      },
                    );
                  },
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.mic),
              onPressed: () {
                // Add your code here to handle the microphone button press
              },
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () async {
                  userProvider.sendMessage(_textController.text);
                  _textController.clear();
                  await Future.delayed(Duration(milliseconds: 500));
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                  );
                  if (_scrollController.position.pixels ==
                      _scrollController.position.maxScrollExtent) {
                    setState(() {
                      _shouldShowNewMessagePopup = false;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
