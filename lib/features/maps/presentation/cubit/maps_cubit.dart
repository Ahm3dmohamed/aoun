import 'package:aoun/features/maps/domain/entities/nearby_place.dart';
import 'package:aoun/features/maps/domain/entities/donation_location.dart';
import 'package:aoun/features/maps/domain/entities/map_place.dart';
import 'package:aoun/features/maps/domain/usecases/maps_usecases.dart';
import 'package:aoun/features/maps/presentation/states/maps_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class MapsCubit extends Cubit<MapsState> {
  final GetCurrentLocationUseCase getCurrentLocationUseCase;
  final GetNearbyPlacesUseCase getNearbyPlacesUseCase;
  final SearchPlacesUseCase searchPlacesUseCase;
  final GetRouteUseCase getRouteUseCase;
  final GetRecommendedDonationsUseCase getRecommendedDonationsUseCase;

  MapsCubit({
    required this.getCurrentLocationUseCase,
    required this.getNearbyPlacesUseCase,
    required this.searchPlacesUseCase,
    required this.getRouteUseCase,
    required this.getRecommendedDonationsUseCase,
  }) : super(MapsInitial());

  Future<void> loadMapData() async {
    emit(MapsLoading());
    final locationResult = await getCurrentLocationUseCase();

    await locationResult.fold(
      (failure) async {
        emit(MapsError(failure.message));
      },
      (position) async {
        await fetchAllData(position);
      },
    );
  }

  Future<void> fetchAllData(Position position) async {
    final lat = position.latitude;
    final lon = position.longitude;

    final results = await Future.wait([
      getNearbyPlacesUseCase(latitude: lat, longitude: lon, type: 'hospital'),
      getNearbyPlacesUseCase(latitude: lat, longitude: lon, type: 'foundation'),
      getRecommendedDonationsUseCase(userLat: lat, userLon: lon),
    ]);

    final hospitalsResult = results[0];
    final foundationsResult = results[1];
    final donationsResult = results[2];

    final hospitals = hospitalsResult.fold((_) => [], (data) => data);
    final foundations = foundationsResult.fold((_) => [], (data) => data);
    final donations = donationsResult.fold((_) => [], (data) => data);

    emit(
      MapsLoaded(
        userLocation: position,
        hospitals: List<NearbyPlace>.from(hospitals),
        foundations: List<NearbyPlace>.from(foundations),
        donations: List<DonationLocation>.from(donations),
      ),
    );
  }

  Future<void> search(String query) async {
    final currentState = state;
    if (currentState is! MapsLoaded) return;

    if (query.trim().isEmpty) {
      emit(currentState.copyWith(searchResults: [], isSearching: false));
      return;
    }

    emit(currentState.copyWith(isSearching: true));
    final searchResult = await searchPlacesUseCase(query);

    searchResult.fold(
      (failure) {
        emit(currentState.copyWith(isSearching: false, searchResults: []));
      },
      (places) {
        emit(currentState.copyWith(isSearching: false, searchResults: places));
      },
    );
  }

  void selectPlace(dynamic place) {
    final currentState = state;
    if (currentState is! MapsLoaded) return;

    emit(currentState.copyWith(selectedPlace: place, clearRoute: true));
  }

  void clearSelection() {
    final currentState = state;
    if (currentState is! MapsLoaded) return;

    emit(currentState.copyWith(clearSelectedPlace: true, clearRoute: true));
  }

  void setFilter(String filter) {
    final currentState = state;
    if (currentState is! MapsLoaded) return;

    emit(currentState.copyWith(activeFilter: filter));
  }

  Future<void> navigateToSelected() async {
    final currentState = state;
    if (currentState is! MapsLoaded) return;
    if (currentState.selectedPlace == null) return;

    final double startLat = currentState.userLocation.latitude;
    final double startLon = currentState.userLocation.longitude;

    double endLat = 0.0;
    double endLon = 0.0;

    final place = currentState.selectedPlace;
    if (place is NearbyPlace) {
      endLat = place.latitude;
      endLon = place.longitude;
    } else if (place is DonationLocation) {
      endLat = place.latitude;
      endLon = place.longitude;
    } else if (place is MapPlace) {
      endLat = place.latitude;
      endLon = place.longitude;
    } else {
      return;
    }

    emit(currentState.copyWith(isRouting: true, clearRoute: true));

    final routeResult = await getRouteUseCase(
      startLat: startLat,
      startLon: startLon,
      endLat: endLat,
      endLon: endLon,
    );

    routeResult.fold(
      (failure) {
        emit(currentState.copyWith(isRouting: false));
      },
      (routeEntity) {
        emit(currentState.copyWith(isRouting: false, route: routeEntity));
      },
    );
  }
}
