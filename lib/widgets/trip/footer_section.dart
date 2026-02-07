import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hugeicons/hugeicons.dart'; // Hapus alias 'as huge_icons'

import '../../style/app_colors.dart';
import '../../style/font_style.dart';

class TripFooter extends StatelessWidget {
  final bool isDarkMode;

  const TripFooter({
    super.key,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      // margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(8),
        boxShadow: isDarkMode
            ? null
            : [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo/Title Section
          Column(
            children: [
              Container(
                width: 130,
                height: 90,
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
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: const Color.fromARGB(255, 51, 165, 218),
                      ),
                    ),
                    Text(
                      "Ly",
                      style: AppTextStyles.h1(context).copyWith(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: const Color.fromARGB(255, 164, 215, 239),
                      ),
                    ),
                      ],
                    ),
                    
                    Positioned(
                      top: -45,
                      child: Opacity(
                        opacity: 0.75,
                        child: Image.asset(
                          'assets/images/098c50d2b4f3e494b000428f0cb7997743e3f04b.png',
                          width: 160,
                          height: 160,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Main Content Section
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Address Section
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: colors.bg_black,
                      width: 2,
                    ),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enjoy your trip with glorious serve from harijumat.co!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.4,
                      ),
                    ),
                    Text(
                      'JL Raya Pajajaran No.88,',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Kel. Tanah Sareal, Kec. Bogor Tengah,',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Kota Bogor, Jawa Barat, 16127, Indonesia',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '+62-891827-23293',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Perusahaan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: colors.bg_black,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Komunitas',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: colors.bg_black,
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(

            children: [
              socialIconHuge(
                icon: HugeIcons.strokeRoundedLinkedin02, // Hapus prefix huge_icons.
                color: colors.bg_black,
              ),
              const SizedBox(width: 10),
              socialIconHuge(
                icon: HugeIcons.strokeRoundedInstagram,
                color: colors.bg_black,
              ),
              const SizedBox(width: 10),
              socialIconHuge(
                icon: HugeIcons.strokeRoundedTwitter,
                color: colors.bg_black,
              ),
              const SizedBox(width: 10),
              socialIconHuge(
                icon: HugeIcons.strokeRoundedFacebook02,
                color: colors.bg_black,
              ),
            ],
          ),
          // Footer Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 1,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                '@2026 Kwetiau Siram All Rights Reserved',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget untuk social icon
Widget socialIconHuge({
  required dynamic icon, // Bisa berupa String atau List<List<dynamic>>
  required Color color,
}) {
  return Container(
    width: 36,
    height: 36,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: color,
        width: 1.4,
      ),
    ),
    child: Center(
      child: HugeIcon(
        icon: icon, // Parameter bernama 'icon'
        size: 18.0, // Tambahkan titik desimal
        color: color,
        strokeWidth: 2.5, // Sesuaikan strokeWidth sesuai dokumentasi
      ),
    ),
  );
}