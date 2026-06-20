import 'package:aoun/features/maps/domain/entities/nearby_place.dart';

class NearbyPlaceModel extends NearbyPlace {
  const NearbyPlaceModel({
    required super.id,
    required super.name,
    required super.latitude,
    required super.longitude,
    required super.type,
    super.distance,
  });

  factory NearbyPlaceModel.fromJson(Map<String, dynamic> json, String type) {
    final id = json['id']?.toString() ?? '';
    final tags = json['tags'] as Map<String, dynamic>? ?? {};
    final name = tags['name'] as String? ??
        tags['name:en'] as String? ??
        (type == 'hospital' ? 'Hospital' : 'NGO / Foundation');

    double lat = 0.0;
    double lon = 0.0;
    if (json.containsKey('lat') && json.containsKey('lon')) {
      lat = double.tryParse(json['lat']?.toString() ?? '0.0') ?? 0.0;
      lon = double.tryParse(json['lon']?.toString() ?? '0.0') ?? 0.0;
    } else if (json.containsKey('center') && json['center'] is Map) {
      final center = json['center'] as Map<String, dynamic>;
      lat = double.tryParse(center['lat']?.toString() ?? '0.0') ?? 0.0;
      lon = double.tryParse(center['lon']?.toString() ?? '0.0') ?? 0.0;
    }

    return NearbyPlaceModel(
      id: id,
      name: name,
      latitude: lat,
      longitude: lon,
      type: type,
    );
  }
}
