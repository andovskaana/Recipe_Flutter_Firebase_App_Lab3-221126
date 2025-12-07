import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:mis_lab2/firebase_options.dart';
import 'package:mis_lab2/screens/favorites_screen.dart';
import 'package:mis_lab2/screens/login_screen.dart';
import 'package:mis_lab2/screens/profile_screen.dart';
import 'package:mis_lab2/screens/register_screen.dart';
import 'screens/categories_screen.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Init notifications (local + FCM handlers + permissions)
  NotificationService().init();

///For checking that notifications work function to send instant message (no scheduling)
  NotificationService().showInstantTestNotification();
///For testing also but this tim,e with scheduling every 10 seconds
  //NotificationService().startDevSpamNotifications(seconds: 10);

  //  obtain and log the FCM registration token,
  //  I use this in firebase console to send a daily message using cloud messaging campaign
  final messaging = FirebaseMessaging.instance;
  final String? token = await messaging.getToken();
  debugPrint('FCM Registration Token: $token');
/// Daily messages are using firebase cloud messaging campaign
  runApp(const RecipesApp());
}

class RecipesApp extends StatelessWidget {
  const RecipesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
      ),
      home: const LoginScreen(),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const CategoriesScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/favorites': (_) => const FavoritesScreen(),
      },
    );
  }
}