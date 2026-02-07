import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trips/style/app_colors.dart';
import 'package:trips/widgets/trip/trip_detail_section.dart';
import 'package:trips/widgets/trip/trip_hotel_section.dart';
import 'package:trips/widgets/trip/trip_info_section.dart';
import 'package:trips/widgets/trip/footer_section.dart';
import '../services/trip_service.dart';
import '../models/trip_model.dart';

class TripPlanScreen extends StatefulWidget {
  static const routeName = '/trip-plan';
  final TripModel trip;
  final VoidCallback onThemeToggle;
  final IconData themeIcon;
  final String themeDescription;
  final bool isDarkMode;

  const TripPlanScreen({
    super.key,
    required this.trip,
    required this.onThemeToggle,
    required this.themeIcon,
    required this.themeDescription,
    required this.isDarkMode,
  });

  @override
  State<TripPlanScreen> createState() => _TripPlanScreenState();
}

class _TripPlanScreenState extends State<TripPlanScreen> {
  final TripService _tripService = TripService();
  late TripModel _currentTrip;

  @override
  void initState() {
    super.initState();
    _currentTrip = widget.trip;
  }

  void _toggleBooking() {
    setState(() {
      if (_currentTrip.isBooked) {
        _tripService.cancelBooking(_currentTrip.id);
      } else {
        _tripService.bookTrip(_currentTrip.id);
      }
      _currentTrip = _tripService.getTripById(_currentTrip.id) ?? _currentTrip;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_currentTrip.isBooked
            ? 'Booking cancelled!'
            : 'Trip booked successfully!'),
        backgroundColor: _currentTrip.isBooked ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Image dengan Back Button DAN Tombol Mode Tema
              Stack(
                children: [
                  // Gambar utama
                  Image.network(
                    _currentTrip.image,
                    height: 260,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  // GRADIENT OVERLAY untuk teks lebih terbaca
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.4),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Tombol Back (kiri atas)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 25,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  // TOMBOL MODE TEMA (kanan atas)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: Icon(
                          widget.themeIcon,
                          color: Colors.white,
                        ),
                        onPressed: widget.onThemeToggle,
                        tooltip: widget.themeDescription,
                      ),
                    ),
                  ),

                  // Judul di tengah kiri bawah
                  Positioned(
                    left: 16,
                    bottom: 30,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentTrip.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 15,
                                color: Colors.black.withOpacity(0.7),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.location_solid,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _currentTrip.location,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                                shadows: [
                                  Shadow(
                                    blurRadius: 8,
                                    color: Colors.black.withOpacity(0.5),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Info Row (Location, Visitor, Rating) - UPDATE
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                color: colors.background,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InfoItemHorizontal(
                      icon: CupertinoIcons.location_solid,
                      value: _currentTrip.location,
                      isDarkMode: widget.isDarkMode,
                      iconColor: Colors.black,
                    ),
                    InfoItemHorizontal(
                      icon: CupertinoIcons.person,
                      label: 'Visitor',
                      value: '65,034',
                      isDarkMode: widget.isDarkMode,
                      iconColor: Colors.black,
                    ),
                    InfoItemHorizontal(
                      icon: CupertinoIcons.star_fill,
                      label: 'Rating',
                      value: _currentTrip.rating.toString(),
                      isDarkMode: widget.isDarkMode,
                      iconColor: Colors.orange,
                    ),
                  ],
                ),
              ),

              // Detail Section - UPDATE dengan data dinamis
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detail',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _currentTrip.description,
                      style: TextStyle(
                        color: colors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Price Section dengan TOMBOL BOOKING
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Bagian kiri: Harga dan info
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Trip Package',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: colors.textPrimary
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '\$${_currentTrip.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: colors.textPrimary
                              ),
                            ),
                            const SizedBox(height: 4),
                            Chip(
                              label: Text(
                                _currentTrip.isBooked ? 'BOOKED' : 'AVAILABLE',
                                style: TextStyle(
                                  color: _currentTrip.isBooked ? Colors.white : Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                              backgroundColor: _currentTrip.isBooked
                                  ? Colors.green
                                  : Colors.grey[300],
                            ),
                          ],
                        ),

                        // Bagian kanan: Tombol Book/Cancel
                        ElevatedButton(
                          onPressed: _toggleBooking,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _currentTrip.isBooked
                                ? Colors.red
                                : AppColors.of(context).primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 4,
                            shadowColor: Colors.black.withOpacity(0.2),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _currentTrip.isBooked ? 'Cancel' : 'Book Now',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                _currentTrip.isBooked
                                    ? Icons.cancel
                                    : Icons.check_circle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              HotelSection(isDarkMode: widget.isDarkMode),

              TripFooter(isDarkMode: widget.isDarkMode),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}