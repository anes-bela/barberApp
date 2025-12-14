import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';
import 'login_page.dart';
import 'splash_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        // ⏳ Pendant le chargement
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        // ✔️ Utilisateur connecté → afficher l'app principale
        if (snapshot.hasData) {
          return const MainScaffold();
        }

        // ❌ Pas connecté → afficher la page Login
        return const LoginPage();
      },
    );
  }
}
