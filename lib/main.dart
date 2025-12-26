import 'package:flutter/material.dart';
import 'screens/getstarted_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_form_screen.dart';
import 'screens/register_form_screen.dart';
import 'pages/main_page.dart';

void main() {
  runApp(const CoffeeApp());
}

class CoffeeApp extends StatelessWidget {
  const CoffeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coffee Shop',
      theme: ThemeData(primarySwatch: Colors.brown, fontFamily: 'Poppins'),
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterFormScreen(),
        '/home': (context) => const MainPage(),
      },
    );
  }
}
