import 'package:flutter/material.dart';
import '../models/day_record.dart';

class DayDetailsScreen extends StatelessWidget {
  final DayRecord day;
  const DayDetailsScreen({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Coupes du ${day.date}')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: day.cuts.isEmpty
                  ? const Center(child: Text('Aucune coupe'))
                  : ListView.separated(
                      itemCount: day.cuts.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (ctx, i) {
                        final c = day.cuts[i];
                        final my = (c.price * c.percent) ~/ 100;
                        final boss = c.price - my;
                        return ListTile(
                          title: Text('${c.service.isNotEmpty ? c.service + ' - ' : ''}${c.price} DA'),
                          subtitle: Text('Moi : $my DA  |  Patron : $boss DA'),
                          trailing: Text('${c.time.hour.toString().padLeft(2,'0')}:${c.time.minute.toString().padLeft(2,'0')}'),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Align(alignment: Alignment.centerLeft, child: Text('Total : ${day.total} DA', style: const TextStyle(fontWeight: FontWeight.w600))),
            Align(alignment: Alignment.centerLeft, child: Text('Ma part : ${day.myShare} DA')),
            Align(alignment: Alignment.centerLeft, child: Text('Patron : ${day.bossShare} DA')),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
