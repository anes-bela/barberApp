import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late double _selectedPercent;
  late int _historyLimit;

  @override
  void initState() {
    super.initState();
    final s = Provider.of<AppState>(context, listen: false);
    _selectedPercent = s.defaultPercent.toDouble();
    _historyLimit = s.historyLimit;
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final int percent = _selectedPercent.round();

    return Scaffold(
      body: SafeArea(
        // ✅ AJOUTÉ POUR ÉVITER LES BORDUres
        child: SingleChildScrollView(
          // ✅ PERMET LE SCROLL
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PARAMÈTRES',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 24),

              // SECTION POURCENTAGE
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'POURCENTAGE PAR DÉFAUT',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // VALEUR ACTUELLE
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'VALEUR SÉLECTIONNÉE',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$percent%',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // SLIDER
                      Slider(
                        value: _selectedPercent,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        label: '$percent%',
                        activeColor: Colors.green,
                        inactiveColor: Colors.grey[300],
                        onChanged: (value) {
                          setState(() {
                            _selectedPercent = value;
                          });
                        },
                      ),

                      // ÉCHELLE DU SLIDER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('0%', style: TextStyle(color: Colors.grey[600])),
                          Text('50%',
                              style: TextStyle(color: Colors.grey[600])),
                          Text('100%',
                              style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // RÉPARTITION VISUELLE
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            // MA PART
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'MA PART',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$percent%',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Text(
                                    '${(2000 * percent / 100).toInt()} DA',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.green[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // SÉPARATEUR
                            Container(
                              width: 1,
                              height: 50,
                              color: Colors.grey[300],
                            ),

                            // PART PATRON
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'PATRON',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${100 - percent}%',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Text(
                                    '${(2000 * (100 - percent) / 100).toInt()} DA',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // NOTE
                      Text(
                        '* Estimation basée sur un total de 2000 DA pour illustration',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[500],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ce pourcentage sera utilisé par défaut pour les nouvelles coupes',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // SECTION HISTORIQUE
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HISTORIQUE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Jours sauvegardés',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      DropdownButton<int>(
                        isExpanded: true,
                        value: _historyLimit,
                        items: [3, 7, 30, 90]
                            .map((e) => DropdownMenuItem(
                                  child: Text('$e jours'),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (v) {
                          if (v == null) return;
                          setState(() => _historyLimit = v);
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Nombre de jours à conserver dans l\'historique',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24), // ✅ REMPLACE LE SPACER()

              // BOUTON SAUVEGARDER
              ElevatedButton(
                onPressed: () {
                  appState.updateSettings(
                      defaultPercent: percent, historyLimit: _historyLimit);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text('✅ Paramètres sauvegardés - $percent% défini'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Sauvegarder les paramètres',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 20), // ✅ ESPACE ADDITIONNEL POUR LE SCROLL
            ],
          ),
        ),
      ),
    );
  }
}
