import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.repeat(reverse: true);

    Future.delayed(const Duration(seconds: 3), () {
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const LoginPage()),
    );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
    backgroundColor: cs.background,
    body: Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    ScaleTransition(
    scale: _animation,
    child: Icon(Icons.cut, size: 100, color: cs.primary),
    ),
    const SizedBox(height: 20),
    FadeTransition(
    opacity: _animation,
    child: Text(
    "Coiffeassy",
    style: TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: cs.primary,
    ),
    ),
    ),
    ],
    ),
    ),
    );

  }
}

