import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TrackingPage extends StatefulWidget {
  final String name;
  final String surname;
  final String product;

  const TrackingPage({
    super.key,
    required this.name,
    required this.surname,
    required this.product,
  });

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  LatLng _initialCenter = LatLng(34.740083, 10.748778); // you can change default
  LatLng? _selectedPosition;

  String _formatCoord(double value) => value.toStringAsFixed(6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Location")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Client: ${widget.name} ${widget.surname}",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              "Product: ${widget.product}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // MAP
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: _initialCenter,
                    initialZoom: 13,
                    onTap: (tapPosition, latLng) {
                      setState(() {
                        _selectedPosition = latLng;
                      });
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      userAgentPackageName: 'com.example.yourapp',
                    ),

                    // Only ONE marker: the selected one
                    MarkerLayer(
                      markers: [
                        if (_selectedPosition != null)
                          Marker(
                            point: _selectedPosition!,
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.green,
                              size: 40,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // COORDINATES DISPLAY
            if (_selectedPosition != null)
              Text(
                "Selected Coordinates:\n"
                "Lat: ${_formatCoord(_selectedPosition!.latitude)}\n"
                "Lng: ${_formatCoord(_selectedPosition!.longitude)}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            else
              const Text(
                "Tap on the map to pick a location.",
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
          ],
        ),
      ),
    );
  }
}
  