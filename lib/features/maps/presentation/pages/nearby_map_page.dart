import 'dart:ui';
import 'package:aoun/core/themes/app_colors.dart';
import 'package:aoun/features/maps/domain/entities/donation_location.dart';
import 'package:aoun/features/maps/domain/entities/map_place.dart';
import 'package:aoun/features/maps/domain/entities/nearby_place.dart';
import 'package:aoun/features/maps/presentation/cubit/maps_cubit.dart';
import 'package:aoun/features/maps/presentation/states/maps_state.dart';
import 'package:aoun/features/maps/presentation/widgets/map_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

class NearbyMapPage extends StatefulWidget {
  const NearbyMapPage({super.key});

  @override
  State<NearbyMapPage> createState() => _NearbyMapPageState();
}

class _NearbyMapPageState extends State<NearbyMapPage> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    context.read<MapsCubit>().loadMapData();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  List<Marker> _buildMarkers(BuildContext context, MapsLoaded state) {
    final List<Marker> markers = [];

    // 1. User Location Marker
    markers.add(
      Marker(
        point: LatLng(
          state.userLocation.latitude,
          state.userLocation.longitude,
        ),
        width: 40.w,
        height: 40.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 25.r,
              height: 25.r,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 14.r,
              height: 14.r,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ],
        ),
      ),
    );

    final filter = state.activeFilter;

    // 2. Hospitals Markers
    if (filter == 'all' || filter == 'hospitals') {
      for (var place in state.hospitals) {
        markers.add(
          Marker(
            point: LatLng(place.latitude, place.longitude),
            width: 38.w,
            height: 38.h,
            child: GestureDetector(
              onTap: () {
                context.read<MapsCubit>().selectPlace(place);
              },
              child: CircleAvatar(
                backgroundColor: Colors.redAccent,
                child: Icon(
                  Icons.local_hospital_rounded,
                  color: Colors.white,
                  size: 18.r,
                ),
              ),
            ),
          ),
        );
      }
    }

    // 3. Foundations Markers
    if (filter == 'all' || filter == 'foundations') {
      for (var place in state.foundations) {
        markers.add(
          Marker(
            point: LatLng(place.latitude, place.longitude),
            width: 38.w,
            height: 38.h,
            child: GestureDetector(
              onTap: () {
                context.read<MapsCubit>().selectPlace(place);
              },
              child: CircleAvatar(
                backgroundColor: Colors.amber,
                child: Icon(
                  Icons.home_work_rounded,
                  color: Colors.black,
                  size: 18.r,
                ),
              ),
            ),
          ),
        );
      }
    }

    // 4. Donation Locations Markers
    if (filter == 'all' || filter == 'donations') {
      for (var place in state.donations) {
        markers.add(
          Marker(
            point: LatLng(place.latitude, place.longitude),
            width: 38.w,
            height: 38.h,
            child: GestureDetector(
              onTap: () {
                context.read<MapsCubit>().selectPlace(place);
              },
              child: CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.volunteer_activism_rounded,
                  color: Colors.white,
                  size: 18.r,
                ),
              ),
            ),
          ),
        );
      }
    }

    // 5. Searched Place Marker
    if (state.selectedPlace is MapPlace) {
      final mapPlace = state.selectedPlace as MapPlace;
      markers.add(
        Marker(
          point: LatLng(mapPlace.latitude, mapPlace.longitude),
          width: 42.w,
          height: 42.h,
          child: Icon(
            Icons.location_on_rounded,
            color: Colors.deepOrangeAccent,
            size: 38.r,
          ),
        ),
      );
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocListener<MapsCubit, MapsState>(
        listenWhen: (prev, curr) {
          if (prev is MapsLoaded && curr is MapsLoaded) {
            return prev.selectedPlace != curr.selectedPlace;
          }
          return prev is! MapsLoaded && curr is MapsLoaded;
        },
        listener: (context, state) {
          if (state is MapsLoaded && state.selectedPlace != null) {
            double lat = 0.0;
            double lon = 0.0;
            final place = state.selectedPlace;
            if (place is NearbyPlace) {
              lat = place.latitude;
              lon = place.longitude;
            } else if (place is DonationLocation) {
              lat = place.latitude;
              lon = place.longitude;
            } else if (place is MapPlace) {
              lat = place.latitude;
              lon = place.longitude;
            }

            if (lat != 0.0 && lon != 0.0) {
              _mapController.move(LatLng(lat, lon), 15.0);
            }
          }
        },
        child: BlocBuilder<MapsCubit, MapsState>(
          builder: (context, state) {
            if (state is MapsLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.lightPrimary),
              );
            } else if (state is MapsError) {
              return _buildErrorState(context, state.message);
            } else if (state is MapsLoaded) {
              return Stack(
                children: [
                  // 1. The OSM Interactive Map Layer
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: LatLng(
                        state.userLocation.latitude,
                        state.userLocation.longitude,
                      ),
                      initialZoom: 14.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        userAgentPackageName: 'com.aoun.app',
                      ),
                      if (state.route != null)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: state.route!.points,
                              strokeWidth: 5.0,
                              color: AppColors.clickedButton,
                            ),
                          ],
                        ),
                      MarkerLayer(markers: _buildMarkers(context, state)),
                    ],
                  ),

                  // 2. Top Controls & Autocomplete Overlay
                  Positioned(
                    top: 50.h,
                    left: 16.w,
                    right: 16.w,
                    child: MapSearchBar(
                      onPlaceSelected: (place) {
                        context.read<MapsCubit>().selectPlace(place);
                      },
                    ),
                  ),

                  // 3. Category Filter Chips Overlay
                  Positioned(
                    top: 115.h,
                    left: 0,
                    right: 0,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          _buildFilterChip(
                            context,
                            label: isAr ? 'الكل' : 'All',
                            filterName: 'all',
                            activeFilter: state.activeFilter,
                          ),
                          _buildFilterChip(
                            context,
                            label: isAr ? 'مستشفيات' : 'Hospitals',
                            filterName: 'hospitals',
                            activeFilter: state.activeFilter,
                          ),
                          _buildFilterChip(
                            context,
                            label: isAr ? 'مؤسسات خيرية' : 'Foundations',
                            filterName: 'foundations',
                            activeFilter: state.activeFilter,
                          ),
                          _buildFilterChip(
                            context,
                            label: isAr ? 'حالات التبرع' : 'Donations',
                            filterName: 'donations',
                            activeFilter: state.activeFilter,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 4. Floating Action Buttons (My Location & Clear Selection)
                  Positioned(
                    right: 16.w,
                    bottom: state.selectedPlace != null
                        ? 260.h
                        : (state.donations.isNotEmpty ? 190.h : 90.h),
                    child: Column(
                      children: [
                        if (state.selectedPlace != null) ...[
                          FloatingActionButton(
                            mini: true,
                            heroTag: 'clear_select',
                            backgroundColor: Colors.black.withOpacity(0.7),
                            foregroundColor: Colors.white,
                            onPressed: () {
                              context.read<MapsCubit>().clearSelection();
                            },
                            child: const Icon(Icons.close_rounded),
                          ),
                          SizedBox(height: 8.h),
                        ],
                        FloatingActionButton(
                          heroTag: 'my_location',
                          backgroundColor: Colors.black.withOpacity(0.7),
                          foregroundColor: AppColors.clickedButton,
                          onPressed: () {
                            _mapController.move(
                              LatLng(
                                state.userLocation.latitude,
                                state.userLocation.longitude,
                              ),
                              14.0,
                            );
                          },
                          child: const Icon(Icons.my_location_rounded),
                        ),
                      ],
                    ),
                  ),

                  // 5. Recommended Donations Horizontal List (Overlay at bottom)
                  if (state.selectedPlace == null &&
                      state.activeFilter == 'all' &&
                      state.donations.isNotEmpty)
                    Positioned(
                      bottom: 85.h,
                      left: 0,
                      right: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 4.h,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 4.h,
                                  ),
                                  color: Colors.black.withOpacity(0.4),
                                  child: Text(
                                    isAr
                                        ? 'التبرعات القريبة الموصى بها:'
                                        : 'Recommended Nearby Donations:',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          RecommendationList(
                            donations: state.donations,
                            onSelect: (item) {
                              context.read<MapsCubit>().selectPlace(item);
                            },
                          ),
                        ],
                      ),
                    ),

                  // 6. Selected Place Details Bottom Sheet (Overlay at bottom)
                  if (state.selectedPlace != null)
                    Positioned(
                      bottom: 80.h,
                      left: 0,
                      right: 0,
                      child: PlaceDetailsBottomSheet(
                        place: state.selectedPlace,
                        isRouting: state.isRouting,
                        activeRoute: state.route,
                        onNavigate: () {
                          context.read<MapsCubit>().navigateToSelected();
                        },
                        onClose: () {
                          context.read<MapsCubit>().clearSelection();
                        },
                      ),
                    ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required String filterName,
    required String activeFilter,
  }) {
    final isSelected = activeFilter == filterName;
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        selected: isSelected,
        selectedColor: AppColors.clickedButton,
        backgroundColor: Colors.black.withOpacity(0.6),
        onSelected: (selected) {
          if (selected) {
            context.read<MapsCubit>().setFilter(filterName);
          }
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_off_rounded,
                color: Colors.redAccent,
                size: 64.r,
              ),
              SizedBox(height: 16.h),
              Text(
                isAr ? 'فشل تحميل خريطة عون' : 'Failed to Load Aoun Map',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                message,
                style: TextStyle(color: Colors.white70, fontSize: 13.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.clickedButton,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: () {
                  context.read<MapsCubit>().loadMapData();
                },
                icon: const Icon(Icons.refresh_rounded, color: Colors.black),
                label: Text(
                  isAr ? 'إعادة المحاولة' : 'Retry Location detection',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
