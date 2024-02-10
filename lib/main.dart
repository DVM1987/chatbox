// ignore_for_file: prefer_const_constructors

import 'package:chatbox/providers/user_provider.dart';
import 'package:chatbox/views/screens/spash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  UserProvider? userProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        userProvider?.updateUserActivity(
            FirebaseAuth.instance.currentUser?.email ?? '');
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        userProvider
            ?.setUserOffline(FirebaseAuth.instance.currentUser?.email ?? '');
        break;
      case AppLifecycleState.hidden:
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          userProvider = UserProvider();
          return userProvider!;
        }),
        StreamProvider<User?>.value(
          value: FirebaseAuth.instance.userChanges(),
          initialData: null,
        ),
        // Add other providers here...
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SpashScreen(),
      ),
    );
  }
}
