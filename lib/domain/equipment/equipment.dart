class Equipment {
  final String id;
  final String name;
  final String? brand;
  final String? model;
  final String? serial;
  final String? location;
  final String? status;

  const Equipment({
    required this.id,
    required this.name,
    this.brand,
    this.model,
    this.serial,
    this.location,
    this.status,
  });

  factory Equipment.fromMap(Map<String, dynamic> map) {
    return Equipment(
      id: map['id'] as String,
      name: map['name'] as String,
      brand: map['brand'] as String?,
      model: map['model'] as String?,
      serial: map['serial'] as String?,
      location: map['location'] as String?,
      status: map['status'] as String?,
    );
  }
}