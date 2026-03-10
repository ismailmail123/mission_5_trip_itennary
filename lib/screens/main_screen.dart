import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trips/screens/booking_screen.dart';
import 'package:trips/screens/home_screen.dart';
import 'package:trips/screens/dashboard_screen.dart';
import 'package:trips/screens/manage_trips_screen.dart';
import 'package:trips/screens/profile_screen.dart';
import 'package:trips/screens/trip_plan_screen.dart';
import 'package:trips/screens/login_screen.dart';
import 'package:trips/style/app_colors.dart';
import 'package:trips/style/font_style.dart';
import 'package:trips/models/trip_model.dart';
import 'package:trips/providers/auth/auth_controller.dart';

class MainScreen extends ConsumerStatefulWidget {
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
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;
  bool _isInitialized = false;
  late List<Widget> _widgetOptions = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _initializePages();
    }
  }

  void _initializePages() {
    final colors = AppColors.of(context);

    _widgetOptions = [
      DashboardScreen(
        onNavigateToTripPlan: _navigateToTripPlan,
        onNavigateToManageTrips: _navigateToManageTrips,
      ),
      const HomeScreen(),
      const MyBookingsScreen(),
      ProfileScreen(
        onThemeToggle: widget.onThemeToggle,
        themeIcon: widget.themeIcon,
        themeDescription: widget.themeDescription,
        isDarkMode: widget.isDarkMode,
      ),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _isInitialized = true);
    });
  }

  void _navigateToScreen(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  void _navigateToManageTrips() {
    _navigateToScreen(const ManageTripsScreen()); // tanpa tema
  }

  void _navigateToTripPlan(TripModel trip) {
    _navigateToScreen(TripPlanScreen(trip: trip)); // tanpa tema
  }

  void _onItemTapped(int index) {
    if (index < 0 || index >= _widgetOptions.length) return;
    setState(() => _selectedIndex = index);
  }

  Widget _getCurrentScreen() {
    if (!_isInitialized || _widgetOptions.isEmpty) {
      final colors = AppColors.of(context);
      return Scaffold(
        backgroundColor: colors.background,
        body: Center(child: CircularProgressIndicator(color: colors.primary)),
      );
    }
    if (_selectedIndex < 0 || _selectedIndex >= _widgetOptions.length) return _widgetOptions[0];
    return _widgetOptions[_selectedIndex];
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isAuthenticated = authState.isAuthenticated;

    if (!isAuthenticated && _isInitialized) {
      return const LoginScreen(); // tanpa tema
    }

    return Scaffold(
      body: _getCurrentScreen(),
      floatingActionButton: _isInitialized && isAuthenticated
          ? FloatingActionButton(
        onPressed: _navigateToManageTrips,
        backgroundColor: AppColors.of(context).primary,
        foregroundColor: AppColors.of(context).onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.manage_search, size: 28),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _isInitialized && _widgetOptions.isNotEmpty && isAuthenticated
          ? _buildBottomAppBarWithNotch(context)
          : null,
    );
  }

  Widget _buildBottomAppBarWithNotch(BuildContext context) {
    final colors = AppColors.of(context);
    final mediaQuery = MediaQuery.of(context);

    return BottomAppBar(
      height: 80 + mediaQuery.padding.bottom,
      color: colors.surface,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      padding: EdgeInsets.only(bottom: mediaQuery.padding.bottom),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(context, 0, Icons.home_outlined, Icons.home_rounded, 'Home'),
            _buildNavItem(context, 1, Icons.explore_outlined, Icons.explore, 'Explore'),
            const SizedBox(width: 48),
            _buildNavItem(context, 2, Icons.bookmark_border, Icons.bookmark, 'Saved'),
            _buildNavItem(context, 3, Icons.settings, Icons.settings, 'Setting'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, IconData activeIcon, String label) {
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
            Icon(isActive ? activeIcon : icon, color: isActive ? colors.primary : colors.textSecondary, size: 24),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 11, color: isActive ? colors.primary : colors.textSecondary, fontWeight: isActive ? FontWeight.w600 : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}