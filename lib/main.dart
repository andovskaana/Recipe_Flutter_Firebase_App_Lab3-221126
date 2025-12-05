import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mis_lab2/firebase_options.dart';
import 'package:mis_lab2/screens/login_screen.dart';
import 'package:mis_lab2/screens/profile_screen.dart';
import 'package:mis_lab2/screens/register_screen.dart';
import 'screens/categories_screen.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform,
  );
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

      },
    );
  }
}
