import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../services/open_route_service.dart';

class RobotLocation extends StatefulWidget {
  final LatLng robotPosition;
  final LatLng? destinationPosition;

  const RobotLocation({
    Key? key,
    required this.robotPosition,
    this.destinationPosition,
  }) : super(key: key);

  @override
  RobotLocationState createState() => RobotLocationState();
}

class RobotLocationState extends State<RobotLocation> {
  List<LatLng> route = [];
  final mapController = MapController();

  @override
  void initState() {
    super.initState();
    if (widget.destinationPosition != null) {
      _fetchRoute();
    }
  }

  _fetchRoute() async {
    final service = OpenRouteService();
    final result = await service.getRouteCoordinates(
        widget.robotPosition, widget.destinationPosition!);
    if (mounted) {
      setState(() {
        route = result;
      });
    }
  }

  void centerMapOnRobot() {
    mapController.move(widget.robotPosition, 18.0);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                center: widget.robotPosition,
                zoom: 18.0,
                minZoom: 18.0,
                maxZoom: 18.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: widget.robotPosition,
                      builder: (ctx) => const Icon(Icons.location_on,
                          color: Colors.red, size: 40.0),
                    ),
                    if (widget.destinationPosition != null)
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: widget.destinationPosition!,
                        builder: (ctx) => const Icon(Icons.flag,
                            color: Colors.blue, size: 40.0),
                      ),
                  ],
                ),
                if (route.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: route,
                        strokeWidth: 2.0,
                        color: Colors.blue,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 10.0,
            right: 10.0,
            child: FloatingActionButton(
              onPressed: centerMapOnRobot,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
