class Cut {
  final int price; // prix en DA (entier)
  final int percent; // pourcentage (ex: 50)
  final String service; // optionnel (ex: "Dégradé")
  final DateTime time;

  Cut({
    required this.price,
    required this.percent,
    this.service = '',
    DateTime? time,
  }) : time = time ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'price': price,
        'percent': percent,
        'service': service,
        'time': time.toIso8601String(),
      };

  factory Cut.fromJson(Map<String, dynamic> j) => Cut(
        price: j['price'] as int,
        percent: j['percent'] as int,
        service: (j['service'] ?? '') as String,
        time: DateTime.parse(j['time'] as String),
      );
}
