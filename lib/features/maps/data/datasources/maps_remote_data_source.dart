import 'package:aoun/features/maps/data/models/map_place_model.dart';
import 'package:aoun/features/maps/data/models/nearby_place_model.dart';
import 'package:aoun/features/maps/data/models/route_model.dart';
import 'package:dio/dio.dart';

abstract class MapsRemoteDataSource {
  Future<List<MapPlaceModel>> searchPlaces(String query);
  Future<List<NearbyPlaceModel>> getNearbyPlaces(
    double lat,
    double lon,
    String type,
  );
  Future<RouteModel> getRoute(
    double startLat,
    double startLon,
    double endLat,
    double endLon,
  );
}

class MapsRemoteDataSourceImpl implements MapsRemoteDataSource {
  final Dio dio;

  MapsRemoteDataSourceImpl(this.dio);

  @override
  Future<List<MapPlaceModel>> searchPlaces(String query) async {
    try {
      final response = await dio.get(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {
          'q': query,
          'format': 'json',
          'limit': 10,
        },
        options: Options(
          headers: {
            'User-Agent': 'AounAppFlutterProductionAgent',
          },
        ),
      );

      if (response.statusCode == 200) {
        final list = response.data as List? ?? [];
        return list
            .map((item) => MapPlaceModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to search places');
      }
    } catch (e) {
      throw Exception('Error searching places: $e');
    }
  }

  @override
  Future<List<NearbyPlaceModel>> getNearbyPlaces(
    double lat,
    double lon,
    String type,
  ) async {
    try {
      final overpassTypeQuery = type == 'hospital'
          ? 'node["amenity"="hospital"](around:5000,$lat,$lon);way["amenity"="hospital"](around:5000,$lat,$lon);'
          : 'node["amenity"="social_facility"](around:5000,$lat,$lon);node["social_facility"="charity"](around:5000,$lat,$lon);node["office"="ngos"](around:5000,$lat,$lon);node["office"="ngo"](around:5000,$lat,$lon);way["amenity"="social_facility"](around:5000,$lat,$lon);way["social_facility"="charity"](around:5000,$lat,$lon);';

      final overpassQuery =
          '[out:json][timeout:25];($overpassTypeQuery);out center;';

      final response = await dio.post(
        'https://overpass-api.de/api/interpreter',
        data: overpassQuery,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final elements = data['elements'] as List? ?? [];
        return elements
            .map(
              (item) => NearbyPlaceModel.fromJson(
                item as Map<String, dynamic>,
                type,
              ),
            )
            .toList();
      } else {
        throw Exception('Failed to fetch nearby places from Overpass API');
      }
    } catch (e) {
      throw Exception('Error fetching nearby places: $e');
    }
  }

  @override
  Future<RouteModel> getRoute(
    double startLat,
    double startLon,
    double endLat,
    double endLon,
  ) async {
    try {
      final response = await dio.get(
        'https://router.project-osrm.org/route/v1/driving/$startLon,$startLat;$endLon,$endLat',
        queryParameters: {
          'geometries': 'geojson',
          'overview': 'full',
        },
      );

      if (response.statusCode == 200) {
        return RouteModel.fromOsrm(response.data as Map<String, dynamic>);
      } else {
        throw Exception('OSRM route generation failed');
      }
    } catch (e) {
      throw Exception('Error generating route: $e');
    }
  }
}
