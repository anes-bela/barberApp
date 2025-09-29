import 'cut.dart';

class DayRecord {
  final DateTime date; // Utilisation de DateTime
  final List<Cut> cuts;

  DayRecord({required this.date, List<Cut>? cuts}) : cuts = cuts ?? [];

  int get total => cuts.fold(0, (s, c) => s + c.price);

  int get myShare =>
      cuts.fold(0, (s, c) => s + ((c.price * c.percent) ~/ 100));

  int get bossShare => total - myShare;

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(), // conversion en String pour le stockage
        'cuts': cuts.map((c) => c.toJson()).toList(),
      };

  factory DayRecord.fromJson(Map<String, dynamic> j) => DayRecord(
        date: DateTime.parse(j['date'] as String), // retransforme en DateTime
        cuts: (j['cuts'] as List<dynamic>)
            .map((e) => Cut.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );
}
