import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'add_cut_screen.dart';
import 'day_details_screen.dart';
import '../widgets/cut_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          Text('Résultats du jour', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 18),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total encaissé : ${appState.currentDay.total} DA', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('Ma part : ${appState.currentDay.myShare} DA', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 6),
                  Text('Patron : ${appState.currentDay.bossShare} DA', style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddCutScreen())),
            icon: const Icon(Icons.add),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 6),
              child: Text('Ajouter une coupe', style: TextStyle(fontSize: 16)),
            ),
            style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), minimumSize: const Size.fromHeight(48)),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              appState.closeDay();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Journée clôturée')));
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text('Clôturer la journée', style: TextStyle(fontSize: 16)),
            ),
            style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), minimumSize: const Size.fromHeight(48)),
          ),
          const SizedBox(height: 18),
          TextButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DayDetailsScreen(day: appState.currentDay))),
            child: const Text('Voir toutes les coupes du jour'),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: appState.currentDay.cuts.isEmpty
                ? const Center(child: Text('Aucune coupe enregistrée aujourd\'hui'))
                : ListView.separated(
                    itemCount: appState.currentDay.cuts.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (ctx, i) {
                      final c = appState.currentDay.cuts[appState.currentDay.cuts.length - 1 - i]; // recent first
                      final my = (c.price * c.percent) ~/ 100;
                      final boss = c.price - my;
                      return CutTile(
                        cut: c,
                        onDelete: () {
                          // delete by index: compute original index
                          final originalIndex = appState.currentDay.cuts.length - 1 - i;
                          appState.removeCut(originalIndex);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
