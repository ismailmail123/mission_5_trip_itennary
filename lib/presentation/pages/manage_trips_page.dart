import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trips/data/models/trip_model.dart';
import 'package:trips/presentation/controller/trip_controller.dart';
import 'package:trips/presentation/pages/widgets/trip_manage_card.dart';
import 'package:trips/presentation/pages/trip_plan_page.dart';
import 'package:trips/presentation/pages/main_page.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class ManageTripsPage extends ConsumerStatefulWidget {
  static const routeName = '/manage-trips';
  // Parameter tema dihapus karena dipusatkan di settings

  const ManageTripsPage({super.key});

  @override
  ConsumerState<ManageTripsPage> createState() => _ManageTripsScreenState();
}

class _ManageTripsScreenState extends ConsumerState<ManageTripsPage> {
  final TextEditingController _searchController = TextEditingController();
  final Uuid _uuid = const Uuid();
  String _searchQuery = '';

  final List<String> _defaultImages = [
    'https://images.unsplash.com/photo-1539367628448-4bc5c9d171c8',
    'https://images.unsplash.com/photo-1537996194471-e657df975ab4',
    'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf',
    'https://images.unsplash.com/photo-1526481280693-3bfa7568e0f3',
    'https://images.unsplash.com/photo-1502602898657-3e91760cbb34',
    'https://images.unsplash.com/photo-1518548419970-58e3b4079ab2',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) => DateFormat('dd/MM/yyyy').format(date);
  String _formatDateForDisplay(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  void _refreshTrips() => ref.refresh(tripProvider);

  Future<void> _showDeleteDialog(String tripId, String tripTitle) async {
    final tripController = ref.read(tripProvider.notifier);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Trip'),
        content: Text('Are you sure you want to delete "$tripTitle"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      await tripController.deleteTrip(tripId);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Trip deleted successfully')));
    }
  }

  Future<XFile?> _pickImage() async {
    final tripController = ref.read(tripProvider.notifier);
    return await tripController.pickImage();
  }

  Future<String?> _showImageSelectorDialog({String? currentImage}) async {
    XFile? pickedImage;
    String? selectedUrl = currentImage;
    bool isPickedFromGallery = false;

    final result = await showDialog<String?>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Select Image'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                    child: pickedImage != null
                        ? Image.file(File(pickedImage!.path), fit: BoxFit.cover)
                        : selectedUrl != null
                        ? Image.network(selectedUrl!, fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image, size: 50)))
                        : const Center(child: Icon(Icons.image, size: 50, color: Colors.grey)),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Choose from gallery'),
                    onTap: () async {
                      final image = await _pickImage();
                      if (image != null) {
                        setState(() {
                          pickedImage = image;
                          selectedUrl = _defaultImages.first;
                          isPickedFromGallery = true;
                        });
                      }
                    },
                  ),
                  const Divider(),
                  const Text('Or choose from default images:'),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _defaultImages.length,
                      itemBuilder: (context, index) {
                        final imageUrl = _defaultImages[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedUrl = imageUrl;
                              pickedImage = null;
                              isPickedFromGallery = false;
                            });
                          },
                          child: Container(
                            width: 80,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedUrl == imageUrl ? Colors.blue : Colors.grey.shade300,
                                width: selectedUrl == imageUrl ? 3 : 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, null), child: const Text('Cancel')),
              TextButton(
                onPressed: () {
                  if (selectedUrl != null) {
                    Navigator.pop(context, selectedUrl);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select an image')));
                  }
                },
                child: const Text('Select'),
              ),
            ],
          );
        },
      ),
    );
    return result;
  }

  void _showEditDialog(TripModel trip) {
    final titleController = TextEditingController(text: trip.title);
    final locationController = TextEditingController(text: trip.location);
    final priceController = TextEditingController(text: trip.price.toString());
    final ratingController = TextEditingController(text: trip.rating.toString());
    final descriptionController = TextEditingController(text: trip.description);
    final categoryController = TextEditingController(text: trip.category);

    String? selectedImageUrl = trip.image;
    DateTime? selectedStartDate = trip.startDate;
    DateTime? selectedEndDate = trip.endDate;

    final startDateController = TextEditingController(text: _formatDate(trip.startDate));
    final endDateController = TextEditingController(text: _formatDate(trip.endDate));

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
                  GestureDetector(
                    onTap: () async {
                      final imageUrl = await _showImageSelectorDialog(currentImage: selectedImageUrl);
                      if (imageUrl != null) setState(() => selectedImageUrl = imageUrl);
                    },
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                      child: selectedImageUrl != null
                          ? Stack(
                        children: [
                          Positioned.fill(child: Image.network(selectedImageUrl!, fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image, size: 50)))),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(4)),
                              child: const Icon(Icons.edit, color: Colors.white, size: 16),
                            ),
                          ),
                        ],
                      )
                          : const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Tap to select image'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title*', border: OutlineInputBorder())),
                  const SizedBox(height: 12),
                  TextField(controller: locationController, decoration: const InputDecoration(labelText: 'Location*', border: OutlineInputBorder())),
                  const SizedBox(height: 12),

                  TextFormField(
                    readOnly: true,
                    controller: startDateController,
                    decoration: const InputDecoration(labelText: 'Start Date*', border: OutlineInputBorder(), prefixIcon: Icon(Icons.calendar_today)),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedStartDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedStartDate = picked;
                          startDateController.text = _formatDate(picked);
                          if (selectedEndDate != null && selectedEndDate!.isBefore(picked)) {
                            selectedEndDate = picked.add(const Duration(days: 1));
                            endDateController.text = _formatDate(selectedEndDate!);
                          }
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    readOnly: true,
                    controller: endDateController,
                    decoration: const InputDecoration(labelText: 'End Date*', border: OutlineInputBorder(), prefixIcon: Icon(Icons.calendar_today)),
                    onTap: () async {
                      if (selectedStartDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select start date first')));
                        return;
                      }
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedEndDate ?? selectedStartDate!.add(const Duration(days: 1)),
                        firstDate: selectedStartDate!,
                        lastDate: selectedStartDate!.add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedEndDate = picked;
                          endDateController.text = _formatDate(picked);
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price*', border: OutlineInputBorder(), prefixIcon: Icon(Icons.attach_money)), keyboardType: TextInputType.number),
                  const SizedBox(height: 12),

                  TextField(controller: ratingController, decoration: const InputDecoration(labelText: 'Rating (1-5)*', border: OutlineInputBorder(), prefixIcon: Icon(Icons.star)), keyboardType: TextInputType.number),
                  const SizedBox(height: 12),

                  TextField(controller: categoryController, decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder(), prefixIcon: Icon(Icons.category))),
                  const SizedBox(height: 12),

                  TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder(), prefixIcon: Icon(Icons.description)), maxLines: 3),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              TextButton(
                onPressed: () async {
                  if (titleController.text.isEmpty ||
                      locationController.text.isEmpty ||
                      selectedStartDate == null ||
                      selectedEndDate == null ||
                      priceController.text.isEmpty ||
                      ratingController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all required fields')));
                    return;
                  }
                  if (selectedImageUrl == null || selectedImageUrl!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select an image')));
                    return;
                  }
                  if (selectedEndDate!.isBefore(selectedStartDate!)) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('End date must be after start date')));
                    return;
                  }

                  final tripController = ref.read(tripProvider.notifier);
                  final updatedTrip = trip.copyWith(
                    title: titleController.text,
                    location: locationController.text,
                    price: double.tryParse(priceController.text) ?? trip.price,
                    rating: double.tryParse(ratingController.text) ?? trip.rating,
                    description: descriptionController.text,
                    category: categoryController.text.isEmpty ? trip.category : categoryController.text,
                    image: selectedImageUrl,
                    startDate: selectedStartDate,
                    endDate: selectedEndDate,
                  );

                  final success = await tripController.updateTrip(trip.id, updatedTrip);
                  if (context.mounted && success) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Trip updated successfully')));
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to update trip')));
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

  void _showAddDialog() {
    final titleController = TextEditingController();
    final locationController = TextEditingController();
    final priceController = TextEditingController();
    final ratingController = TextEditingController();
    final categoryController = TextEditingController();
    final descriptionController = TextEditingController();

    String? selectedImageUrl;
    DateTime? selectedStartDate;
    DateTime? selectedEndDate;

    final startDateController = TextEditingController();
    final endDateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add New Trip'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final imageUrl = await _showImageSelectorDialog();
                      if (imageUrl != null) setState(() => selectedImageUrl = imageUrl);
                    },
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                      child: selectedImageUrl != null
                          ? Stack(
                        children: [
                          Positioned.fill(child: Image.network(selectedImageUrl!, fit: BoxFit.cover)),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(4)),
                              child: const Icon(Icons.edit, color: Colors.white, size: 16),
                            ),
                          ),
                        ],
                      )
                          : const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Tap to select image'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title*', border: OutlineInputBorder())),
                  const SizedBox(height: 12),
                  TextField(controller: locationController, decoration: const InputDecoration(labelText: 'Location*', border: OutlineInputBorder())),
                  const SizedBox(height: 12),

                  TextFormField(
                    readOnly: true,
                    controller: startDateController,
                    decoration: const InputDecoration(labelText: 'Start Date*', border: OutlineInputBorder(), prefixIcon: Icon(Icons.calendar_today)),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedStartDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedStartDate = picked;
                          startDateController.text = _formatDate(picked);
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    readOnly: true,
                    controller: endDateController,
                    decoration: const InputDecoration(labelText: 'End Date*', border: OutlineInputBorder(), prefixIcon: Icon(Icons.calendar_today)),
                    onTap: () async {
                      if (selectedStartDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select start date first')));
                        return;
                      }
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedEndDate ?? selectedStartDate!.add(const Duration(days: 1)),
                        firstDate: selectedStartDate!,
                        lastDate: selectedStartDate!.add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedEndDate = picked;
                          endDateController.text = _formatDate(picked);
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price*', border: OutlineInputBorder(), prefixIcon: Icon(Icons.attach_money)), keyboardType: TextInputType.number),
                  const SizedBox(height: 12),

                  TextField(controller: ratingController, decoration: const InputDecoration(labelText: 'Rating (1-5)*', border: OutlineInputBorder(), prefixIcon: Icon(Icons.star)), keyboardType: TextInputType.number),
                  const SizedBox(height: 12),

                  TextField(controller: categoryController, decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder(), prefixIcon: Icon(Icons.category))),
                  const SizedBox(height: 12),

                  TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder(), prefixIcon: Icon(Icons.description)), maxLines: 3),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              TextButton(
                onPressed: () async {
                  if (titleController.text.isEmpty ||
                      locationController.text.isEmpty ||
                      selectedStartDate == null ||
                      selectedEndDate == null ||
                      priceController.text.isEmpty ||
                      ratingController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all required fields')));
                    return;
                  }
                  if (selectedImageUrl == null || selectedImageUrl!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select an image')));
                    return;
                  }
                  if (selectedEndDate!.isBefore(selectedStartDate!)) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('End date must be after start date')));
                    return;
                  }

                  final tripController = ref.read(tripProvider.notifier);
                  final newTrip = TripModel(
                    id: _uuid.v4(),
                    title: titleController.text,
                    location: locationController.text,
                    image: selectedImageUrl!,
                    description: descriptionController.text,
                    price: double.tryParse(priceController.text) ?? 0.0,
                    rating: double.tryParse(ratingController.text) ?? 0.0,
                    category: categoryController.text.isEmpty ? 'Cultural' : categoryController.text,
                    features: [],
                    isBooked: false,
                    startDate: selectedStartDate!,
                    endDate: selectedEndDate!,
                  );

                  final success = await tripController.addTrip(newTrip);
                  if (context.mounted && success) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Trip added successfully')));
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to add trip')));
                  }
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _handleToggleBook(TripModel trip) async {
    final tripController = ref.read(tripProvider.notifier);
    if (trip.isBooked) {
      await tripController.cancelBooking(trip.id);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking cancelled')));
    } else {
      await tripController.bookTrip(trip.id);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Trip booked successfully!')));
    }
  }

  String _getTripStatus(TripModel trip) {
    final now = DateTime.now();
    if (trip.endDate.isBefore(now)) return 'Completed';
    if (trip.startDate.isAfter(now)) return 'Upcoming';
    return 'Ongoing';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed': return Colors.grey;
      case 'Ongoing': return Colors.green;
      case 'Upcoming': return Colors.blue;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tripState = ref.watch(tripProvider);
    final trips = tripState.trips;

    final filteredTrips = _searchQuery.isEmpty
        ? trips
        : trips.where((trip) => trip.title.toLowerCase().contains(_searchQuery) || trip.location.toLowerCase().contains(_searchQuery)).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Manage Trips'),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Cukup pop saja, karena ManageTripsScreen di-push dari MainScreen
          },
        ),
        // Hapus actions theme
      ),
      body: tripState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search trips...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: filteredTrips.isEmpty
                ? const Center(child: Text('No trips found'))
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredTrips.length,
              itemBuilder: (context, index) {
                final trip = filteredTrips[index];
                final status = _getTripStatus(trip);
                final statusColor = _getStatusColor(status);

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      TripManageCard(
                        trip: trip,
                        onEdit: () => _showEditDialog(trip),
                        onDelete: () => _showDeleteDialog(trip.id, trip.title),
                        onToggleBook: () => _handleToggleBook(trip),
                        onView: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => TripPlanPage(trip: trip)), // tanpa parameter tema
                          );
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: statusColor),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(fontSize: 12, color: statusColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      '${_formatDateForDisplay(trip.startDate)} - ${_formatDateForDisplay(trip.endDate)}',
                                      style: const TextStyle(fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
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
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: _showAddDialog, child: const Icon(Icons.add)),
    );
  }
}