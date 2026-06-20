import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/failures.dart';
import 'package:aoun/features/maps/domain/entities/map_place.dart';
import 'package:aoun/features/maps/domain/entities/nearby_place.dart';
import 'package:aoun/features/maps/domain/entities/donation_location.dart';
import 'package:aoun/features/maps/domain/entities/route_entity.dart';
import 'package:geolocator/geolocator.dart';

abstract class MapsRepository {
  Future<Either<Failure, Position>> getCurrentLocation();
  Future<Either<Failure, List<NearbyPlace>>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    required String type, // 'hospital' or 'foundation'
  });
  Future<Either<Failure, List<MapPlace>>> searchPlaces(String query);
  Future<Either<Failure, RouteEntity>> getRoute({
    required double startLat,
    required double startLon,
    required double endLat,
    required double endLon,
  });
  Future<Either<Failure, List<DonationLocation>>> getRecommendedDonations({
    required double userLat,
    required double userLon,
    String? preferredCategory,
  });
}
