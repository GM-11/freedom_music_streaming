import 'package:flutter/material.dart';
import 'package:freedom/home/playSong.dart';
import 'package:freedom/onboarding/signup.dart';

import 'home/search.dart';
import 'onboarding/root.dart';
import 'onboarding/signInWallet.dart';
import 'onboarding/signin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        if (settings.name == '/play') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) {
              return PlaySong(
                imageUri: args['imageUri'] as String,
                artistName: args['artistName'] as String,
                songName: args['songName'] as String,
                songUri: args['songUri'] as String,
                duration: int.parse(args['duration'] as String),
              );
            },
          );
        }
        return null;
      },
      routes: {
        "/": (context) => const Root(),
        "/signup": (context) => const SignupScreen(),
        "/signin": (context) => const SignInPage(),
        "/search": (context) => const SearchSongScreen(),
        "/signinWallet": (context) => const SignInWalletPage(),

      },
      title: 'Freedom Music streaming',
      theme: ThemeData(
        // brightness: Brightness.dark,
        primaryColor:
            const Color(0xFF7D5BA6),
        // Neon purple for buttons and highlights
        scaffoldBackgroundColor:
            const Color(0xFF121212), // Vibrant purple accent color
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          titleLarge: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(
            color: Colors.grey[300],
            fontSize: 16,
          ),
          bodyMedium: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: const Color(0xFF7D5BA6), // Button color
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        cardColor: const Color(0xFF1E1E1E), // Card background
        iconTheme: const IconThemeData(
          color: Colors.white, // Icon color
          size: 24,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color(0xFF121212),
          selectedItemColor: const Color(0xFF7D5BA6),
          unselectedItemColor: Colors.grey[600],
          showUnselectedLabels: true,
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: const Color(0xFF7D5BA6),
          inactiveTrackColor: Colors.grey[700],
          thumbColor: const Color(0xFF7D5BA6),
          overlayColor: const Color(0xFF7D5BA6).withOpacity(0.2),
          trackHeight: 2.0,
        ),
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: const Color(0xFF7D5BA6)),
      ),
      // home: const Root(),
    );
  }
}
