import 'package:flutter/material.dart';
import 'package:trips/screens/home_screen.dart';
import 'package:trips/screens/dashboard_screen.dart';
import 'package:trips/screens/manage_trips_screen.dart';
import 'package:trips/screens/trip_plan_screen.dart';
import 'package:trips/style/app_colors.dart';
import 'package:trips/style/font_style.dart';
import 'package:trips/models/trip_model.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main';

  final VoidCallback onThemeToggle;
  final IconData themeIcon;
  final String themeDescription;
  final bool isDarkMode;

  const MainScreen({
    super.key,
    required this.onThemeToggle,
    required this.themeIcon,
    required this.themeDescription,
    required this.isDarkMode,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _isInitialized = false;
  late List<Widget> _widgetOptions = [];

  // Daftar app bar title untuk setiap tab
  final List<String> _appBarTitles = [
    'Home',
    'Explore',
    'Saved',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();
    // Hanya set flag, inisialisasi akan dilakukan di didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Inisialisasi halaman di sini karena context sudah tersedia
    if (!_isInitialized) {
      _initializePages();
    }
  }

  void _initializePages() {
    // Placeholder screens (tanpa context)
    final placeholderSaved = _buildPlaceholderScreenInternal(
      'Saved Trips',
      Icons.bookmark,
      'Your saved trips will appear here',
    );

    final placeholderProfile = _buildPlaceholderScreenInternal(
      'Profile',
      Icons.person,
      'Profile settings coming soon',
    );

    // Mengakses context
    final colors = AppColors.of(context);
    final texts = AppColors.of(context);

    _widgetOptions = [
      // Home Screen - TAB 0
      HomeScreen(
        onThemeToggle: widget.onThemeToggle,
        isDarkMode: widget.isDarkMode,
        themeIcon: widget.themeIcon,
        themeDescription: widget.themeDescription,
      ),

      // Dashboard/Explore Screen - TAB 1
      DashboardScreen(
        onThemeToggle: widget.onThemeToggle,
        themeIcon: widget.themeIcon,
        themeDescription: widget.themeDescription,
        isDarkMode: widget.isDarkMode,
        onNavigateToTripPlan: _navigateToTripPlan,
        onNavigateToManageTrips: _navigateToManageTrips,
      ),

      // Saved Screen (Placeholder) - TAB 2
      placeholderSaved,

      // Profile Screen (Placeholder) - TAB 3
      placeholderProfile,
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    });
  }

  // =========== PLACEHOLDER SCREEN INTERNAL - FIXED VERSION ===========
  Widget _buildPlaceholderScreenInternal(
      String title,
      IconData icon,
      String message,
      ) {
    return Builder(
      builder: (BuildContext context) {
        final colors = AppColors.of(context);
        final mediaQuery = MediaQuery.of(context);

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: mediaQuery.size.height -
                  mediaQuery.padding.top -
                  mediaQuery.padding.bottom -
                  80, // untuk bottom navigation bar
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Header section
                Padding(
                  padding: EdgeInsets.only(
                    top: mediaQuery.padding.top + 16,
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          widget.themeIcon,
                          color: colors.primary,
                        ),
                        onPressed: widget.onThemeToggle,
                      ),
                    ],
                  ),
                ),

                // Content section
                Container(
                  padding: const EdgeInsets.all(20),
                  constraints: BoxConstraints(
                    minHeight: mediaQuery.size.height * 0.6,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: colors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            size: 48,
                            color: colors.primary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: colors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 32),
                        if (title == 'Saved Trips')
                          ElevatedButton(
                            onPressed: () {
                              // Navigasi ke dashboard untuk melihat trips
                              _onItemTapped(1);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Browse Trips',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Spacer untuk bottom navigation bar
                SizedBox(
                  height: 80 + mediaQuery.padding.bottom,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Method untuk navigasi ke halaman TANPA navigation bar
  void _navigateToScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  // Method untuk navigasi ke ManageTripsScreen
  void _navigateToManageTrips() {
    _navigateToScreen(
      ManageTripsScreen(
        onThemeToggle: widget.onThemeToggle,
        isDarkMode: widget.isDarkMode,
        themeIcon: widget.themeIcon,
        themeDescription: widget.themeDescription,
      ),
    );
  }

  // Method untuk navigasi ke TripPlanScreen
  void _navigateToTripPlan(TripModel trip) {
    _navigateToScreen(
      TripPlanScreen(
        trip: trip,
        onThemeToggle: widget.onThemeToggle,
        themeIcon: widget.themeIcon,
        themeDescription: widget.themeDescription,
        isDarkMode: widget.isDarkMode,
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index < 0 || index >= _widgetOptions.length) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getCurrentScreen() {
    if (!_isInitialized || _widgetOptions.isEmpty) {
      final colors = AppColors.of(context);
      return Scaffold(
        backgroundColor: colors.background,
        body: Center(
          child: CircularProgressIndicator(
            color: colors.primary,
          ),
        ),
      );
    }

    if (_selectedIndex < 0 || _selectedIndex >= _widgetOptions.length) {
      return _widgetOptions[0];
    }

    return _widgetOptions[_selectedIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getCurrentScreen(),

      // =========== FLOATING ACTION BUTTON ===========
      // FAB SELALU TAMPIL di semua tab
      floatingActionButton: _isInitialized
          ? FloatingActionButton(
        onPressed: _navigateToManageTrips,
        backgroundColor: AppColors.of(context).primary,
        foregroundColor: AppColors.of(context).onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.manage_search, size: 28),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // =========== BOTTOM APP BAR DENGAN NOTCH ===========
      bottomNavigationBar: _isInitialized && _widgetOptions.isNotEmpty
          ? _buildBottomAppBarWithNotch(context)
          : null,
    );
  }

  // =========== BOTTOM APP BAR DENGAN NOTCH UNTUK FAB ===========
  Widget _buildBottomAppBarWithNotch(BuildContext context) {
    final colors = AppColors.of(context);
    final mediaQuery = MediaQuery.of(context);

    return BottomAppBar(
      height: 80 + mediaQuery.padding.bottom, // Tambah padding bottom untuk safe area
      color: colors.surface,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      padding: EdgeInsets.only(
        bottom: mediaQuery.padding.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home - TAB 0
            _buildNavItem(
              context: context,
              index: 0,
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: 'Home',
            ),

            // Explore - TAB 1
            _buildNavItem(
              context: context,
              index: 1,
              icon: Icons.explore_outlined,
              activeIcon: Icons.explore,
              label: 'Explore',
            ),

            // Spacer untuk FAB di tengah
            const SizedBox(width: 48),

            // Saved - TAB 2
            _buildNavItem(
              context: context,
              index: 2,
              icon: Icons.bookmark_border,
              activeIcon: Icons.bookmark,
              label: 'Saved',
            ),

            // Profile - TAB 3
            _buildNavItem(
              context: context,
              index: 3,
              icon: Icons.person_outlined,
              activeIcon: Icons.person_rounded,
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  // =========== CUSTOM NAVIGATION ITEM ===========
  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final colors = AppColors.of(context);
    final isActive = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? colors.primary : colors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isActive ? colors.primary : colors.textSecondary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}