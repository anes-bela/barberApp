import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final bool darkMode = appState.isDarkMode;
    final bool isConnected =
        appState.userName != null && appState.userEmail != null;
    final bool guestMode = appState.isGuestMode;
    final Color mainGreen = const Color(0xFF4CAF50);

    final backgroundColor = darkMode ? Colors.black : Colors.white;
    final textColor = darkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: darkMode ? Colors.grey[900] : Colors.white,
        title: Text(
          'Profil',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: textColor),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 10),

          // --- Avatar + titre principal ---
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor:
                  darkMode ? Colors.grey[800] : Colors.grey[300],
                  child: const Icon(Icons.person, size: 60, color: Colors.grey),
                ),
                const SizedBox(height: 10),

                // --- États selon la connexion ---
                if (isConnected) ...[
                  Text(
                    appState.userName!,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    appState.userEmail!,
                    style: TextStyle(
                      color: darkMode ? Colors.grey[400] : Colors.grey[700],
                    ),
                  ),
                ] else if (guestMode) ...[
                  Text(
                    "Mode invité activé",
                    style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ] else ...[
                  Text(
                    "Vous n'êtes pas connecté",
                    style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      //backgroundColor: mainGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Se connecter / Créer un compte",
                      //style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 40),

          // --- Infos si connecté ---
          if (isConnected) ...[
            ListTile(
              leading: Icon(Icons.person_outline, color: mainGreen),
              title: Text('Nom complet', style: TextStyle(color: textColor)),
              subtitle: Text(
                appState.userName!,
                style: TextStyle(
                  color: darkMode ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.email_outlined, color: mainGreen),
              title: Text('Adresse e-mail', style: TextStyle(color: textColor)),
              subtitle: Text(
                appState.userEmail!,
                style: TextStyle(
                  color: darkMode ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
            ),
            const Divider(),
          ],

          // --- Déconnexion ---
          if (isConnected || guestMode) ...[
            ListTile(
              leading: Icon(Icons.logout, color: mainGreen),
              title: Text('Se déconnecter', style: TextStyle(color: textColor)),
              onTap: () {
                appState.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
            ),
            const Divider(),
          ],

          // --- Mode sombre ---
          SwitchListTile(
            value: darkMode,
            onChanged: (value) {
              appState.toggleDarkMode(value);
            },
            activeColor: mainGreen,
            title: Text('Mode sombre', style: TextStyle(color: textColor)),
            secondary: Icon(Icons.dark_mode, color: mainGreen),
          ),
        ],
      ),
    );
  }
}



