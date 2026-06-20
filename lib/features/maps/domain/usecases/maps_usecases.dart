import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/failures.dart';
import 'package:aoun/features/maps/domain/entities/map_place.dart';
import 'package:aoun/features/maps/domain/entities/nearby_place.dart';
import 'package:aoun/features/maps/domain/entities/donation_location.dart';
import 'package:aoun/features/maps/domain/entities/route_entity.dart';
import 'package:aoun/features/maps/domain/repositories/maps_repository.dart';
import 'package:geolocator/geolocator.dart';

class GetCurrentLocationUseCase {
  final MapsRepository repository;
  GetCurrentLocationUseCase(this.repository);

  Future<Either<Failure, Position>> call() => repository.getCurrentLocation();
}

class GetNearbyPlacesUseCase {
  final MapsRepository repository;
  GetNearbyPlacesUseCase(this.repository);

  Future<Either<Failure, List<NearbyPlace>>> call({
    required double latitude,
    required double longitude,
    required String type,
  }) =>
      repository.getNearbyPlaces(
        latitude: latitude,
        longitude: longitude,
        type: type,
      );
}

class SearchPlacesUseCase {
  final MapsRepository repository;
  SearchPlacesUseCase(this.repository);

  Future<Either<Failure, List<MapPlace>>> call(String query) =>
      repository.searchPlaces(query);
}

class GetRouteUseCase {
  final MapsRepository repository;
  GetRouteUseCase(this.repository);

  Future<Either<Failure, RouteEntity>> call({
    required double startLat,
    required double startLon,
    required double endLat,
    required double endLon,
  }) =>
      repository.getRoute(
        startLat: startLat,
        startLon: startLon,
        endLat: endLat,
        endLon: endLon,
      );
}

class GetRecommendedDonationsUseCase {
  final MapsRepository repository;
  GetRecommendedDonationsUseCase(this.repository);

  Future<Either<Failure, List<DonationLocation>>> call({
    required double userLat,
    required double userLon,
    String? preferredCategory,
  }) =>
      repository.getRecommendedDonations(
        userLat: userLat,
        userLon: userLon,
        preferredCategory: preferredCategory,
      );
}
