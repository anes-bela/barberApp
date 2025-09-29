import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _percentCtrl;
  late int _historyLimit;

  @override
  void initState() {
    super.initState();
    final s = Provider.of<AppState>(context, listen: false);
    _percentCtrl = TextEditingController(text: s.defaultPercent.toString());
    _historyLimit = s.historyLimit;
  }

  @override
  void dispose() {
    _percentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Paramètres', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          const Text('Pourcentage par défaut'),
          const SizedBox(height: 8),
          TextField(
            controller: _percentCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(suffixText: '%'),
          ),
          const SizedBox(height: 16),
          const Text('Historique sauvegardé (jours)'),
          const SizedBox(height: 8),
          DropdownButton<int>(
            value: _historyLimit,
            items: [3, 7, 30].map((e) => DropdownMenuItem(child: Text('$e jours'), value: e)).toList(),
            onChanged: (v) {
              if (v == null) return;
              setState(() => _historyLimit = v);
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              final p = int.tryParse(_percentCtrl.text) ?? appState.defaultPercent;
              appState.updateSettings(defaultPercent: p, historyLimit: _historyLimit);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Paramètres sauvegardés')));
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text('Sauvegarder'),
            ),
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(44), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          ),
        ],
      ),
    );
  }
}
