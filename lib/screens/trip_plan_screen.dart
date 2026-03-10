import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trips/models/trip_model.dart';
import 'package:trips/providers/trip/trip_controller.dart';
import 'package:trips/providers/auth/auth_controller.dart';
import 'package:trips/style/app_colors.dart';
import 'package:trips/style/font_style.dart';

class TripPlanScreen extends ConsumerStatefulWidget {
  final TripModel trip;

  const TripPlanScreen({
    super.key,
    required this.trip,
  });

  @override
  ConsumerState<TripPlanScreen> createState() => _TripPlanScreenState();
}

class _TripPlanScreenState extends ConsumerState<TripPlanScreen> {
  bool _isBooked = false;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkBookingStatus();
  }

  Future<void> _checkBookingStatus() async {
    try {
      final tripController = ref.read(tripProvider.notifier);
      final isBooked = await tripController.isTripBookedByCurrentUser(widget.trip.id);
      if (mounted) {
        setState(() {
          _isBooked = isBooked;
          _isLoading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Failed to check booking status';
        });
      }
    }
  }

  Future<void> _handleBooking() async {
    final tripController = ref.read(tripProvider.notifier);
    final authController = ref.read(authProvider.notifier);

    final userId = authController.getCurrentUserId();
    if (userId == null) {
      _showSnackBar('Please login first to book this trip', isError: true);
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) Navigator.pushNamed(context, '/login');
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      if (_isBooked) {
        final confirm = await _showConfirmDialog(
          title: 'Cancel Booking',
          message: 'Are you sure you want to cancel booking for "${widget.trip.title}"?',
          confirmText: 'Yes, Cancel',
          isDestructive: true,
        );

        if (confirm == true) {
          final success = await tripController.cancelBooking(widget.trip.id);
          if (success && mounted) {
            setState(() => _isBooked = false);
            _showSnackBar('Booking cancelled successfully');
          } else if (mounted) {
            _showSnackBar('Failed to cancel booking', isError: true);
          }
        }
      } else {
        final confirm = await _showConfirmDialog(
          title: 'Confirm Booking',
          message: 'Are you sure you want to book "${widget.trip.title}"?\n\nPrice: \$${widget.trip.price.toStringAsFixed(2)}',
          confirmText: 'Book Now',
          isDestructive: false,
        );

        if (confirm == true) {
          final success = await tripController.bookTrip(widget.trip.id);
          if (success && mounted) {
            setState(() => _isBooked = true);
            _showSnackBar('Trip booked successfully! Check your email for confirmation.');
          } else if (mounted) {
            final error = ref.read(tripProvider).error;
            _showSnackBar(error ?? 'Failed to book trip', isError: true);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
        _showSnackBar('An error occurred: ${e.toString()}', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<bool?> _showConfirmDialog({
    required String title,
    required String message,
    required String confirmText,
    required bool isDestructive,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: AppColors.of(context).textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDestructive ? AppColors.of(context).error : AppColors.of(context).primary,
              foregroundColor: AppColors.of(context).onPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.of(context).error : AppColors.of(context).success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
        action: isError ? null : SnackBarAction(label: 'OK', textColor: Colors.white, onPressed: () {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final trip = widget.trip;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: colors.textPrimary), onPressed: () => Navigator.pop(context)),
        // Hapus actions theme
      ),
      body: _isLoading && _error == null
          ? Center(child: CircularProgressIndicator(color: colors.primary))
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(trip.image), fit: BoxFit.cover),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(trip.title, style: AppTextStyles.h1(context).copyWith(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.white70, size: 20),
                          const SizedBox(width: 4),
                          Expanded(child: Text(trip.location, style: AppTextStyles.bodyLg(context).copyWith(color: Colors.white70))),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: colors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text(trip.rating.toString(), style: AppTextStyles.bodyLg(context).copyWith(color: colors.textPrimary, fontWeight: FontWeight.bold)),
                            Text(' /5', style: AppTextStyles.bodySm(context).copyWith(color: colors.textSecondary)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Starting from', style: AppTextStyles.bodySm(context).copyWith(color: colors.textSecondary)),
                          Text('\$${trip.price.toStringAsFixed(2)}', style: AppTextStyles.h2(context).copyWith(color: colors.primary, fontWeight: FontWeight.bold, fontSize: 28)),
                          Text('/person', style: AppTextStyles.bodySm(context).copyWith(color: colors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: colors.border)),
                    child: Text(trip.category, style: AppTextStyles.bodyMd(context).copyWith(color: colors.textPrimary)),
                  ),
                  const SizedBox(height: 24),
                  Text('Description', style: AppTextStyles.h3(context).copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(trip.description, style: AppTextStyles.bodyLg(context).copyWith(color: colors.textSecondary, height: 1.5)),
                  const SizedBox(height: 24),
                  Text('Features & Amenities', style: AppTextStyles.h3(context).copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: trip.features.map((feature) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: colors.border)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_getFeatureIcon(feature), size: 18, color: colors.primary),
                            const SizedBox(width: 6),
                            Text(feature, style: AppTextStyles.bodyMd(context).copyWith(color: colors.textPrimary)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Text('Recommended Hotels', style: AppTextStyles.h3(context).copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 280,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(color: colors.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: colors.border)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: Image.network(
                                  'https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Hotel ${index + 1}', style: AppTextStyles.bodyMd(context).copyWith(fontWeight: FontWeight.bold)),
                                    Row(
                                      children: [
                                        Icon(Icons.star, size: 14, color: Colors.amber),
                                        const SizedBox(width: 2),
                                        Text('4.5', style: AppTextStyles.bodySm(context)),
                                        const Spacer(),
                                        Text('\$${(120 + index * 20)}', style: AppTextStyles.bodyMd(context).copyWith(color: colors.primary, fontWeight: FontWeight.bold)),
                                        Text('/night', style: AppTextStyles.bodySm(context).copyWith(color: colors.textSecondary)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      // floatingActionLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton.extended(
        onPressed: _handleBooking,
        backgroundColor: _isBooked ? colors.error : colors.primary,
        icon: Icon(_isBooked ? Icons.cancel : Icons.bookmark_add, color: colors.onPrimary),
        label: Text(_isBooked ? 'Cancel Booking' : 'Book Now', style: AppTextStyles.button(context).copyWith(color: colors.onPrimary, fontWeight: FontWeight.w600)),
      ),
    );
  }

  IconData _getFeatureIcon(String feature) {
    switch (feature.toLowerCase()) {
      case 'beach': return Icons.beach_access;
      case 'mountain': return Icons.terrain;
      case 'city': return Icons.location_city;
      case 'food': return Icons.restaurant;
      case 'shopping': return Icons.shopping_bag;
      case 'culture': return Icons.museum;
      case 'nature': return Icons.park;
      case 'historic site': return Icons.history;
      case 'temple': return Icons.temple_buddhist;
      case 'garden': return Icons.grass;
      default: return Icons.star;
    }
  }
}