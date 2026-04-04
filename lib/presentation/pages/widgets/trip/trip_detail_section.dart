import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trips/style/app_colors.dart';


class TripDetailSection extends StatelessWidget {
  final bool isDarkMode;

  const TripDetailSection({
    super.key,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
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
            'Embark on a tranquil journey to Japan\'s iconic Kinkaku-ji Temple, '
                'also known as the Golden Pavilion. Set against the serene backdrop '
                'of Kyoto\'s lush gardens and calm ponds, this Zen Buddhist temple radiates '
                'golden beauty and deep historical and spiritual significance.',
            style: TextStyle(
              color: colors.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}