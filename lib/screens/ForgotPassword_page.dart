import 'package:flutter/material.dart';


// ------------------------------------------------------------
//  PAGE 1 : MOT DE PASSE OUBLIÉ (VALIDATION EMAIL)
// ------------------------------------------------------------

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final _emailKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: isDark ? Colors.white : Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _emailKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Mot de passe oublié",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Entrez votre adresse email pour recevoir un code de vérification.",
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),

              const SizedBox(height: 30),

              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Adresse email",
                  prefixIcon: const Icon(Icons.email_outlined),
                  filled: true,
                  fillColor: isDark ? Colors.grey[900] : Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),

                // 🔥 VALIDATION EMAIL
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer une adresse email";
                  }
                  if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return "Adresse email invalide";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    if (_emailKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OTPVerificationPage(),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Continuer",
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// ------------------------------------------------------------
//  PAGE 2 : VERIFICATION OTP (4 CHIFFRES OBLIGATOIRES)
// ------------------------------------------------------------

class OTPVerificationPage extends StatefulWidget {
  const OTPVerificationPage({super.key});

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final List<TextEditingController> otp = List.generate(4, (i) => TextEditingController());

  bool isOtpComplete() {
    return otp.every((c) => c.text.isNotEmpty);
  }

  String getOtpCode() {
    return otp.map((c) => c.text).join();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: isDark ? Colors.white : Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Vérifiez votre code",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Entrez le code envoyé à votre email.",
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) {
                return Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[900] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: otp[index],
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 22,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    decoration: const InputDecoration(
                      counterText: "",
                      border: InputBorder.none,
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  if (!isOtpComplete()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Veuillez entrer le code complet (4 chiffres).")),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NewPasswordPage(),
                    ),
                  );
                },
                child: const Text("Continuer",
                    style: TextStyle(fontSize: 17, color: Colors.white)),
              ),
            ),

            const SizedBox(height: 10),

            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "Renvoyer le code",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// ------------------------------------------------------------
//  PAGE 3 : NOUVEAU MOT DE PASSE (VALIDATION)
// ------------------------------------------------------------

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  bool showPassword = false;
  bool showConfirmPassword = false;

  final _passwordKey = GlobalKey<FormState>();
  final TextEditingController pass = TextEditingController();
  final TextEditingController confirm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: isDark ? Colors.white : Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Form(
          key: _passwordKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Créer un nouveau mot de passe",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),

              const SizedBox(height: 20),

              // Mot de passe
              TextFormField(
                controller: pass,
                obscureText: !showPassword,
                decoration: InputDecoration(
                  hintText: "Mot de passe",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => showPassword = !showPassword);
                    },
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.grey[900] : Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),

                // VALIDATION
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer un mot de passe";
                  }
                  if (value.length < 6) {
                    return "Le mot de passe doit contenir au moins 6 caractères";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Confirmation
              TextFormField(
                controller: confirm,
                obscureText: !showConfirmPassword,
                decoration: InputDecoration(
                  hintText: "Confirmer le mot de passe",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      showConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => showConfirmPassword = !showConfirmPassword);
                    },
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.grey[900] : Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),

                // VALIDATION
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez confirmer votre mot de passe";
                  }
                  if (value != pass.text) {
                    return "Les mots de passe ne correspondent pas";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    if (_passwordKey.currentState!.validate()) {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    }
                  },
                  child: const Text(
                    "Continuer",
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
