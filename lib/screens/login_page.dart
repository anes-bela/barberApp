import 'package:flutter/material.dart';
import 'package:gestion_jr/screens/ForgotPassword_page.dart';
import '../main.dart';
import 'signup_page.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';



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
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isMediumScreen = size.width >= 600 && size.width < 900;

    // Calcul des paddings adaptatifs
    final horizontalPadding =
        isSmallScreen ? 24.0 : (isMediumScreen ? 48.0 : 80.0);
    final maxWidth =
        isSmallScreen ? double.infinity : (isMediumScreen ? 500.0 : 450.0);

    return Scaffold(
      backgroundColor: cs.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: isSmallScreen ? 24.0 : 40.0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // TITRE
                      Text(
                        "Se connecter",
                        style: TextStyle(
                          fontSize: isSmallScreen ? 24 : 28,
                          fontWeight: FontWeight.bold,
                          color: cs.onBackground,
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 8 : 12),

                      // SOUS-TITRE
                      Text(
                        "Entrez votre e-mail et mot de passe pour accéder à votre compte.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 13 : 14,
                          color: cs.onBackground.withOpacity(0.7),
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 30 : 40),

                      // EMAIL
                      TextFormField(
                        controller: _emailController,
                        style: TextStyle(
                          color: cs.onSurface,
                          fontSize: isSmallScreen ? 14 : 15,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: cs.surface,
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: cs.primary,
                            size: isSmallScreen ? 20 : 24,
                          ),
                          labelText: "Adresse e-mail",
                          labelStyle: TextStyle(
                            color: cs.onSurface.withOpacity(0.7),
                            fontSize: isSmallScreen ? 13 : 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: isSmallScreen ? 16 : 18,
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

                      SizedBox(height: isSmallScreen ? 16 : 20),

                      // PASSWORD
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: TextStyle(
                          color: cs.onSurface,
                          fontSize: isSmallScreen ? 14 : 15,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: cs.surface,
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: cs.primary,
                            size: isSmallScreen ? 20 : 24,
                          ),
                          labelText: "Mot de passe",
                          labelStyle: TextStyle(
                            color: cs.onSurface.withOpacity(0.7),
                            fontSize: isSmallScreen ? 13 : 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: isSmallScreen ? 16 : 18,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: cs.onSurface.withOpacity(0.6),
                              size: isSmallScreen ? 20 : 24,
                            ),
                            onPressed: () {
                              setState(
                                  () => _obscurePassword = !_obscurePassword);
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 8 : 10),

                      // REMEMBER + FORGOT PASSWORD
                      isSmallScreen
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                    Expanded(
                                      child: Text(
                                        "Se souvenir de moi",
                                        style: TextStyle(
                                          color: cs.onBackground,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const ForgotPasswordPage()),
                                      );
                                    },
                                    child: Text(
                                      "Mot de passe oublié ?",
                                      style: TextStyle(
                                        color: cs.primary,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Row(
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
                                      style: TextStyle(
                                        color: cs.onBackground,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const ForgotPasswordPage()),
                                    );
                                  },
                                  child: Text(
                                    "Mot de passe oublié ?",
                                    style: TextStyle(
                                      color: cs.primary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                      SizedBox(height: isSmallScreen ? 16 : 20),

                      // LOGIN BUTTON
                      ElevatedButton(
                       onPressed: () async {
  if (_formKey.currentState!.validate()) {
    try {
      // Connexion Firebase
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Enregistrer dans AppState
      Provider.of<AppState>(context, listen: false).login(
        name: userCredential.user!.email!.split('@')[0],
        email: userCredential.user!.email!,
      );

      // Aller à l'écran principal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScaffold()),
      );

    } on FirebaseAuthException catch (e) {
     
    }
  }
},


                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(
                            double.infinity,
                            isSmallScreen ? 48 : 54,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          "Se connecter",
                          style: TextStyle(fontSize: isSmallScreen ? 15 : 16),
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 12 : 16),

                      // CONTINUE WITHOUT ACCOUNT
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const MainScaffold()),
                          );
                        },
                        child: Text(
                          "Continuer sans compte",
                          style: TextStyle(
                            color: cs.primary,
                            fontSize: isSmallScreen ? 13 : 14,
                          ),
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 16 : 20),

                      // SIGNUP LINE
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            "Vous n'avez pas de compte ? ",
                            style: TextStyle(
                              color: cs.onBackground,
                              fontSize: isSmallScreen ? 13 : 14,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const SignupPage()),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              "Inscrivez-vous ici",
                              style: TextStyle(
                                color: cs.primary,
                                fontSize: isSmallScreen ? 13 : 14,
                              ),
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
        ),
      ),
    );
  }
}
