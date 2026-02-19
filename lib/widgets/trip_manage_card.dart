import 'package:flutter/material.dart';
import '../models/trip_model.dart';

class TripManageCard extends StatelessWidget {
  final TripModel trip;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleBook;
  final VoidCallback onView;

// 💎 `TripManageCard` sangat rapi. Penggunaan `PopupMenuButton` untuk 
// aksi CRUD adalah pilihan cerdas untuk menghemat ruang layar! 📱💎
  const TripManageCard({
    super.key,
    required this.trip,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleBook,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: onView,
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
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(trip.location),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text('${trip.rating}'),
                const Spacer(),
                Text(
                  '\$${trip.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Chip(
              label: Text(
                trip.isBooked ? 'Booked' : 'Available',
                style: TextStyle(
                  color: trip.isBooked ? Colors.green : Colors.grey,
                  fontSize: 12,
                ),
              ),
              backgroundColor: trip.isBooked
                  ? Colors.green.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') onEdit();
            if (value == 'delete') onDelete();
            if (value == 'toggle_book') onToggleBook();
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'toggle_book',
              child: Row(
                children: [
                  Icon(
                    trip.isBooked ? Icons.cancel : Icons.bookmark_add,
                    size: 20,
                    color: trip.isBooked ? Colors.red : Colors.blue,
                  ),
                  SizedBox(width: 8),
                  Text(trip.isBooked ? 'Cancel Booking' : 'Book Now'),
                ],
              ),
            ),
            PopupMenuItem(
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
        ),
      ),
    );
  }
}