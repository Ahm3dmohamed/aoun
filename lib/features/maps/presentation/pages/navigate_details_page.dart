import 'package:aoun/features/maps/data/models/navigation_info_model.dart';
import 'package:aoun/features/maps/presentation/pages/nearby_map_page.dart';
import 'package:flutter/material.dart';

class NavigationDetailsPage extends StatelessWidget {
  final NavigationInfo navigationInfo;

  const NavigationDetailsPage({super.key, required this.navigationInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 9, 112, 102),
        title: const Text('Route Details '),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            Icon(Icons.location_on, size: 80, color: Colors.red),

            const SizedBox(height: 20),

            Text(
              navigationInfo.destinationName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            Card(
              child: ListTile(
                leading: const Icon(Icons.route),
                title: const Text("Distance"),
                subtitle: Text(
                  "${navigationInfo.distanceKm.toStringAsFixed(1)} km",
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text("Estimated Time"),
                subtitle: Text(
                  "${navigationInfo.durationMin.toStringAsFixed(0)} min",
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.pin_drop),
                title: const Text("Destination"),
                subtitle: Text(
                  "${navigationInfo.destinationLat}, ${navigationInfo.destinationLng}",
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Successfully routing started"),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.navigation),
                label: const Text("Start Route"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
