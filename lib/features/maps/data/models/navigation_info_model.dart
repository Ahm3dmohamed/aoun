class NavigationInfo {
  final String destinationName;
  final double distanceKm;
  final double durationMin;
  final double destinationLat;
  final double destinationLng;

  const NavigationInfo({
    required this.destinationName,
    required this.distanceKm,
    required this.durationMin,
    required this.destinationLat,
    required this.destinationLng,
  });
}
