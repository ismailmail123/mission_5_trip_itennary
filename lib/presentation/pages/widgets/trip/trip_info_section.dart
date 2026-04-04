import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trips/style/app_colors.dart';


class TripInfoRow extends StatelessWidget {
  final bool isDarkMode;

  const TripInfoRow({
    super.key,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: colors.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InfoItemHorizontal(
            icon: CupertinoIcons.location_solid,
            value: 'Kyoto, Japan',
            isDarkMode: isDarkMode,
            iconColor: Colors.black,
          ),
          InfoItemHorizontal(
            icon: CupertinoIcons.person,
            label: 'Visitor',
            value: '65,034',
            isDarkMode: isDarkMode,
            iconColor: Colors.black,
          ),
          InfoItemHorizontal(
            icon: CupertinoIcons.star_fill,
            label: 'Rating',
            value: '4.8',
            isDarkMode: isDarkMode,
            iconColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}

// 3. INFO ITEM COMPONENT
class InfoItemHorizontal extends StatelessWidget {
  final IconData icon;
  final String value;
  final String? label;
  final bool isDarkMode;
  final Color? iconColor;

  const InfoItemHorizontal({
    super.key,
    required this.icon,
    required this.value,
    this.label,
    required this.isDarkMode,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colors.cardInfo,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor ?? colors.primary),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null)
              Text(
                label!,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colors.cardInfo,
                ),
              ),
            Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
