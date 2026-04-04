import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TripMapScreen extends StatefulWidget {
  final String destinationAddress;
  const TripMapScreen({super.key, required this.destinationAddress});

  @override
  State<TripMapScreen> createState() => _TripMapScreenState();
}

class _TripMapScreenState extends State<TripMapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _destinationPosition;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  bool _isLoading = true;
  String _errorMessage = '';
  bool _useManualInput = false;
  final TextEditingController _originController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getDestinationLocation();
  }

  Future<void> _getDestinationLocation() async {
    try {
      // Geocode destination
      List<Location> locations = await locationFromAddress(widget.destinationAddress);
      if (locations.isEmpty) throw Exception('Alamat tujuan tidak ditemukan');

      _destinationPosition = LatLng(locations.first.latitude, locations.first.longitude);

      _markers.add(Marker(
        markerId: const MarkerId('destination'),
        position: _destinationPosition!,
        infoWindow: InfoWindow(title: widget.destinationAddress),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));

      setState(() => _isLoading = false);

      // Move camera to destination
      final controller = await _controller.future;
      await controller.animateCamera(CameraUpdate.newLatLngZoom(_destinationPosition!, 12));
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal menemukan lokasi: ${e.toString()}';
      });
    }
  }

  Future<void> _showRoute() async {
    if (_originController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan lokasi awal Anda')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Geocode origin
      List<Location> origins = await locationFromAddress(_originController.text);
      if (origins.isEmpty) throw Exception('Lokasi awal tidak ditemukan');
      final originPos = LatLng(origins.first.latitude, origins.first.longitude);

      // Clear previous polylines and add origin marker
      _polylines.clear();
      _markers.removeWhere((marker) => marker.markerId.value == 'origin');

      _markers.add(Marker(
        markerId: const MarkerId('origin'),
        position: originPos,
        infoWindow: const InfoWindow(title: 'Lokasi Awal'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));

      // Try to get route from Directions API
      const apiKey = 'API_KEY';

      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/directions/json'
              '?origin=${originPos.latitude},${originPos.longitude}'
              '&destination=${_destinationPosition!.latitude},${_destinationPosition!.longitude}'
              '&key=$apiKey'
              '&mode=driving'
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          _drawPolyline(data);
        } else {
          // If Directions API fails, draw straight line
          _drawStraightLine(originPos, _destinationPosition!);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Rute tidak tersedia, menampilkan garis lurus: ${data['status']}')),
          );
        }
      } else {
        _drawStraightLine(originPos, _destinationPosition!);
      }

      // Fit camera to show both points
      final bounds = LatLngBounds(
        southwest: LatLng(
          originPos.latitude < _destinationPosition!.latitude ? originPos.latitude : _destinationPosition!.latitude,
          originPos.longitude < _destinationPosition!.longitude ? originPos.longitude : _destinationPosition!.longitude,
        ),
        northeast: LatLng(
          originPos.latitude > _destinationPosition!.latitude ? originPos.latitude : _destinationPosition!.latitude,
          originPos.longitude > _destinationPosition!.longitude ? originPos.longitude : _destinationPosition!.longitude,
        ),
      );

      final controller = await _controller.future;
      await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));

      setState(() {
        _isLoading = false;
        _useManualInput = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  void _drawPolyline(Map<String, dynamic> data) {
    final points = <LatLng>[];

    if (data['routes'] != null && data['routes'].isNotEmpty) {
      final route = data['routes'][0];
      final encodedPoints = route['overview_polyline']['points'];

      // Decode polyline
      points.addAll(_decodePolyline(encodedPoints));
    }

    if (points.isNotEmpty) {
      _polylines.add(Polyline(
        polylineId: const PolylineId('route'),
        points: points,
        color: Colors.blue,
        width: 5,
        geodesic: true,
      ));
    }
  }

  void _drawStraightLine(LatLng start, LatLng end) {
    _polylines.add(Polyline(
      polylineId: const PolylineId('route'),
      points: [start, end],
      color: Colors.blue,
      width: 5,
      geodesic: true,
    ));
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  @override
  void dispose() {
    _originController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rute ke ${widget.destinationAddress}'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              setState(() {
                _useManualInput = !_useManualInput;
                _errorMessage = '';
              });
            },
            tooltip: 'Masukkan lokasi manual',
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: _destinationPosition ?? const LatLng(-6.2088, 106.8456),
              zoom: 12,
            ),
            onMapCreated: (controller) => _controller.complete(controller),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
          ),
          if (_useManualInput && !_isLoading)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _originController,
                              decoration: const InputDecoration(
                                hintText: 'Masukkan lokasi awal',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.location_searching),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              onSubmitted: (_) => _showRoute(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _showRoute,
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(12),
                            ),
                            child: const Icon(Icons.route),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          _originController.text = 'Jakarta, Indonesia';
                        },
                        child: const Text('Contoh: Jakarta, Indonesia'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator()),
            ),
          if (_errorMessage.isNotEmpty && !_isLoading)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Card(
                color: Colors.red.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_errorMessage)),
                      IconButton(
                        icon: const Icon(Icons.close, size: 16),
                        onPressed: () => setState(() => _errorMessage = ''),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: _useManualInput && !_isLoading
          ? FloatingActionButton(
        onPressed: () {
          setState(() => _useManualInput = false);
        },
        child: const Icon(Icons.close),
      )
          : null,
    );
  }
}