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
      appBar: AppBar(title: const Text('Ajouter une coupe')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _priceCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Prix de la coupe (DA)'),
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
                decoration: InputDecoration(labelText: 'Mon % (par défaut ${appState.defaultPercent}%)'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Entrer un pourcentage';
                  final p = int.tryParse(v);
                  if (p == null || p < 0 || p > 100) return 'Doit être entre 0 et 100';
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _serviceCtrl,
                decoration: const InputDecoration(labelText: 'Service (optionnel, ex: Dégradé + barbe)'),
              ),
              const SizedBox(height: 18),
              Text('Ma part : $my DA', style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text('Patron : $boss DA', style: const TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  final p = int.parse(_priceCtrl.text);
                  final pct = int.parse(_percentCtrl.text);
                  final svc = _serviceCtrl.text.trim();
                  appState.addCut(price: p, percent: pct, service: svc);
                  Navigator.of(context).pop();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  child: Text('Enregistrer', style: TextStyle(fontSize: 16)),
                ),
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text('Annuler'),
                ),
                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
