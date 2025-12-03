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
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
    backgroundColor: cs.background,
    appBar: AppBar(
    leading: BackButton(color: cs.onBackground),
    backgroundColor: Colors.transparent,
    elevation: 0,
    ),
    body: Padding(
    padding: const EdgeInsets.all(24.0),
    child: SingleChildScrollView(
    child: Form(
    key: _emailKey,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    "Mot de passe oublié",
    style: TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: cs.onBackground,
    ),
    ),
    const SizedBox(height: 8),
    Text(
    "Entrez votre adresse e-mail pour recevoir un code de vérification.",
    textAlign: TextAlign.center,
    style: TextStyle(
    fontSize: 13,
    color: cs.onBackground.withOpacity(0.7),
    ),
    ),
    const SizedBox(height: 30),
    TextFormField(
    controller: emailController,
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
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return "Entrez une adresse e-mail valide";
    }
    return null;
    },
    ),
    const SizedBox(height: 25),
    ElevatedButton(
    onPressed: () {
    if (_emailKey.currentState!.validate()) {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const OTPVerificationPage()),
    );
    }
    },
    style: ElevatedButton.styleFrom(
    minimumSize: const Size(double.infinity, 50),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30),
    ),
    ),
    child: const Text("Continuer", style: TextStyle(fontSize: 15)),
    ),
    ],
    ),
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

  bool isOtpComplete() => otp.every((c) => c.text.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
    backgroundColor: cs.background,
    appBar: AppBar(
    leading: BackButton(color: cs.onBackground),
    backgroundColor: Colors.transparent,
    elevation: 0,
    ),
    body: Padding(
    padding: const EdgeInsets.all(24.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    Text(
    "Vérifiez votre code",
    style: TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: cs.onBackground,
    ),
    ),
    const SizedBox(height: 8),
    Text(
    "Entrez le code envoyé à votre e-mail.",
    textAlign: TextAlign.center,
    style: TextStyle(
    fontSize: 13,
    color: cs.onBackground.withOpacity(0.7),
    ),
    ),
    const SizedBox(height: 30),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: List.generate(4, (index) {
    return SizedBox(
    width: 60,
    height: 60,
    child: TextFormField(
    controller: otp[index],
    textAlign: TextAlign.center,
    maxLength: 1,
    keyboardType: TextInputType.number,
    style: TextStyle(color: cs.onSurface, fontSize: 22),
    decoration: InputDecoration(
    filled: true,
    fillColor: cs.surface,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    counterText: "",
    ),
    ),
    );
    }),
    ),
    const SizedBox(height: 25),
    ElevatedButton(
    onPressed: () {
    if (!isOtpComplete()) {
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
    content: Text("Veuillez entrer le code complet (4 chiffres)."),
    ),
    );
    return;
    }
    Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const NewPasswordPage()),
    );
    },
    style: ElevatedButton.styleFrom(
    minimumSize: const Size(double.infinity, 50),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30),
    ),
    ),
    child: const Text("Continuer", style: TextStyle(fontSize: 15)),
    ),
    TextButton(
    onPressed: () {},
    child: Text(
    "Renvoyer le code",
    style: TextStyle(color: cs.primary, fontSize: 14),
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
  final _passwordKey = GlobalKey<FormState>();
  final TextEditingController pass = TextEditingController();
  final TextEditingController confirm = TextEditingController();
  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
    backgroundColor: cs.background,
    appBar: AppBar(
    leading: BackButton(color: cs.onBackground),
    backgroundColor: Colors.transparent,
    elevation: 0,
    ),
    body: Padding(
    padding: const EdgeInsets.all(24.0),
    child: Form(
    key: _passwordKey,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    Text(
    "Créer un nouveau mot de passe",
    style: TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: cs.onBackground,
    ),
    ),
    const SizedBox(height: 20),
    TextFormField(
    controller: pass,
    obscureText: !showPassword,
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
    icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility, color: cs.onSurface.withOpacity(0.6)),
    onPressed: () => setState(() => showPassword = !showPassword),
    ),
    ),
    validator: (value) {
    if (value == null || value.isEmpty) return "Veuillez entrer un mot de passe";
    if (value.length < 6) return "Le mot de passe doit contenir au moins 6 caractères";
    return null;
    },
    ),
    const SizedBox(height: 20),
    TextFormField(
    controller: confirm,
    obscureText: !showConfirmPassword,
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
    icon: Icon(showConfirmPassword ? Icons.visibility_off : Icons.visibility, color: cs.onSurface.withOpacity(0.6)),
    onPressed: () => setState(() => showConfirmPassword = !showConfirmPassword),
    ),
    ),
    validator: (value) {
    if (value == null || value.isEmpty) return "Veuillez confirmer votre mot de passe";
    if (value != pass.text) return "Les mots de passe ne correspondent pas";
    return null;
    },
    ),
    const SizedBox(height: 30),
    ElevatedButton(
    onPressed: () {
    if (_passwordKey.currentState!.validate()) {
    Navigator.popUntil(context, (route) => route.isFirst);
    }
    },
    style: ElevatedButton.styleFrom(
    minimumSize: const Size(double.infinity, 50),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30),
    ),
    ),
    child: const Text("Continuer", style: TextStyle(fontSize: 15)),
    ),
    ],
    ),
    ),
    ),
    );
  }
}
