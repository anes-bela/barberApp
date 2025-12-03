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
  final TextEditingController _confirmPasswordController = TextEditingController();

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
                    "S’inscrire",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: cs.onBackground,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    "Créez un compte pour profiter de toutes les fonctionnalités.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: cs.onBackground.withOpacity(0.7),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // NOM COMPLET
                  TextFormField(
                    controller: _nameController,
                    style: TextStyle(color: cs.onSurface),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: cs.surface,
                      prefixIcon: Icon(Icons.person_outline, color: cs.primary),
                      labelText: "Nom complet",
                      labelStyle: TextStyle(color: cs.onSurface.withOpacity(0.7)),
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

                  // MOT DE PASSE
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

                  // CONFIRMER MOT DE PASSE
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    style: TextStyle(color: cs.onSurface),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: cs.surface,
                      prefixIcon: Icon(Icons.lock_outline, color: cs.primary),
                      labelText: "Confirmer le mot de passe",
                      labelStyle: TextStyle(color: cs.onSurface.withOpacity(0.7)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: cs.onSurface.withOpacity(0.6),
                        ),
                        onPressed: () {
                          setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
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

                  // BOUTON CRÉER UN COMPTE
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Provider.of<AppState>(context, listen: false).login(
                          name: _nameController.text.trim(),
                          email: _emailController.text.trim(),
                        );

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
                    child: const Text("Créer un compte", style: TextStyle(fontSize: 15)),
                  ),

                  const SizedBox(height: 16),

                  // ————————————————
                  //   DÉJÀ UN COMPTE ? (UNE SEULE LIGNE)
                  // ————————————————
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Vous avez déjà un compte ? ",
                        style: TextStyle(fontSize: 13, color: cs.onBackground),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginPage()),
                          );
                        },
                        child: Text(
                          "Connectez-vous ici",
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
