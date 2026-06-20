import 'package:aoun/core/error/either.dart';
import 'package:aoun/core/error/failures.dart';
import 'package:aoun/features/maps/data/datasources/maps_remote_data_source.dart';
import 'package:aoun/features/maps/domain/entities/map_place.dart';
import 'package:aoun/features/maps/domain/entities/nearby_place.dart';
import 'package:aoun/features/maps/domain/entities/donation_location.dart';
import 'package:aoun/features/maps/domain/entities/route_entity.dart';
import 'package:aoun/features/maps/domain/repositories/maps_repository.dart';
import 'package:geolocator/geolocator.dart';

class MapsRepositoryImpl implements MapsRepository {
  final MapsRemoteDataSource remoteDataSource;

  MapsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Position>> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const Left(
          ServerFailure('Location services are disabled. Please enable GPS.'),
        );
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return const Left(ServerFailure('Location permissions are denied.'));
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return const Left(
          ServerFailure(
            'Location permissions are permanently denied. We cannot request permissions.',
          ),
        );
      }

      final position = await Geolocator.getCurrentPosition();
      return Right(position);
    } catch (e) {
      return Left(ServerFailure('Failed to get location: $e'));
    }
  }

  @override
  Future<Either<Failure, List<NearbyPlace>>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    required String type,
  }) async {
    try {
      final list = await remoteDataSource.getNearbyPlaces(
        latitude,
        longitude,
        type,
      );

      final List<NearbyPlace> updatedList = list.map((place) {
        final dist = Geolocator.distanceBetween(
              latitude,
              longitude,
              place.latitude,
              place.longitude,
            ) /
            1000.0;
        return place.copyWith(distance: dist);
      }).toList();

      updatedList.sort(
        (a, b) => (a.distance ?? 0.0).compareTo(b.distance ?? 0.0),
      );

      return Right(updatedList);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MapPlace>>> searchPlaces(String query) async {
    try {
      final list = await remoteDataSource.searchPlaces(query);
      return Right(list);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RouteEntity>> getRoute({
    required double startLat,
    required double startLon,
    required double endLat,
    required double endLon,
  }) async {
    try {
      final route = await remoteDataSource.getRoute(
        startLat,
        startLon,
        endLat,
        endLon,
      );
      return Right(route);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DonationLocation>>> getRecommendedDonations({
    required double userLat,
    required double userLon,
    String? preferredCategory,
  }) async {
    try {
      final List<Map<String, dynamic>> rawMocks = [
        {
          'id': 'don_1',
          'title': 'Urgent Blood Donation Required',
          'description':
              'A patient in critical condition needs AB- blood donation at the local health clinic.',
          'category': 'Blood',
          'urgency': 'high',
          'latOffset': 0.008,
          'lonOffset': 0.012,
          'targetAmount': 5.0,
          'donatedAmount': 2.0,
          'remainingAmount': 3.0,
        },
        {
          'id': 'don_2',
          'title': 'Winter Clothing Campaign',
          'description':
              'Collecting warm winter clothes, blankets, and coats for displaced families.',
          'category': 'Clothes',
          'urgency': 'medium',
          'latOffset': -0.015,
          'lonOffset': 0.022,
          'targetAmount': 500.0,
          'donatedAmount': 350.0,
          'remainingAmount': 150.0,
        },
        {
          'id': 'don_3',
          'title': 'Emergency Food Basket Distribution',
          'description':
              'Providing monthly food supplies to underprivileged low-income households.',
          'category': 'Food',
          'urgency': 'high',
          'latOffset': -0.005,
          'lonOffset': -0.008,
          'targetAmount': 1000.0,
          'donatedAmount': 600.0,
          'remainingAmount': 400.0,
        },
        {
          'id': 'don_4',
          'title': 'Funding Pediatric Heart Surgery',
          'description':
              'Sponsor surgery expenses for a young child suffering from congenital heart disease.',
          'category': 'Money',
          'urgency': 'high',
          'latOffset': 0.018,
          'lonOffset': -0.014,
          'targetAmount': 20000.0,
          'donatedAmount': 14000.0,
          'remainingAmount': 6000.0,
        },
        {
          'id': 'don_5',
          'title': 'Primary School Textbook Drive',
          'description':
              'Donate books and reference guides to restock the local community educational library.',
          'category': 'Books',
          'urgency': 'low',
          'latOffset': 0.022,
          'lonOffset': 0.025,
          'targetAmount': 300.0,
          'donatedAmount': 280.0,
          'remainingAmount': 20.0,
        },
        {
          'id': 'don_6',
          'title': 'Medical Equipment for Free Clinic',
          'description':
              'Funding purchase of oxygen concentrators, nebulizers, and primary aid diagnostic tools.',
          'category': 'Medical Supplies',
          'urgency': 'medium',
          'latOffset': -0.025,
          'lonOffset': -0.018,
          'targetAmount': 5000.0,
          'donatedAmount': 1200.0,
          'remainingAmount': 3800.0,
        },
      ];

      final List<DonationLocation> locations = [];

      for (var mock in rawMocks) {
        final double lat = userLat + (mock['latOffset'] as double);
        final double lon = userLon + (mock['lonOffset'] as double);

        final double distance =
            Geolocator.distanceBetween(userLat, userLon, lat, lon) / 1000.0;

        final double distanceScore = (1.0 - (distance / 10.0)).clamp(0.0, 1.0);

        final bool categoryMatches = preferredCategory == null ||
            mock['category'].toString().toLowerCase() ==
                preferredCategory.toLowerCase();
        final double categoryScore = categoryMatches ? 1.0 : 0.0;

        final String urgency = mock['urgency'].toString().toLowerCase();
        final double urgencyScore = urgency == 'high'
            ? 1.0
            : (urgency == 'medium' ? 0.6 : 0.2);

        final double finalScore = (distanceScore * 0.4) +
            (categoryScore * 0.3) +
            (urgencyScore * 0.3);

        locations.add(
          DonationLocation(
            id: mock['id'] as String,
            title: mock['title'] as String,
            description: mock['description'] as String,
            category: mock['category'] as String,
            urgency: mock['urgency'] as String,
            latitude: lat,
            longitude: lon,
            targetAmount: (mock['targetAmount'] as num).toDouble(),
            donatedAmount: (mock['donatedAmount'] as num).toDouble(),
            remainingAmount: (mock['remainingAmount'] as num).toDouble(),
            distance: distance,
            score: finalScore,
          ),
        );
      }

      locations.sort((a, b) => (b.score ?? 0.0).compareTo(a.score ?? 0.0));

      return Right(locations);
    } catch (e) {
      return Left(ServerFailure('Failed to load recommended donations: $e'));
    }
  }
}
