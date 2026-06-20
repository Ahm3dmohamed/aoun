import 'package:latlong2/latlong.dart';

class RouteEntity {
  final List<LatLng> points;
  final double distance; // in km
  final double duration; // in minutes

  const RouteEntity({
    required this.points,
    required this.distance,
    required this.duration,
  });
}
