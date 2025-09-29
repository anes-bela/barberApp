import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'day_details_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Text('Historique', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 10),
          Expanded(
            child: appState.history.isEmpty
                ? const Center(child: Text('Aucun jour sauvegardé'))
                : ListView.separated(
                    itemCount: appState.history.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (ctx, i) {
                      final d = appState.history[i];
                      return ListTile(
                        title: Text('${d.date} - Total: ${d.total} DA'),
                        subtitle: Text('Moi: ${d.myShare} DA | Patron: ${d.bossShare} DA'),
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DayDetailsScreen(day: d))),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
