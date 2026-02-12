import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trips/models/trip_model.dart';
import 'package:trips/providers/trip/trip_controller.dart';
import 'package:trips/widgets/trip_manage_card.dart';
import 'package:trips/screens/trip_plan_screen.dart';
import 'package:trips/screens/main_screen.dart';

class ManageTripsScreen extends ConsumerStatefulWidget {
  static const routeName = '/manage-trips';
  final VoidCallback onThemeToggle;
  final bool isDarkMode;
  final IconData themeIcon;
  final String themeDescription;

  const ManageTripsScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
    required this.themeIcon,
    required this.themeDescription,
  });

  @override
  ConsumerState<ManageTripsScreen> createState() => _ManageTripsScreenState();
}

class _ManageTripsScreenState extends ConsumerState<ManageTripsScreen> {
  final TextEditingController _searchController = TextEditingController();
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
    super.dispose();
  }

  // ==================== REFRESH TRIPS ====================
  void _refreshTrips() {
    ref.refresh(tripProvider);
  }

  // ==================== DELETE DIALOG ====================
  Future<void> _showDeleteDialog(String tripId, String tripTitle) async {
    final tripController = ref.read(tripProvider.notifier);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Trip'),
        content: Text('Are you sure you want to delete "$tripTitle"?'),
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
      await tripController.deleteTrip(tripId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trip deleted successfully')),
        );
      }
    }
  }

  // ==================== EDIT DIALOG ====================
  void _showEditDialog(TripModel trip) {
    final titleController = TextEditingController(text: trip.title);
    final locationController = TextEditingController(text: trip.location);
    final priceController = TextEditingController(text: trip.price.toString());
    final ratingController = TextEditingController(text: trip.rating.toString());
    final descriptionController = TextEditingController(text: trip.description);
    final categoryController = TextEditingController(text: trip.category);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Trip'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title*',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      labelText: 'Location*',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price*',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: ratingController,
                    decoration: const InputDecoration(
                      labelText: 'Rating (1-5)*',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: categoryController,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  // Validasi
                  if (titleController.text.isEmpty ||
                      locationController.text.isEmpty ||
                      priceController.text.isEmpty ||
                      ratingController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all required fields')),
                    );
                    return;
                  }

                  final tripController = ref.read(tripProvider.notifier);

                  final updatedTrip = trip.copyWith(
                    title: titleController.text,
                    location: locationController.text,
                    price: double.tryParse(priceController.text) ?? trip.price,
                    rating: double.tryParse(ratingController.text) ?? trip.rating,
                    description: descriptionController.text,
                    category: categoryController.text.isEmpty
                        ? trip.category
                        : categoryController.text,
                  );

                  await tripController.updateTrip(trip.id, updatedTrip);

                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Trip updated successfully')),
                    );
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==================== ADD DIALOG ====================
  void _showAddDialog() {
    final titleController = TextEditingController();
    final locationController = TextEditingController();
    final priceController = TextEditingController();
    final ratingController = TextEditingController();
    final categoryController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Trip'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title*',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Location*',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Price*',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ratingController,
                decoration: const InputDecoration(
                  labelText: 'Rating (1-5)*',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Validasi required fields
              if (titleController.text.isEmpty ||
                  locationController.text.isEmpty ||
                  priceController.text.isEmpty ||
                  ratingController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all required fields')),
                );
                return;
              }

              final tripController = ref.read(tripProvider.notifier);

              final newTrip = TripModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: titleController.text,
                location: locationController.text,
                image: 'https://images.unsplash.com/photo-1539367628448-4bc5c9d171c8', // Default image
                description: descriptionController.text,
                price: double.tryParse(priceController.text) ?? 0.0,
                rating: double.tryParse(ratingController.text) ?? 0.0,
                category: categoryController.text.isEmpty
                    ? 'Cultural'
                    : categoryController.text,
                features: [],
                isBooked: false,
              );

              await tripController.addTrip(newTrip);

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Trip added successfully')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // ==================== TOGGLE BOOK ====================
  Future<void> _handleToggleBook(TripModel trip) async {
    final tripController = ref.read(tripProvider.notifier);

    if (trip.isBooked) {
      await tripController.cancelBooking(trip.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking cancelled')),
        );
      }
    } else {
      await tripController.bookTrip(trip.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trip booked successfully!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch trip provider untuk auto rebuild
    final tripState = ref.watch(tripProvider);
    final trips = tripState.trips;

    // Filter berdasarkan search query
    final filteredTrips = _searchQuery.isEmpty
        ? trips
        : trips.where((trip) =>
    trip.title.toLowerCase().contains(_searchQuery) ||
        trip.location.toLowerCase().contains(_searchQuery)).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Manage Trips'),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => MainScreen(
                  onThemeToggle: widget.onThemeToggle,
                  themeIcon: widget.themeIcon,
                  themeDescription: widget.themeDescription,
                  isDarkMode: widget.isDarkMode,
                ),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(widget.themeIcon),
            onPressed: widget.onThemeToggle,
            tooltip: widget.themeDescription,
          ),
        ],
      ),
      body: tripState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // ================= SEARCH BAR =================
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search trips...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // ================= TRIP LIST =================
          Expanded(
            child: filteredTrips.isEmpty
                ? const Center(
              child: Text('No trips found'),
            )
                : ListView.builder(
              itemCount: filteredTrips.length,
              itemBuilder: (context, index) {
                final trip = filteredTrips[index];
                return TripManageCard(
                  trip: trip,
                  onEdit: () => _showEditDialog(trip),
                  onDelete: () => _showDeleteDialog(trip.id, trip.title),
                  onToggleBook: () => _handleToggleBook(trip),
                  onView: () {
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
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}