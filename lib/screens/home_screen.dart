import 'package:flutter/material.dart';
import 'package:trips/screens/searc_trip_screen.dart';
import 'package:trips/style/app_colors.dart';

class HomeScreen extends StatefulWidget {
  // Hapus parameter tema
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _selectedMonth = 'Sep';
  String _selectedYear = '2025';
  String? _selectedCategory;

  final List<String> months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  final List<String> years = ['2026', '2027'];

  final Map<String, String> _categoryMapping = {
    'Sightseeing': 'Sightseeing',
    'Restaurant': 'Food',
    'Nightlife': 'Nightlife',
    'Hotel': 'Hotel',
    'Shopping': 'Shopping',
    'Cinema': 'Cinema',
  };

  Future<void> _showMonthPicker(BuildContext context) async {
    final colors = AppColors.of(context);

    await showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select Month', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colors.textPrimary)),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.5),
                itemCount: months.length,
                itemBuilder: (context, index) {
                  final month = months[index];
                  final isSelected = month == _selectedMonth;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedMonth = month);
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? colors.primary : colors.card,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isSelected ? colors.primary : colors.border),
                      ),
                      child: Center(
                        child: Text(month,
                            style: TextStyle(color: isSelected ? colors.onPrimary : colors.textPrimary, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showYearPicker(BuildContext context) async {
    final colors = AppColors.of(context);

    await showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select Year', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colors.textPrimary)),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 2),
                itemCount: years.length,
                itemBuilder: (context, index) {
                  final year = years[index];
                  final isSelected = year == _selectedYear;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedYear = year);
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? colors.primary : colors.card,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isSelected ? colors.primary : colors.border),
                      ),
                      child: Center(
                        child: Text(year,
                            style: TextStyle(color: isSelected ? colors.onPrimary : colors.textPrimary, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 16)),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _selectCategory(String category) {
    setState(() {
      if (_selectedCategory == category) {
        _selectedCategory = null;
      } else {
        _selectedCategory = category;
      }
    });
  }

  void _navigateToSearch() {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a category first'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchTripsScreen(
          initialMonth: _selectedMonth,
          initialYear: _selectedYear,
          initialCategory: _selectedCategory!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_back, color: Colors.white, size: 16),
                              SizedBox(width: 4),
                              Text('back', style: TextStyle(color: Colors.white, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                /// PICK UP DATE
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pick up a date!', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: colors.textPrimary)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _showMonthPicker(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: isDark ? colors.surface : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: isDark ? colors.border : Colors.grey.shade300),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(_selectedMonth, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? colors.textPrimary : Colors.black)),
                                  const SizedBox(width: 8),
                                  Icon(Icons.arrow_drop_down, color: isDark ? colors.textPrimary : Colors.black, size: 20),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => _showYearPicker(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: isDark ? colors.surface : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: isDark ? colors.border : Colors.grey.shade300),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(_selectedYear, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? colors.textPrimary : Colors.black)),
                                  const SizedBox(width: 8),
                                  Icon(Icons.arrow_drop_down, color: isDark ? colors.textPrimary : Colors.black, size: 20),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: _navigateToSearch,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
                              child: Text('Book Now!', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// GRID + TITLE
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Center(
                              child: Text(
                                'Add to\nItinerary',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colors.textPrimary),
                              ),
                            ),
                          ),
                        ),
                        SliverGrid(
                          delegate: SliverChildListDelegate(
                            [
                              _GridItem(
                                icon: Icons.photo_camera_outlined,
                                label: 'Sightseeing',
                                isDark: isDark,
                                iconColorLight: colors.textPrimary,
                                isSelected: _selectedCategory == 'Sightseeing',
                                onTap: () => _selectCategory('Sightseeing'),
                              ),
                              _GridItem(
                                icon: Icons.local_cafe_outlined,
                                label: 'Restaurant',
                                isDark: isDark,
                                iconColorLight: colors.textPrimary,
                                isSelected: _selectedCategory == 'Restaurant',
                                onTap: () => _selectCategory('Restaurant'),
                              ),
                              _GridItem(
                                icon: Icons.celebration_outlined,
                                label: 'Nightlife',
                                isDark: isDark,
                                iconColorLight: colors.nightLife,
                                isSelected: _selectedCategory == 'Nightlife',
                                onTap: () => _selectCategory('Nightlife'),
                              ),
                              _GridItem(
                                icon: Icons.apartment_outlined,
                                label: 'Hotel',
                                isDark: isDark,
                                iconColorLight: colors.hotelIcon,
                                isSelected: _selectedCategory == 'Hotel',
                                onTap: () => _selectCategory('Hotel'),
                              ),
                              _GridItem(
                                icon: Icons.shopping_bag_outlined,
                                label: 'Shopping',
                                isDark: isDark,
                                iconColorLight: colors.iconShopping,
                                isSelected: _selectedCategory == 'Shopping',
                                onTap: () => _selectCategory('Shopping'),
                              ),
                              _GridItem(
                                icon: Icons.tv_outlined,
                                label: 'Cinema',
                                isDark: isDark,
                                iconColorLight: colors.iconChinema,
                                isSelected: _selectedCategory == 'Cinema',
                                onTap: () => _selectCategory('Cinema'),
                              ),
                            ],
                          ),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 24,
                            crossAxisSpacing: 24,
                            childAspectRatio: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GridItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool highlight;
  final bool isDark;
  final Color iconColorLight;
  final VoidCallback onTap;
  final bool isSelected;

  const _GridItem({
    required this.icon,
    required this.label,
    this.highlight = false,
    required this.isDark,
    required this.iconColorLight,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(color: colors.primary, width: 3) : (highlight ? Border.all(color: Colors.purple, width: 2) : null),
          boxShadow: [
            BoxShadow(
              color: isSelected ? colors.primary.withOpacity(0.3) : Colors.black.withOpacity(0.1),
              blurRadius: isSelected ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: isSelected ? colors.primary : iconColorLight),
            const SizedBox(height: 12),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: isSelected ? colors.primary : colors.textPrimary)),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Icon(Icons.check_circle, color: colors.primary, size: 16),
              ),
          ],
        ),
      ),
    );
  }
}