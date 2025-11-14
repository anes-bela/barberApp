import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final bool darkMode = appState.isDarkMode;

    final Color backgroundColor = darkMode ? Colors.black : Colors.white;
    final Color iconColor = darkMode ? Colors.greenAccent : Colors.green;
    final Color textColor = darkMode ? Colors.greenAccent : Colors.green;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cut, size: 100, color: iconColor),
            const SizedBox(height: 20),
            AnimatedOpacity(
              opacity: 1,
              duration: const Duration(seconds: 2),
              child: Text(
                "Coiffeassy",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

