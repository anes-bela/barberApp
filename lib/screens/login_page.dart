import 'package:flutter/material.dart';
import 'package:gestion_jr/screens/ForgotPassword_page.dart';
import '../main.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.background,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Se connecter",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: cs.onBackground,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    "Entrez votre e-mail et mot de passe pour accéder à votre compte.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: cs.onBackground.withOpacity(0.7),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // EMAIL
                  TextFormField(
                    controller: _emailController,
                    style: TextStyle(color: cs.onSurface),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: cs.surface,
                      prefixIcon: Icon(Icons.email_outlined, color: cs.primary),
                      labelText: "Adresse e-mail",
                      labelStyle: TextStyle(color: cs.onSurface.withOpacity(0.7)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer votre adresse e-mail";
                      }
                      if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return "Entrez une adresse e-mail valide";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // PASSWORD
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: TextStyle(color: cs.onSurface),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: cs.surface,
                      prefixIcon: Icon(Icons.lock_outline, color: cs.primary),
                      labelText: "Mot de passe",
                      labelStyle: TextStyle(color: cs.onSurface.withOpacity(0.7)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: cs.onSurface.withOpacity(0.6),
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // REMEMBER + FORGOT PASSWORD
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            activeColor: cs.primary,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                          ),
                          Text(
                            "Se souvenir de moi",
                            style: TextStyle(color: cs.onBackground),
                          ),
                        ],
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                          );
                        },
                        child: Text(
                          "Mot de passe oublié ?",
                          style: TextStyle(color: cs.primary),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // LOGIN BUTTON
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const MainScaffold()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("Se connecter", style: TextStyle(fontSize: 15)),
                  ),

                  const SizedBox(height: 16),

                  // CONTINUE WITHOUT ACCOUNT
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const MainScaffold()),
                      );
                    },
                    child: Text(
                      "Continuer sans compte",
                      style: TextStyle(color: cs.primary, fontSize: 14),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // SIGNUP LINE (SAME ROW)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Vous n’avez pas de compte ? ",
                        style: TextStyle(color: cs.onBackground, fontSize: 13),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SignupPage()),
                          );
                        },
                        child: Text(
                          "Inscrivez-vous ici",
                          style: TextStyle(color: cs.primary, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
