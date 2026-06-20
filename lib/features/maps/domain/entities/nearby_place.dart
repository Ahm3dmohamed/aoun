class NearbyPlace {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String type; // 'hospital' or 'foundation'
  final double? distance; // distance in km from user

  const NearbyPlace({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.type,
    this.distance,
  });

  NearbyPlace copyWith({
    String? id,
    String? name,
    double? latitude,
    double? longitude,
    String? type,
    double? distance,
  }) {
    return NearbyPlace(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      type: type ?? this.type,
      distance: distance ?? this.distance,
    );
  }
}
