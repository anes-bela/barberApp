import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'login_page.dart';
import '../main.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final bool darkMode = appState.isDarkMode;
    final Color backgroundColor = darkMode ? Colors.black : Colors.white;
    final Color textColor = darkMode ? Colors.white : Colors.black;
    final Color fieldColor = darkMode ? Colors.grey[800]! : Colors.white;
    final Color mainGreen = const Color(0xFF4CAF50);

    return Scaffold(
      backgroundColor: backgroundColor,
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
                    "S’inscrire",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Créez un compte pour profiter de toutes les fonctionnalités.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13,
                        color: darkMode ? Colors.grey[400] : Colors.grey),
                  ),
                  const SizedBox(height: 40),

                  // Nom complet
                  TextFormField(
                    controller: _nameController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: fieldColor,
                      prefixIcon:
                      Icon(Icons.person_outline, color: mainGreen),
                      labelText: "Nom complet",
                      labelStyle: TextStyle(
                          color: darkMode
                              ? Colors.grey[300]
                              : Colors.grey[700]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer votre nom complet";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: fieldColor,
                      prefixIcon:
                      Icon(Icons.email_outlined, color: mainGreen),
                      labelText: "Adresse e-mail",
                      labelStyle: TextStyle(
                          color: darkMode
                              ? Colors.grey[300]
                              : Colors.grey[700]),
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

                  // Mot de passe
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: fieldColor,
                      prefixIcon:
                      Icon(Icons.lock_outline, color: mainGreen),
                      labelText: "Mot de passe",
                      labelStyle: TextStyle(
                          color: darkMode
                              ? Colors.grey[300]
                              : Colors.grey[700]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: darkMode
                              ? Colors.grey[400]
                              : Colors.grey[700],
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer votre mot de passe";
                      }
                      if (value.length < 6) {
                        return "Le mot de passe doit contenir au moins 6 caractères";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Confirmer mot de passe
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: fieldColor,
                      prefixIcon:
                      Icon(Icons.lock_outline, color: mainGreen),
                      labelText: "Confirmer le mot de passe",
                      labelStyle: TextStyle(
                          color: darkMode
                              ? Colors.grey[300]
                              : Colors.grey[700]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: darkMode
                              ? Colors.grey[400]
                              : Colors.grey[700],
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword =
                            !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez confirmer votre mot de passe";
                      }
                      if (value != _passwordController.text) {
                        return "Les mots de passe ne correspondent pas";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // Bouton Créer un compte
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        appState.login(
                          name: _nameController.text.trim(),
                          email: _emailController.text.trim(),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const MainScaffold()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainGreen,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Créer un compte",
                      style:
                      TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Déjà un compte ?
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text("Vous avez déjà un compte ? ",
                          style: TextStyle(
                              fontSize: 13, color: textColor)),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginPage()),
                          );
                        },
                        child: Text("Connectez-vous ici",
                            style: TextStyle(
                                color: mainGreen, fontSize: 13)),
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



