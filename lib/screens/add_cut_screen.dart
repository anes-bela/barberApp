import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class AddCutScreen extends StatefulWidget {
  const AddCutScreen({super.key});

  @override
  State<AddCutScreen> createState() => _AddCutScreenState();
}

class _AddCutScreenState extends State<AddCutScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _priceCtrl = TextEditingController();
  final TextEditingController _percentCtrl = TextEditingController();
  final TextEditingController _serviceCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    _percentCtrl.text = appState.defaultPercent.toString();
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    _percentCtrl.dispose();
    _serviceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    int price = int.tryParse(_priceCtrl.text) ?? 0;
    int percent = int.tryParse(_percentCtrl.text) ?? appState.defaultPercent;
    int my = (price * percent) ~/ 100;
    int boss = price - my;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une coupe'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: GestureDetector(
        // ⬅️ PERMET DE CACHER LE CLAVIER EN TAPPANT AILLEURS
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              // ⬅️ SOLUTION PRINCIPALE
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _priceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Prix de la coupe (DA)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Entrer un prix';
                      if (int.tryParse(v) == null) return 'Prix invalide';
                      return null;
                    },
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _percentCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText:
                          'Mon % (par défaut ${appState.defaultPercent}%)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty)
                        return 'Entrer un pourcentage';
                      final p = int.tryParse(v);
                      if (p == null || p < 0 || p > 100)
                        return 'Doit être entre 0 et 100';
                      return null;
                    },
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _serviceCtrl,
                    decoration: InputDecoration(
                      labelText: 'Service (optionnel, ex: Dégradé + barbe)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Carte des calculs
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.green[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'RÉPARTITION',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Ma part : $my DA',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Patron : $boss DA',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // SUPPRIMER le Spacer() car incompatible avec SingleChildScrollView
                  // const Spacer(), ⬅️ À SUPPRIMER !

                  // Boutons
                  ElevatedButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;
                      final p = int.parse(_priceCtrl.text);
                      final pct = int.parse(_percentCtrl.text);
                      final svc = _serviceCtrl.text.trim();
                      appState.addCut(price: p, percent: pct, service: svc);
                      Navigator.of(context).pop();
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
                        'Enregistrer',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.green),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        'Annuler',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(
                      height: 20), // ⬅️ ESPACE ADDITIONNEL pour le scroll
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
