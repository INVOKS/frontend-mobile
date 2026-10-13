class Room {
  const Room({
    required this.id,
    required this.name,
    required this.capacityMin,
    required this.capacityMax,
    required this.imagePath,
  });

  final String id;
  final String name;
  final int capacityMin;
  final int capacityMax;
  final String imagePath;

  String get capacityLabel => 'Kapasitas $capacityMin - $capacityMax orang';
}
