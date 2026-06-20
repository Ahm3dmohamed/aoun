import 'package:aoun/features/maps/domain/entities/route_entity.dart';
import 'package:latlong2/latlong.dart';

class RouteModel extends RouteEntity {
  const RouteModel({
    required super.points,
    required super.distance,
    required super.duration,
  });

  factory RouteModel.fromOsrm(Map<String, dynamic> json) {
    final routes = json['routes'] as List? ?? [];
    if (routes.isEmpty) {
      throw Exception('No route found');
    }

    final route = routes.first as Map<String, dynamic>;
    final geometry = route['geometry'] as Map<String, dynamic>? ?? {};
    final coordinates = geometry['coordinates'] as List? ?? [];

    final List<LatLng> points = coordinates.map((coord) {
      final list = coord as List;
      final lon = double.tryParse(list[0].toString()) ?? 0.0;
      final lat = double.tryParse(list[1].toString()) ?? 0.0;
      return LatLng(lat, lon);
    }).toList();

    final distanceMeters =
        double.tryParse(route['distance']?.toString() ?? '0.0') ?? 0.0;
    final durationSeconds =
        double.tryParse(route['duration']?.toString() ?? '0.0') ?? 0.0;

    return RouteModel(
      points: points,
      distance: distanceMeters / 1000.0,
      duration: durationSeconds / 60.0,
    );
  }

  factory RouteModel.fromOpenRouteService(Map<String, dynamic> json) {
    final features = json['features'] as List? ?? [];
    if (features.isEmpty) {
      throw Exception('No route found');
    }

    final feature = features.first as Map<String, dynamic>;
    final geometry = feature['geometry'] as Map<String, dynamic>? ?? {};
    final coordinates = geometry['coordinates'] as List? ?? [];

    final List<LatLng> points = coordinates.map((coord) {
      final list = coord as List;
      final lon = double.tryParse(list[0].toString()) ?? 0.0;
      final lat = double.tryParse(list[1].toString()) ?? 0.0;
      return LatLng(lat, lon);
    }).toList();

    final properties = feature['properties'] as Map<String, dynamic>? ?? {};
    final summary = properties['summary'] as Map<String, dynamic>? ?? {};
    final distanceMeters =
        double.tryParse(summary['distance']?.toString() ?? '0.0') ?? 0.0;
    final durationSeconds =
        double.tryParse(summary['duration']?.toString() ?? '0.0') ?? 0.0;

    return RouteModel(
      points: points,
      distance: distanceMeters / 1000.0,
      duration: durationSeconds / 60.0,
    );
  }
}
