import 'package:aoun/features/maps/domain/entities/map_place.dart';

class MapPlaceModel extends MapPlace {
  const MapPlaceModel({
    required super.name,
    required super.displayName,
    required super.latitude,
    required super.longitude,
  });

  factory MapPlaceModel.fromJson(Map<String, dynamic> json) {
    final displayName = json['display_name'] as String? ?? '';
    final name =
        json['name'] as String? ?? (displayName.split(',').first.trim());
    final lat = double.tryParse(json['lat']?.toString() ?? '0.0') ?? 0.0;
    final lon = double.tryParse(json['lon']?.toString() ?? '0.0') ?? 0.0;

    return MapPlaceModel(
      name: name,
      displayName: displayName,
      latitude: lat,
      longitude: lon,
    );
  }
}
