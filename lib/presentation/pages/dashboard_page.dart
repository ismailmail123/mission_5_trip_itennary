import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trips/presentation/pages/search_trip_page.dart';
import 'package:trips/presentation/pages/trip_plan_page.dart';
import 'package:trips/style/app_colors.dart';
import 'package:trips/style/font_style.dart';
import 'package:trips/presentation/pages/manage_trips_page.dart';
import 'package:trips/presentation/controller/trip_controller.dart';
import 'package:trips/data/models/trip_model.dart';
import 'package:trips/presentation/controller/auth_controller.dart';

class DashboardPage extends ConsumerStatefulWidget {
  static const routeName = '/dashboard';

  // Hapus parameter tema karena dipusatkan di settings
  final Function(TripModel)? onNavigateToTripPlan;
  final Function()? onNavigateToManageTrips;

  const DashboardPage({
    super.key,
    this.onNavigateToTripPlan,
    this.onNavigateToManageTrips,
  });

  @override
  ConsumerState<DashboardPage> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardPage> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final PageController _popularController = PageController(viewportFraction: 0.3);
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _popularController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {Color backgroundColor = Colors.green}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 100),
      ),
    );
  }

  Future<void> _handleBooking(TripModel trip) async {
    final tripController = ref.read(tripProvider.notifier);
    final authController = ref.read(authProvider.notifier);

    final userId = authController.getCurrentUserId();
    if (userId == null) {
      _showSnackBar('Please login first', backgroundColor: Colors.orange);
      Navigator.pushNamed(context, '/login');
      return;
    }

    if (trip.isBooked) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cancel Booking'),
          content: Text('Are you sure you want to cancel booking for "${trip.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirm == true) {
        final success = await tripController.cancelBooking(trip.id);
        if (success) {
          _showSnackBar('Booking cancelled successfully!', backgroundColor: Colors.orange);
        } else {
          _showSnackBar('Failed to cancel booking', backgroundColor: Colors.red);
        }
      }
    } else {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Booking'),
          content: Text('Are you sure you want to book "${trip.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Book Now', style: TextStyle(color: Colors.green)),
            ),
          ],
        ),
      );

      if (confirm == true) {
        final success = await tripController.bookTrip(trip.id);
        if (success) {
          _showSnackBar('Trip booked successfully! Check your email for confirmation.', backgroundColor: Colors.green);
        } else {
          final error = ref.read(tripProvider).error;
          _showSnackBar(error ?? 'Failed to book trip', backgroundColor: Colors.red);
        }
      }
    }
  }

  Future<void> _handleDelete(TripModel trip) async {
    final tripController = ref.read(tripProvider.notifier);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Trip'),
        content: Text('Are you sure you want to delete "${trip.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await tripController.deleteTrip(trip.id);
      if (mounted) {
        _showSnackBar('Trip deleted successfully!', backgroundColor: Colors.red);
      }
    }
  }

  void _navigateToTripPlan(TripModel trip) {
    if (widget.onNavigateToTripPlan != null) {
      widget.onNavigateToTripPlan!(trip);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TripPlanPage(trip: trip), // tanpa parameter tema
        ),
      );
    }
  }

  List<TripModel> _getFilteredTrips(List<TripModel> trips) {
    if (_searchQuery.isEmpty) return trips;
    return trips.where((trip) =>
    trip.title.toLowerCase().contains(_searchQuery) ||
        trip.location.toLowerCase().contains(_searchQuery)
    ).toList();
  }

  List<TripModel> _getBookedTrips(List<TripModel> trips) {
    return trips.where((trip) => trip.isBooked).toList();
  }

  List<String> _getUniqueLocations(List<TripModel> trips) {
    final locations = <String>{};
    for (var trip in trips) {
      final location = trip.location.split(',').first.trim();
      locations.add(location);
    }
    return locations.toList();
  }

  List<TripModel> _getTopRatedTrips(List<TripModel> trips) {
    final sorted = List<TripModel>.from(trips);
    sorted.sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.take(2).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final tripState = ref.watch(tripProvider);
    final allTrips = tripState.trips;
    final filteredTrips = _getFilteredTrips(allTrips);
    final bookedTrips = _getBookedTrips(allTrips);
    final topRatedTrips = _getTopRatedTrips(allTrips);
    final firstBookedTrip = bookedTrips.isNotEmpty ? bookedTrips.first : null;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: const Padding(padding: EdgeInsets.only(left: 20)),
        centerTitle: true,
        title: Row(mainAxisAlignment: MainAxisAlignment.center, children: []),
        // Hapus actions theme
      ),
      body: tripState.isLoading
          ? Center(child: CircularProgressIndicator(color: colors.primary))
          : RefreshIndicator(
        onRefresh: () async => await ref.read(tripProvider.notifier).refreshTrips(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Welcome section
              Consumer(
                builder: (context, ref, child) {
                  final authState = ref.watch(authProvider);
                  final user = authState.user;
                  String displayName = 'Galileo';
                  if (user != null) {
                    displayName = user.name.isNotEmpty ? user.name.split(' ').first : user.email.split('@').first;
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: colors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Icon(Icons.person, color: colors.primary, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Hi, $displayName!',
                                  style: AppTextStyles.h3(context).copyWith(
                                      color: colors.textPrimary, fontSize: 24, fontWeight: FontWeight.w700)),
                              Text('Welcome to Wanderly',
                                  style: AppTextStyles.bodyMd(context).copyWith(
                                      color: colors.textSecondary, fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Search bar (tap to navigate)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchTripsPage(), // tanpa parameter tema
                    ),
                  );
                },
                child: Container(
                  height: 56,
                  margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: colors.inputSearch,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: colors.border),
                    boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 16.0, right: 12.0), child: Icon(Icons.menu, size: 24)),
                      Expanded(child: Text('Search your destination', style: TextStyle(color: colors.textSecondary, fontSize: 14))),
                      const Padding(padding: EdgeInsets.only(left: 12.0, right: 16.0), child: Icon(Icons.search, size: 24)),
                    ],
                  ),
                ),
              ),

             Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: const DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1488646953014-85cb44e25828?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withOpacity(0.6), Colors.black.withOpacity(0.4)],
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Discover Your Destination',
                            style: AppTextStyles.h3(context).copyWith(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 203, 189, 185),
                                  foregroundColor: colors.onPrimary,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Text('Book Now', style: AppTextStyles.button(context).copyWith(fontWeight: FontWeight.w600)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white, width: 1.5),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Text('Explore Now', style: AppTextStyles.button(context).copyWith(fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Resume Your Plan Trip
              if (firstBookedTrip != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Resume Your Plan Trip',
                          style: AppTextStyles.h3(context).copyWith(color: colors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => _navigateToTripPlan(firstBookedTrip),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.transparent, width: 1.5),
                            boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 8, offset: const Offset(0, 4))],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 120,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(image: NetworkImage(firstBookedTrip.image), fit: BoxFit.cover),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                  child: Center(
                                    child: Text('EXPLORE',
                                        style: AppTextStyles.h3(context).copyWith(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                            shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 4, offset: const Offset(0, 2))])),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.circular(8)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(firstBookedTrip.title,
                                                style: AppTextStyles.bodyMd(context).copyWith(
                                                    color: colors.textPrimary, fontWeight: FontWeight.w700, fontSize: 16)),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const SizedBox(height: 8),
                                            Container(
                                              height: 8,
                                              decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(4)),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 75,
                                                    child: Container(
                                                      decoration: BoxDecoration(color: colors.primary, borderRadius: BorderRadius.circular(4)),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 25,
                                                    child: Container(color: Colors.transparent),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Today Top Rate
              if (topRatedTrips.isNotEmpty)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Today Top Rate',
                              style: AppTextStyles.h3(context).copyWith(fontSize: 18, fontWeight: FontWeight.w700)),
                          TextButton(
                            onPressed: () {},
                            child: Text('View all',
                                style: AppTextStyles.bodyMd(context).copyWith(color: colors.primary, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: List.generate(
                          topRatedTrips.length > 2 ? 2 : topRatedTrips.length,
                              (index) {
                            final trip = topRatedTrips[index];
                            return Expanded(
                              child: Container(
                                height: 130,
                                margin: EdgeInsets.only(right: index == 0 ? 12 : 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(image: NetworkImage(trip.image), fit: BoxFit.cover),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                        decoration: BoxDecoration(color: colors.primary, borderRadius: BorderRadius.circular(8)),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.star, size: 14, color: colors.onPrimary),
                                            const SizedBox(width: 4),
                                            Text(trip.rating.toString(), style: TextStyle(color: colors.onPrimary, fontWeight: FontWeight.w600)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text('EXPLORE', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                                      Text(trip.location, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),

              // Popular Destinations
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                decoration: BoxDecoration(color: colors.card, borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('POPULAR',
                              style: AppTextStyles.h3(context).copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
                          OutlinedButton(
                            onPressed: () {
                              if (widget.onNavigateToManageTrips != null) {
                                widget.onNavigateToManageTrips!();
                              } else {
                                Navigator.pushNamed(context, ManageTripsPage.routeName);
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: colors.onPrimary,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: Text('Manage Trips',
                                style: AppTextStyles.bodyMd(context).copyWith(color: colors.textPrimary, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                    if (allTrips.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            _getUniqueLocations(allTrips).length > 5 ? 5 : _getUniqueLocations(allTrips).length,
                                (index) {
                              final location = _getUniqueLocations(allTrips)[index];
                              final tripForImage = allTrips.firstWhere(
                                    (t) => t.location.contains(location),
                                orElse: () => allTrips.first,
                              );
                              return Column(
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: colors.border)),
                                    child: ClipOval(child: Image.network(tripForImage.image, fit: BoxFit.cover)),
                                  ),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    width: 60,
                                    child: Text(
                                      location.split(',').first,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.bodySm(context).copyWith(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Curated Trips
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 0, 0, 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('Curated Trip',
                            style: AppTextStyles.h3(context).copyWith(color: colors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.yellow[100]!, Colors.orange[400]!, Colors.orange[800]!],
                            ).createShader(bounds);
                          },
                          child: const Icon(Icons.star_outlined, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Trip List
              if (filteredTrips.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(_searchQuery.isEmpty ? Icons.flight_takeoff : Icons.search_off, size: 64, color: colors.textSecondary),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty ? 'No trips available' : 'No trips match your search',
                          style: AppTextStyles.bodyLg(context).copyWith(color: colors.textSecondary),
                        ),
                        if (_searchQuery.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: ElevatedButton(
                              onPressed: () {
                                if (widget.onNavigateToManageTrips != null) {
                                  widget.onNavigateToManageTrips!();
                                } else {
                                  Navigator.pushNamed(context, ManageTripsPage.routeName);
                                }
                              },
                              child: const Text('Add New Trip'),
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: filteredTrips.map((trip) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: colors.card,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: colors.border),
                          boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 4, offset: const Offset(0, 2))],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          leading: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(image: NetworkImage(trip.image), fit: BoxFit.cover),
                            ),
                          ),
                          title: Text(trip.title,
                              style: AppTextStyles.bodyMd(context).copyWith(color: colors.textPrimary, fontWeight: FontWeight.w600)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(trip.location, style: AppTextStyles.bodySm(context).copyWith(color: colors.textSecondary)),
                              const SizedBox(height: 4),
                              if (trip.isBooked)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: Colors.green),
                                    ),
                                    child: Text('BOOKED', style: const TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (value == 'view') {
                                _navigateToTripPlan(trip);
                              } else if (value == 'book') {
                                await _handleBooking(trip);
                              } else if (value == 'delete') {
                                await _handleDelete(trip);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'view',
                                child: Row(children: [Icon(Icons.visibility, size: 20), SizedBox(width: 8), Text('View Details')]),
                              ),
                              PopupMenuItem(
                                value: 'book',
                                child: Row(
                                  children: [
                                    Icon(trip.isBooked ? Icons.cancel : Icons.bookmark_add, size: 20, color: trip.isBooked ? Colors.red : Colors.blue),
                                    const SizedBox(width: 8),
                                    Text(trip.isBooked ? 'Cancel Booking' : 'Book Now'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(children: [Icon(Icons.delete, color: Colors.red, size: 20), SizedBox(width: 8), Text('Delete', style: TextStyle(color: Colors.red))]),
                              ),
                            ],
                            child: Icon(Icons.arrow_forward, color: colors.textPrimary, size: 25),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}