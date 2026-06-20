import 'package:aoun/features/maps/domain/entities/map_place.dart';
import 'package:aoun/features/maps/domain/entities/nearby_place.dart';
import 'package:aoun/features/maps/domain/entities/donation_location.dart';
import 'package:aoun/features/maps/domain/entities/route_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

abstract class MapsState extends Equatable {
  const MapsState();

  @override
  List<Object?> get props => [];
}

class MapsInitial extends MapsState {}

class MapsLoading extends MapsState {}

class MapsLoaded extends MapsState {
  final Position userLocation;
  final List<NearbyPlace> hospitals;
  final List<NearbyPlace> foundations;
  final List<DonationLocation> donations;

  final dynamic selectedPlace; // Can be NearbyPlace, DonationLocation, or MapPlace
  final String activeFilter; // 'all', 'hospitals', 'foundations', 'donations'

  final List<MapPlace> searchResults;
  final bool isSearching;

  final RouteEntity? route;
  final bool isRouting;

  const MapsLoaded({
    required this.userLocation,
    this.hospitals = const [],
    this.foundations = const [],
    this.donations = const [],
    this.selectedPlace,
    this.activeFilter = 'all',
    this.searchResults = const [],
    this.isSearching = false,
    this.route,
    this.isRouting = false,
  });

  MapsLoaded copyWith({
    Position? userLocation,
    List<NearbyPlace>? hospitals,
    List<NearbyPlace>? foundations,
    List<DonationLocation>? donations,
    dynamic selectedPlace,
    bool clearSelectedPlace = false,
    String? activeFilter,
    List<MapPlace>? searchResults,
    bool? isSearching,
    RouteEntity? route,
    bool clearRoute = false,
    bool? isRouting,
  }) {
    return MapsLoaded(
      userLocation: userLocation ?? this.userLocation,
      hospitals: hospitals ?? this.hospitals,
      foundations: foundations ?? this.foundations,
      donations: donations ?? this.donations,
      selectedPlace:
          clearSelectedPlace ? null : (selectedPlace ?? this.selectedPlace),
      activeFilter: activeFilter ?? this.activeFilter,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      route: clearRoute ? null : (route ?? this.route),
      isRouting: isRouting ?? this.isRouting,
    );
  }

  @override
  List<Object?> get props => [
        userLocation,
        hospitals,
        foundations,
        donations,
        selectedPlace,
        activeFilter,
        searchResults,
        isSearching,
        route,
        isRouting,
      ];
}

class MapsError extends MapsState {
  final String message;

  const MapsError(this.message);

  @override
  List<Object?> get props => [message];
}
