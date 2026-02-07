import 'package:flutter/material.dart';
import '../services/trip_service.dart';
import '../models/trip_model.dart';
import '../widgets/trip_manage_card.dart';
import 'main_screen.dart';
import 'trip_plan_screen.dart';
import 'dashboard_screen.dart';

class ManageTripsScreen extends StatefulWidget {

  static const routeName = '/managetrips';
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
  State<ManageTripsScreen> createState() => _ManageTripsScreenState();
}

class _ManageTripsScreenState extends State<ManageTripsScreen> {
  final TripService _tripService = TripService();
  late List<TripModel> _trips;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _trips = _tripService.getAllTrips();
  }

  void _refreshTrips() {
    setState(() {
      _trips = _tripService.getAllTrips();
    });
  }

  void _showDeleteDialog(String tripId, String tripTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Trip'),
        content: Text('Are you sure you want to delete "$tripTitle"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _tripService.deleteTrip(tripId);
              _refreshTrips();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Trip deleted successfully')),
              );
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(TripModel trip) {
    final titleController = TextEditingController(text: trip.title);
    final locationController = TextEditingController(text: trip.location);
    final priceController = TextEditingController(text: trip.price.toString());
    final ratingController = TextEditingController(text: trip.rating.toString());
    final descriptionController = TextEditingController(text: trip.description);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Edit Trip'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: locationController,
                    decoration: InputDecoration(labelText: 'Location'),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: priceController,
                    decoration: InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: ratingController,
                    decoration: InputDecoration(labelText: 'Rating (1-5)'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final updatedTrip = trip.copyWith(
                    title: titleController.text,
                    location: locationController.text,
                    price: double.tryParse(priceController.text) ?? trip.price,
                    rating: double.tryParse(ratingController.text) ?? trip.rating,
                    description: descriptionController.text,
                  );
                  _tripService.updateTrip(trip.id, updatedTrip);
                  _refreshTrips();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Trip updated successfully')),
                  );
                },
                child: Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddDialog() {
    final titleController = TextEditingController();
    final locationController = TextEditingController();
    final priceController = TextEditingController();
    final ratingController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Trip'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title*'),
              ),
              SizedBox(height: 12),
              TextField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Location*'),
              ),
              SizedBox(height: 12),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price*'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12),
              TextField(
                controller: ratingController,
                decoration: InputDecoration(labelText: 'Rating (1-5)*'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.isEmpty ||
                  locationController.text.isEmpty ||
                  priceController.text.isEmpty ||
                  ratingController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill all required fields')),
                );
                return;
              }

              final newTrip = TripModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: titleController.text,
                location: locationController.text,
                image: 'https://images.unsplash.com/photo-1539367628448-4bc5c9d171c8',
                description: descriptionController.text,
                price: double.tryParse(priceController.text) ?? 0.0,
                rating: double.tryParse(ratingController.text) ?? 0.0,
                category: 'Cultural',
              );

              _tripService.addTrip(newTrip);
              _refreshTrips();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Trip added successfully')),
              );
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredTrips = _searchController.text.isEmpty
        ? _trips
        : _trips.where((trip) =>
    trip.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
        trip.location.toLowerCase().contains(_searchController.text.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('Manage Trips'),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Ganti DashboardScreen dengan MainScreen
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search trips...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTrips.length,
              itemBuilder: (context, index) {
                final trip = filteredTrips[index];
                return TripManageCard(
                  trip: trip,
                  onEdit: () => _showEditDialog(trip),
                  onDelete: () => _showDeleteDialog(trip.id, trip.title),
                  onToggleBook: () {
                    if (trip.isBooked) {
                      _tripService.cancelBooking(trip.id);
                    } else {
                      _tripService.bookTrip(trip.id);
                    }
                    _refreshTrips();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(trip.isBooked
                            ? 'Booking cancelled'
                            : 'Trip booked successfully!'),
                      ),
                    );
                  },
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
        child: Icon(Icons.add),
      ),
    );
  }
}