import 'dart:ui';
import 'package:aoun/core/themes/app_colors.dart';
import 'package:aoun/features/maps/data/models/navigation_info_model.dart';
import 'package:aoun/features/maps/domain/entities/donation_location.dart';
import 'package:aoun/features/maps/domain/entities/map_place.dart';
import 'package:aoun/features/maps/domain/entities/nearby_place.dart';
import 'package:aoun/features/maps/domain/entities/route_entity.dart';
import 'package:aoun/features/maps/presentation/cubit/maps_cubit.dart';
import 'package:aoun/features/maps/presentation/states/maps_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../pages/navigate_details_page.dart';

class MapSearchBar extends StatefulWidget {
  final Function(MapPlace) onPlaceSelected;

  const MapSearchBar({super.key, required this.onPlaceSelected});

  @override
  State<MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends State<MapSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapsCubit, MapsState>(
      builder: (context, state) {
        if (state is! MapsLoaded) return const SizedBox();

        final hasResults = state.searchResults.isNotEmpty;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText:
                            Localizations.localeOf(context).languageCode == 'ar'
                            ? 'ابحث عن مستشفى، مدينة، معالم...'
                            : 'Search place, hospital, landmark...',
                        hintStyle: TextStyle(
                          color: Colors.white70,
                          fontSize: 14.sp,
                        ),
                        border: InputBorder.none,
                        icon: const Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                        ),
                        suffixIcon: _controller.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear_rounded,
                                  color: Colors.white70,
                                ),
                                onPressed: () {
                                  _controller.clear();
                                  context.read<MapsCubit>().search('');
                                  _focusNode.unfocus();
                                },
                              )
                            : null,
                      ),
                      onChanged: (val) {
                        context.read<MapsCubit>().search(val);
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
            ),
            if (hasResults) ...[
              SizedBox(height: 8.h),
              Container(
                constraints: BoxConstraints(maxHeight: 220.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  itemCount: state.searchResults.length,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.white10,
                    height: 1.h,
                    indent: 16.w,
                    endIndent: 16.w,
                  ),
                  itemBuilder: (context, index) {
                    final place = state.searchResults[index];
                    return ListTile(
                      dense: true,
                      leading: const Icon(
                        Icons.location_on_outlined,
                        color: Colors.redAccent,
                      ),
                      title: Text(
                        place.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        place.displayName,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        widget.onPlaceSelected(place);
                        _controller.text = place.name;
                        context.read<MapsCubit>().search('');
                        _focusNode.unfocus();
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class RecommendationList extends StatelessWidget {
  final List<DonationLocation> donations;
  final Function(DonationLocation) onSelect;

  const RecommendationList({
    super.key,
    required this.donations,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    if (donations.isEmpty) return const SizedBox();

    return SizedBox(
      height: 110.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: donations.length,
        itemBuilder: (context, index) {
          final item = donations[index];
          final progress = item.targetAmount > 0
              ? (item.donatedAmount / item.targetAmount).clamp(0.0, 1.0)
              : 0.0;

          Color urgencyColor = Colors.green;
          if (item.urgency.toLowerCase() == 'high') {
            urgencyColor = Colors.redAccent;
          } else if (item.urgency.toLowerCase() == 'medium') {
            urgencyColor = Colors.orangeAccent;
          }

          return GestureDetector(
            onTap: () => onSelect(item),
            child: Container(
              width: 260.w,
              margin: EdgeInsets.only(right: 12.w),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: urgencyColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: urgencyColor.withOpacity(0.5),
                              ),
                            ),
                            child: Text(
                              isAr
                                  ? (item.urgency == 'high'
                                        ? 'عاجل جداً'
                                        : (item.urgency == 'medium'
                                              ? 'متوسط'
                                              : 'منخفض'))
                                  : item.urgency.toUpperCase(),
                              style: TextStyle(
                                color: urgencyColor,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.category,
                            style: TextStyle(
                              color: AppColors.clickedButton,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${item.distance?.toStringAsFixed(1) ?? "0.0"} km',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.white12,
                            color: AppColors.clickedButton,
                            minHeight: 4.h,
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${isAr ? 'تم جمع:' : 'Raised:'} \$${item.donatedAmount.toInt()}',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 9.sp,
                                ),
                              ),
                              Text(
                                '${isAr ? 'الهدف:' : 'Goal:'} \$${item.targetAmount.toInt()}',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 9.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PlaceDetailsBottomSheet extends StatelessWidget {
  final dynamic place;
  final bool isRouting;
  final VoidCallback onNavigate;
  final VoidCallback onClose;
  final RouteEntity? activeRoute;

  const PlaceDetailsBottomSheet({
    super.key,
    required this.place,
    required this.isRouting,
    required this.onNavigate,
    required this.onClose,
    this.activeRoute,
  });

  Future<VoidCallback?>? handleNavigation(BuildContext context, place) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NavigationDetailsPage(
          navigationInfo: NavigationInfo(
            destinationName: place,
            distanceKm: place.distance,
            durationMin: place.distance,
            destinationLat: place.latitude,
            destinationLng: place.longitude,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    if (place == null) return const SizedBox();

    String name = '';
    String category = '';
    double? distance;
    String details = '';
    Color themeColor = AppColors.clickedButton;

    if (place is NearbyPlace) {
      final p = place as NearbyPlace;
      name = p.name;
      category = p.type == 'hospital'
          ? (isAr ? 'مستشفى' : 'Hospital')
          : (isAr ? 'جمعية خيرية / NGO' : 'Charity / NGO');
      distance = p.distance;
      themeColor = p.type == 'hospital' ? Colors.redAccent : Colors.amber;
    } else if (place is DonationLocation) {
      final p = place as DonationLocation;
      name = p.title;
      category = '${isAr ? 'تبرع:' : 'Donation:'} ${p.category}';
      distance = p.distance;
      details = p.description;
      themeColor = p.urgency == 'high' ? Colors.redAccent : Colors.green;
    } else if (place is MapPlace) {
      final p = place as MapPlace;
      name = p.name;
      category = isAr ? 'مكان تم البحث عنه' : 'Searched Location';
      details = p.displayName;
    }

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              GestureDetector(
                onTap: onClose,
                child: CircleAvatar(
                  radius: 12.r,
                  backgroundColor: Colors.white12,
                  child: Icon(Icons.close, size: 14.r, color: Colors.white70),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: themeColor.withOpacity(0.2),
                child: Icon(
                  place is NearbyPlace &&
                          (place as NearbyPlace).type == 'hospital'
                      ? Icons.local_hospital_rounded
                      : (place is DonationLocation
                            ? Icons.volunteer_activism_rounded
                            : Icons.location_on_rounded),
                  color: themeColor,
                  size: 22.r,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      category,
                      style: TextStyle(
                        color: themeColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (details.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text(
              details,
              style: TextStyle(color: Colors.white70, fontSize: 12.sp),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          SizedBox(height: 16.h),
          if (activeRoute != null) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.directions_car,
                        color: AppColors.clickedButton,
                        size: 16.r,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${activeRoute!.distance.toStringAsFixed(1)} km',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.amberAccent,
                        size: 16.r,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${activeRoute!.duration.toStringAsFixed(0)} mins' ??
                            "60",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.clickedButton,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onPressed: isRouting
                  ? null
                  : () {
                      final String destinationName = name;
                      final double distance = activeRoute?.distance ?? 30.0;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NavigationDetailsPage(
                            navigationInfo: NavigationInfo(
                              destinationName: destinationName,
                              distanceKm: distance,
                              durationMin: distance,
                              destinationLat: place.latitude,
                              destinationLng: place.longitude,
                            ),
                          ),
                        ),
                      );
                    },
              icon: isRouting
                  ? SizedBox(
                      width: 16.r,
                      height: 16.r,
                      child: const CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.navigation_rounded, color: Colors.black),
              label: Text(
                isRouting
                    ? (isAr ? 'جاري رسم المسار...' : 'Routing...')
                    : (isAr ? 'ابدأ الملاحة' : 'Navigate'),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
