import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trips/screens/trip_plan_screen.dart';
import 'package:trips/style/app_colors.dart';
import 'package:trips/style/font_style.dart';
import 'package:trips/screens/manage_trips_screen.dart';
import 'package:trips/providers/trip/trip_controller.dart';
import 'package:trips/models/trip_model.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  static const routeName = '/dashboard';
  final VoidCallback onThemeToggle;
  final IconData themeIcon;
  final String themeDescription;
  final bool isDarkMode;

  // Callback untuk navigasi
  final Function(TripModel)? onNavigateToTripPlan;
  final Function()? onNavigateToManageTrips;

  const DashboardScreen({
    super.key,
    required this.onThemeToggle,
    required this.themeIcon,
    required this.themeDescription,
    required this.isDarkMode,
    this.onNavigateToTripPlan,
    this.onNavigateToManageTrips,
  });

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final PageController _popularController = PageController(viewportFraction: 0.3);


  final List<Map<String, dynamic>> _topRatedDestinations = [
    {
      'title': 'EXPLORE',
      'location': 'Busan, South Korea',
      'image': 'https://images.unsplash.com/photo-1516496636080-14fb876e029d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      'rating': 4.8,
    },
    {
      'title': 'EXPLORE',
      'location': 'Bangkok, Thailand',
      'image': 'https://images.unsplash.com/photo-1528181304800-259b08848526?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      'rating': 4.9,
    },
  ];

  final List<Map<String, dynamic>> _popularDestinations = [
    {
      'name': 'Korea',
      'image': 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
    },
    {
      'name': 'Delhi',
      'image': 'https://images.unsplash.com/photo-1587474260584-136574528ed5?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
    },
    {
      'name': 'Hong Kong',
      'image': 'https://images.unsplash.com/photo-1515542622106-78bda8ba0e5b?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
    },
    {
      'name': 'London',
      'image': 'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
    },
    {
      'name': 'Denmark',
      'image': 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _popularController.dispose();
    super.dispose();
  }

  // Helper function untuk show snackbar menggunakan BuildContext
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

  // ==================== BOOKING HANDLER ====================
  Future<void> _handleBooking(TripModel trip) async {
    final tripController = ref.read(tripProvider.notifier);

    if (trip.isBooked) {
      await tripController.cancelBooking(trip.id);
      _showSnackBar('Booking cancelled!', backgroundColor: Colors.red);
    } else {
      await tripController.bookTrip(trip.id);
      _showSnackBar('Trip booked successfully!', backgroundColor: Colors.green);
    }
  }

  // ==================== DELETE HANDLER ====================
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

  // ==================== NAVIGATION HANDLER ====================
  void _navigateToTripPlan(TripModel trip) {
    if (widget.onNavigateToTripPlan != null) {
      widget.onNavigateToTripPlan!(trip);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TripPlanScreen(
            trip: trip,
            onThemeToggle: widget.onThemeToggle,
            themeIcon: widget.themeIcon,
            themeDescription: widget.themeDescription,
            isDarkMode: widget.isDarkMode,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    // ✅ WATCH TRIP PROVIDER - AUTO REBUILD KETIKA DATA BERUBAH
    final tripState = ref.watch(tripProvider);
    final trips = tripState.trips;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 20),
        ),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: widget.onThemeToggle,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colors.border),
                ),
                child: Icon(
                  widget.themeIcon,
                  color: colors.primary,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: tripState.isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: colors.primary,
        ),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            // ================= WELCOME SECTION =================
            Container(
              width: 220,
              height: 120,
              margin: const EdgeInsets.only(top: 0, bottom: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Wander",
                        style: AppTextStyles.h1(context).copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: const Color.fromARGB(255, 51, 165, 218),
                        ),
                      ),
                      Text(
                        "Ly",
                        style: AppTextStyles.h1(context).copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: const Color.fromARGB(255, 164, 215, 239),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: -18,
                    child: Opacity(
                      opacity: 0.75,
                      child: Image.asset(
                        'assets/images/098c50d2b4f3e494b000428f0cb7997743e3f04b.png',
                        width: 220,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
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
                    child: Icon(
                      Icons.person,
                      color: colors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 0,
                      children: [
                        Text(
                          'Hi, Galileo!',
                          style: AppTextStyles.h3(context).copyWith(
                            color: colors.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Welcome to Wanderly',
                          style: AppTextStyles.bodyMd(context).copyWith(
                            color: colors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ================= SEARCH BAR =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: colors.inputSearch,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: colors.border),
                  boxShadow: [
                    BoxShadow(
                      color: colors.shadow,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 12.0),
                      child: Icon(
                        Icons.menu,
                        color: colors.textSecondary,
                        size: 24,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search your destination',
                          hintStyle: TextStyle(
                            color: colors.textSecondary,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.only(top: 18, bottom: 18),
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 16.0),
                      child: Icon(
                        Icons.search,
                        color: colors.textSecondary,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ================= DISCOVER SECTION =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1488646953014-85cb44e25828?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.4),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Discover Your Destination',
                        style: AppTextStyles.h3(context).copyWith(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Book Now',
                                style: AppTextStyles.button(context).copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Explore Now',
                                style: AppTextStyles.button(context).copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ================= RESUME YOUR PLAN TRIP =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resume Your Plan Trip',
                    style: AppTextStyles.h3(context).copyWith(
                      color: colors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.transparent, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: colors.shadow,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: const DecorationImage(
                              image: NetworkImage(
                                'https://images.unsplash.com/photo-1537996194471-e657df975ab4?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.black.withOpacity(0.3),
                            ),
                            child: Center(
                              child: Text(
                                'EXPLORE',
                                style: AppTextStyles.h3(context).copyWith(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Bali Adventure',
                                        style: AppTextStyles.bodyMd(context).copyWith(
                                          color: colors.textPrimary,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 8),
                                      Container(
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: colors.surface,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 75,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: colors.primary,
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 25,
                                              child: Container(
                                                color: Colors.transparent,
                                              ),
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
                ],
              ),
            ),

            // ================= TODAY TOP RATE =================
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Today Top Rate',
                    style: AppTextStyles.h3(context).copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'View all',
                      style: AppTextStyles.bodyMd(context).copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: List.generate(2, (index) {
                  final destination = _topRatedDestinations[index];
                  return Expanded(
                    child: Container(
                      height: 130,
                      margin: EdgeInsets.only(right: index == 0 ? 12 : 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(destination['image']),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              decoration: BoxDecoration(
                                color: colors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.star, size: 14, color: colors.onPrimary),
                                  const SizedBox(width: 4),
                                  Text(
                                    destination['rating'].toString(),
                                    style: TextStyle(
                                      color: colors.onPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              destination['title'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              destination['location'],
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // ================= POPULAR DESTINATIONS =================
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'POPULAR',
                          style: AppTextStyles.h3(context).copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            if (widget.onNavigateToManageTrips != null) {
                              widget.onNavigateToManageTrips!();
                            } else {
                              Navigator.pushNamed(context, ManageTripsScreen.routeName);
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: colors.onPrimary,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Manage Trips',
                            style: AppTextStyles.bodyMd(context).copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(5, (index) {
                        final destination = _popularDestinations[index];
                        return Column(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: colors.border),
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  destination['image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                              width: 60,
                              child: Text(
                                destination['name'],
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.bodySm(context).copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),

            // ================= CURATED TRIPS =================
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 0, 0, 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Curated Trip',
                        style: AppTextStyles.h3(context).copyWith(
                          color: colors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.yellow[100]!,
                              Colors.orange[400]!,
                              Colors.orange[800]!,
                            ],
                          ).createShader(bounds);
                        },
                        child: const Icon(Icons.star_outlined, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ================= TRIP LIST WITH CRUD =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: trips.map((trip) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: colors.border),
                      boxShadow: [
                        BoxShadow(
                          color: colors.shadow,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      leading: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(trip.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        trip.title,
                        style: AppTextStyles.bodyMd(context).copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip.location,
                            style: AppTextStyles.bodySm(context).copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
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
                                child: Text(
                                  'BOOKED',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
                            child: Row(
                              children: [
                                Icon(Icons.visibility, size: 20),
                                SizedBox(width: 8),
                                Text('View Details'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'book',
                            child: Row(
                              children: [
                                Icon(
                                  trip.isBooked ? Icons.cancel : Icons.bookmark_add,
                                  size: 20,
                                  color: trip.isBooked ? Colors.red : Colors.blue,
                                ),
                                const SizedBox(width: 8),
                                Text(trip.isBooked ? 'Cancel Booking' : 'Book Now'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red, size: 20),
                                SizedBox(width: 8),
                                Text('Delete', style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                        ],
                        child: Icon(
                          Icons.arrow_forward,
                          color: colors.textPrimary,
                          size: 25,
                        ),
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
    );
  }
}