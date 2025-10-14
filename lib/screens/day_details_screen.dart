import 'package:flutter/material.dart';
import '../models/day_record.dart';
import 'package:intl/intl.dart';

class DayDetailsScreen extends StatelessWidget {
  final DayRecord day;
  const DayDetailsScreen({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du ${DateFormat('dd/MM/yyyy').format(day.date)}'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: day.cuts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.content_paste,
                              size: 64, color: Colors.grey[300]),
                          SizedBox(height: 16),
                          Text(
                            'Aucune coupe cette journée',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: day.cuts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (ctx, i) {
                        final c = day.cuts[i];
                        final my = (c.price * c.percent) ~/ 100;
                        final boss = c.price - my;
                        return Card(
                          elevation: 1,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            title: Text(
                              '${c.service.isNotEmpty ? c.service : 'Coupe'} - ${c.price} DA',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              'Moi: $my DA • Patron: $boss DA',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[600]),
                            ),
                            trailing: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${c.time.hour.toString().padLeft(2, '0')}:${c.time.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),

            // RÉSUMÉ AMÉLIORÉ
            Card(
              elevation: 2,
              color: Colors.green[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'RÉSUMÉ DE LA JOURNÉE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total:',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        Text('${day.total} DA',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Ma part:', style: TextStyle(color: Colors.green)),
                        Text('${day.myShare} DA',
                            style: TextStyle(color: Colors.green)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Patron:',
                            style: TextStyle(color: Colors.grey[600])),
                        Text('${day.bossShare} DA',
                            style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
