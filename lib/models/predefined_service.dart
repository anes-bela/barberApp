class PredefinedService {
  final String id;
  final String name;
  final int price;
  
  PredefinedService({
    String? id,
    required this.name,
    required this.price,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
  };
  
  factory PredefinedService.fromJson(Map<String, dynamic> json) => PredefinedService(
    id: json['id'] as String,
    name: json['name'] as String,
    price: json['price'] as int,
  );
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PredefinedService &&
          runtimeType == other.runtimeType &&
          id == other.id;
  
  @override
  int get hashCode => id.hashCode;
}