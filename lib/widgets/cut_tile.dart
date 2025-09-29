import 'package:flutter/material.dart';
import '../models/cut.dart';

class CutTile extends StatelessWidget {
  final Cut cut;
  final VoidCallback? onDelete;

  const CutTile({super.key, required this.cut, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final hh = cut.time.hour.toString().padLeft(2, '0');
    final mm = cut.time.minute.toString().padLeft(2, '0');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: ListTile(
        title: Text('${cut.service.isNotEmpty ? '${cut.service} - ' : ''}${cut.price} DA'),
        subtitle: Text('Part: ${cut.percent}%'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$hh:$mm'),
            if (onDelete != null) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              )
            ]
          ],
        ),
      ),
    );
  }
}
