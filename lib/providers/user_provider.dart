// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  String? _selectedUserId;
  List<Map<String, dynamic>> _users = [];

  UserProvider() {
    fetchUsers();
  }

  User? get user => _user;
  String? get selectedUserId => _selectedUserId;

  void updateUser(User? user) {
    _user = user;
    notifyListeners();
  }

  void updateSelectedUserId(String id) {
    _selectedUserId = id;
    notifyListeners();
  }

  Map<String, dynamic> getUserById(String? id) {
    print('Users: $_users'); // Check the _users list

    if (id == null) {
      return {};
    }

    Map<String, dynamic> user =
        _users.firstWhere((user) => user['email'] == id, orElse: () => {});
    print('User: $user'); // Check the user returned by the method

    return user;
  }

  Future<void> fetchUsers() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    _users = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    notifyListeners();
  }

  Future<void> updateUserActivity(String email) async {
    print('Updating user activity for $email');
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .update({
          'isOnline': true,
          'lastActive': Timestamp.now(),
        })
        .then((_) => print('User activity updated for $email'))
        .catchError((error) =>
            print('Failed to update user activity for $email: $error'));
  }

  Future<void> setUserOffline(String email) async {
    print('Setting user offline for $email');
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .update({'isOnline': false})
        .then((_) => print('User set offline for $email'))
        .catchError(
            (error) => print('Failed to set user offline for $email: $error'));
  }

  Stream<List<DocumentSnapshot>> getChatMessages() {
    // Stream of messages from this user to the other user
    Stream<QuerySnapshot> stream1 = FirebaseFirestore.instance
        .collection('messages')
        .where('fromUserEmail', isEqualTo: _user?.email)
        .where('toUserEmail', isEqualTo: _selectedUserId)
        .orderBy('timestamp', descending: true)
        .snapshots();

    // Stream of messages from the other user to this user
    Stream<QuerySnapshot> stream2 = FirebaseFirestore.instance
        .collection('messages')
        .where('fromUserEmail', isEqualTo: _selectedUserId)
        .where('toUserEmail', isEqualTo: _user?.email)
        .orderBy('timestamp', descending: true)
        .snapshots();

    // Combine the two streams and sort the results
    return Rx.combineLatest2<QuerySnapshot, QuerySnapshot,
        List<DocumentSnapshot>>(stream1, stream2, (a, b) {
      final allMessages = [...a.docs, ...b.docs];
      allMessages.sort((a, b) =>
          a['timestamp'].compareTo(b['timestamp'])); // Updated this line
      return allMessages;
    });
  }

  Future<void> sendMessage(String message) async {
    await FirebaseFirestore.instance.collection('messages').add({
      'fromUserEmail': _user?.email,
      'toUserEmail': _selectedUserId,
      'message': message,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> setUserTyping(String userEmail, bool isTyping) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .update({'isTyping': isTyping});
  }

  Stream<bool> isUserTyping(String userEmail) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .snapshots()
        .map((snapshot) => snapshot.data()?['isTyping'] ?? false);
  }
}
