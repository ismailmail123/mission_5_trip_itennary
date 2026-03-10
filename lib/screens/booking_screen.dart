import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trips/providers/trip/trip_controller.dart';
import 'package:trips/providers/auth/auth_controller.dart';
import 'package:trips/models/booking_model.dart';
import 'package:trips/screens/trip_plan_screen.dart';
import 'package:trips/style/app_colors.dart';
import 'package:trips/style/font_style.dart';
import 'package:intl/intl.dart';
import '../models/trip_model.dart';

class MyBookingsScreen extends ConsumerStatefulWidget {
  static const routeName = '/my-bookings';

  // Hapus parameter tema dan dipusatkan di settings
  const MyBookingsScreen({super.key});

  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen> {
  String _selectedFilter = 'active';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final authController = ref.read(authProvider.notifier);
    final userId = authController.getCurrentUserId();

    if (userId == null) {
      return _buildNotLoggedInScreen(colors);
    }

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: colors.background,
        elevation: 0,
        // Hapus actions theme
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: _buildFilterTabs(colors),
        ),
      ),
      body: _buildBookingsStream(colors),
    );
  }

  Widget _buildFilterTabs(AppColors colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildFilterChip('Active', 'active', colors),
          const SizedBox(width: 8),
          _buildFilterChip('Cancelled', 'cancelled', colors),
          const SizedBox(width: 8),
          _buildFilterChip('All', 'all', colors),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, AppColors colors) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) setState(() => _selectedFilter = value);
      },
      backgroundColor: colors.surface,
      selectedColor: colors.primary,
      checkmarkColor: colors.onPrimary,
      labelStyle: TextStyle(color: isSelected ? colors.onPrimary : colors.textPrimary, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: isSelected ? colors.primary : colors.border),
      ),
    );
  }

  Widget _buildBookingsStream(AppColors colors) {
    final tripController = ref.read(tripProvider.notifier);

    return StreamBuilder<List<BookingModel>>(
      stream: tripController.getUserBookings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: colors.primary));
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: colors.error),
                const SizedBox(height: 16),
                Text('Error loading bookings', style: AppTextStyles.bodyLg(context).copyWith(color: colors.error)),
                const SizedBox(height: 8),
                Text(snapshot.error.toString(), style: AppTextStyles.bodySm(context).copyWith(color: colors.textSecondary), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: () => setState(() {}), child: const Text('Try Again')),
              ],
            ),
          );
        }

        final bookings = snapshot.data ?? [];
        final filteredBookings = _selectedFilter == 'all'
            ? bookings
            : bookings.where((b) => b.status == _selectedFilter).toList();

        if (bookings.isEmpty) return _buildEmptyState(colors, isFirstTime: true);
        if (filteredBookings.isEmpty) return _buildEmptyState(colors, isFirstTime: false);

        return RefreshIndicator(
          onRefresh: () async => setState(() {}),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredBookings.length,
            itemBuilder: (context, index) {
              final booking = filteredBookings[index];
              return _buildBookingCard(booking, colors);
            },
          ),
        );
      },
    );
  }

  Widget _buildBookingCard(BookingModel booking, AppColors colors) {
    final dateFormat = DateFormat('dd MMM yyyy • HH:mm');
    final currencyFormat = NumberFormat.currency(locale: 'id', symbol: '\$');

    return Dismissible(
      key: Key(booking.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(color: colors.error, borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      confirmDismiss: (direction) => _showDeleteConfirmDialog(booking),
      onDismissed: (direction) => _handleDeleteBooking(booking.id),
      child: GestureDetector(
        onTap: () => _navigateToTripDetail(booking),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border),
            boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      booking.tripImage,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(height: 160, color: colors.surface, child: Center(child: Icon(Icons.broken_image, size: 48, color: colors.textSecondary)));
                      },
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(booking.status, colors),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4)],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_getStatusIcon(booking.status), size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(booking.status.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  if (booking.tripCategory.isNotEmpty)
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(12)),
                        child: Text(booking.tripCategory, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(booking.tripTitle,
                                  style: AppTextStyles.h3(context).copyWith(fontSize: 18, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 14, color: colors.textSecondary),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(booking.tripLocation,
                                        style: AppTextStyles.bodySm(context).copyWith(color: colors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(currencyFormat.format(booking.tripPrice),
                                style: AppTextStyles.h3(context).copyWith(color: colors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
                            Text('/person', style: AppTextStyles.bodySm(context).copyWith(color: colors.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              const Icon(Icons.star, size: 14, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(booking.tripRating.toString(), style: AppTextStyles.bodyMd(context).copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.calendar_today, size: 14, color: colors.textSecondary),
                        const SizedBox(width: 4),
                        Text(dateFormat.format(booking.bookedAt), style: AppTextStyles.bodySm(context).copyWith(color: colors.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (booking.tripFeatures.isNotEmpty)
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: booking.tripFeatures.take(3).map((feature) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: colors.border)),
                            child: Text(feature, style: AppTextStyles.bodySm(context).copyWith(fontSize: 11)),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _navigateToTripDetail(booking),
                            icon: const Icon(Icons.visibility, size: 18),
                            label: const Text('View Details'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colors.primary,
                              side: BorderSide(color: colors.primary),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        if (booking.status == 'active') ...[
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _showCancelDialog(booking),
                              icon: const Icon(Icons.cancel, size: 18),
                              label: const Text('Cancel'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors.error,
                                foregroundColor: colors.onPrimary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppColors colors, {required bool isFirstTime}) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isFirstTime ? Icons.bookmark_border : Icons.filter_alt_off, size: 100, color: colors.textSecondary.withOpacity(0.5)),
            const SizedBox(height: 24),
            Text(isFirstTime ? 'No Bookings Yet' : 'No Bookings Found', style: AppTextStyles.h2(context).copyWith(color: colors.textPrimary, fontSize: 24)),
            const SizedBox(height: 12),
            Text(isFirstTime ? 'Start your adventure by booking a trip!' : 'No bookings match the selected filter.',
                style: AppTextStyles.bodyLg(context).copyWith(color: colors.textSecondary), textAlign: TextAlign.center),
            const SizedBox(height: 32),
            if (isFirstTime)
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.explore),
                label: const Text('Browse Trips'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            if (!isFirstTime)
              OutlinedButton.icon(
                onPressed: () => setState(() => _selectedFilter = 'all'),
                icon: const Icon(Icons.refresh),
                label: const Text('Show All'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.primary,
                  side: BorderSide(color: colors.primary),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotLoggedInScreen(AppColors colors) {
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: colors.textPrimary), onPressed: () => Navigator.pop(context)),
        // Hapus actions theme
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.account_circle, size: 100, color: colors.textSecondary.withOpacity(0.5)),
              const SizedBox(height: 24),
              Text('Not Logged In', style: AppTextStyles.h2(context).copyWith(color: colors.textPrimary, fontSize: 24)),
              const SizedBox(height: 12),
              Text('Please login to view your bookings', style: AppTextStyles.bodyLg(context).copyWith(color: colors.textSecondary), textAlign: TextAlign.center),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                icon: const Icon(Icons.login),
                label: const Text('Login Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status, AppColors colors) {
    switch (status) {
      case 'active': return Colors.green;
      case 'cancelled': return Colors.red;
      case 'completed': return Colors.blue;
      default: return colors.textSecondary;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'active': return Icons.check_circle;
      case 'cancelled': return Icons.cancel;
      case 'completed': return Icons.done_all;
      default: return Icons.help;
    }
  }

  Future<bool?> _showDeleteConfirmDialog(BookingModel booking) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Booking'),
        content: Text('Are you sure you want to delete this booking for "${booking.tripTitle}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text('Delete')),
        ],
      ),
    );
  }

  Future<void> _showCancelDialog(BookingModel booking) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: Text('Are you sure you want to cancel your booking for "${booking.tripTitle}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.pop(context, true), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text('Yes, Cancel')),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        final tripController = ref.read(tripProvider.notifier);
        final success = await tripController.cancelBooking(booking.tripId);
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text('Booking cancelled successfully'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to cancel booking: ${e.toString()}'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleDeleteBooking(String bookingId) async {
    try {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking deleted'), backgroundColor: Colors.orange, behavior: SnackBarBehavior.floating),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete: ${e.toString()}'), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating),
        );
      }
    }
  }

  void _navigateToTripDetail(BookingModel booking) {
    final trip = TripModel(
      id: booking.tripId,
      title: booking.tripTitle,
      location: booking.tripLocation,
      image: booking.tripImage,
      description: 'Trip details...',
      price: booking.tripPrice,
      rating: booking.tripRating,
      category: booking.tripCategory,
      features: booking.tripFeatures,
      isBooked: booking.status == 'active',
      startDate: booking.tripStartDate ?? DateTime.now(),
      endDate: booking.tripEndDate ?? DateTime.now().add(const Duration(days: 7)),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TripPlanScreen(trip: trip)), // tanpa parameter tema
    );
  }
}