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

  // Déco dynamique avec ColorScheme
  InputDecoration _inputDecoration(String label, ColorScheme cs) {
    return InputDecoration(
      filled: true,
      fillColor: cs.surface,
      labelText: label,
      labelStyle: TextStyle(color: cs.onSurface.withOpacity(0.7)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: cs.primary.withOpacity(0.6),
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: cs.primary,
          width: 2,
        ),
      ),
    );
  }

  Widget _buildPriceField(AppState appState, ColorScheme cs) {
    return TextFormField(
      controller: _priceCtrl,
      keyboardType: TextInputType.number,
      decoration: _inputDecoration('Prix personnalisé (DA)', cs),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Entrer un prix';
        if (int.tryParse(v) == null) return 'Prix invalide';
        return null;
      },
      onChanged: (_) => setState(() {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final cs = Theme.of(context).colorScheme;
    int price = int.tryParse(_priceCtrl.text) ?? 0;
    int percent = int.tryParse(_percentCtrl.text) ?? appState.defaultPercent;
    int my = (price * percent) ~/ 100;
    int boss = price - my;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une coupe'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // SECTION SERVICES PRÉDÉFINIS
                  if (appState.predefinedServices.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Services rapides',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: appState.predefinedServices.map((service) {
                            final isSelected =
                                _priceCtrl.text == service.price.toString() &&
                                    _serviceCtrl.text == service.name;

                            final isDark =
                                Theme.of(context).brightness == Brightness.dark;

                            return FilterChip(
                              label:
                                  Text('${service.name} - ${service.price} DA'),

                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  _priceCtrl.text = service.price.toString();
                                  _serviceCtrl.text = service.name;
                                });
                              },

                              // Couleur du chip quand NON sélectionné
                              backgroundColor:
                                  isDark ? Colors.grey[800] : Colors.grey[200],

                              // Couleur du chip quand sélectionné
                              selectedColor: cs.primary,

                              checkmarkColor: Colors.white,

                              // 🔥 CORRECTION : texte adapté au dark mode
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : (isDark ? Colors.white : Colors.black),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Ou prix personnalisé :',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),

                  // CHAMP PRIX
                  _buildPriceField(appState, cs),
                  const SizedBox(height: 12),

                  // CHAMP POURCENTAGE
                  TextFormField(
                    controller: _percentCtrl,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration(
                        'Mon % (par défaut ${appState.defaultPercent}%)', cs),
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

                  // CHAMP SERVICE
                  TextFormField(
                    controller: _serviceCtrl,
                    decoration: _inputDecoration(
                        'Service (optionnel, ex: Dégradé + barbe)', cs),
                  ),
                  const SizedBox(height: 18),

                  // Carte des calculs
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
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
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
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
                      side: BorderSide(color: cs.primary),
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
