import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

const String waterStyle = '''
                [
                  {
                    "featureType": "water",
                    "elementType": "geometry.fill",
                    "stylers": [
                      { "color": "#f44336" },
                      { "saturation": 80 },
                      { "lightness": 20 }
                    ]
                  }
                ]
                ''';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Location _location = Location();
  late LatLng _currentLocation = LatLng(25.2684, 55.2962);
  late Set<Polygon> _polygons = _create2KmRectangle(_currentLocation);
  StreamSubscription<LocationData>? _locationSubscription;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          debugPrint('Location service not enabled');
          return;
        }
      }

      PermissionStatus permission = await _location.hasPermission();
      debugPrint('Location permission status: $permission');
      if (permission == PermissionStatus.denied) {
        permission = await _location.requestPermission();
        debugPrint('Permission after request: $permission');
        if (permission != PermissionStatus.granted) return;
      }

      await _location.changeSettings(interval: 1000);
      debugPrint('Location settings configured');

      final LocationData locationData = await _location.getLocation().timeout(
        Duration(seconds: 5),
        onTimeout: () => throw 'Unknown error occurred. Please reload.',
      );
      if (locationData.latitude != null && locationData.longitude != null) {
        final LatLng position = LatLng(
          locationData.latitude!,
          locationData.longitude!,
        );

        setState(() {
          _currentLocation = position;
          _polygons = _create2KmRectangle(position);
        });

        debugPrint(
          'Initial location: ${position.latitude}, ${position.longitude}',
        );
      }

      debugPrint('Starting location stream...');
      _locationSubscription = _location.onLocationChanged.listen(
        (LocationData newLocation) {
          debugPrint('Location stream received data');
          if (newLocation.latitude != null && newLocation.longitude != null) {
            final LatLng newPosition = LatLng(
              newLocation.latitude!,
              newLocation.longitude!,
            );

            debugPrint(
              'Location updated: ${newPosition.latitude}, ${newPosition.longitude}',
            );

            if (mounted) {
              setState(() {
                _currentLocation = newPosition;
                _polygons = _create2KmRectangle(newPosition);
              });

              if (_mapController != null) {
                _mapController!.animateCamera(
                  CameraUpdate.newLatLng(newPosition),
                );
              }
            }
          }
        },
        onError: (error) {
          debugPrint('Location stream error: $error');
        },
        onDone: () {
          debugPrint('Location stream closed');
        },
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Set<Polygon> _create2KmRectangle(LatLng center) {
    const double offset = 0.018;

    return <Polygon>{
      Polygon(
        polygonId: const PolygonId('2km_boundary'),
        points: <LatLng>[
          LatLng(center.latitude - offset, center.longitude - offset),
          LatLng(center.latitude - offset, center.longitude + offset),
          LatLng(center.latitude + offset, center.longitude + offset),
          LatLng(center.latitude + offset, center.longitude - offset),
        ],
        strokeWidth: 2,
        strokeColor: Colors.blue,
        fillColor: Colors.blue.withOpacity(0.1),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              debugPrint('Manual location refresh requested');
              final LocationData locationData = await _location.getLocation();
              if (locationData.latitude != null &&
                  locationData.longitude != null) {
                final LatLng newPosition = LatLng(
                  locationData.latitude!,
                  locationData.longitude!,
                );
                debugPrint(
                  'Manual refresh location: ${newPosition.latitude}, ${newPosition.longitude}',
                );

                setState(() {
                  _currentLocation = newPosition;
                  _polygons = _create2KmRectangle(newPosition);
                });

                if (_mapController != null) {
                  _mapController!.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(target: newPosition, zoom: 13),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLocation!,
                zoom: 13,
              ),
              myLocationEnabled: true,
              buildingsEnabled: false,
              polygons: _polygons,
              style: waterStyle,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
            ),
    );
  }
}
