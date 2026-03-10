//ubah tampilan profil dengan tampilan yang lebih detail dan telah disisipkan tombol mode

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trips/providers/auth/auth_controller.dart';
import 'package:trips/providers/theme/theme_controller.dart';
import 'package:trips/style/app_colors.dart';
import 'package:trips/style/font_style.dart';
import 'package:trips/screens/login_screen.dart';
import '../models/user.dart';
import '../providers/auth/auth_controller.dart';
import 'package:trips/providers/auth/auth_controller.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  static const routeName = '/profile';

  final VoidCallback onThemeToggle;
  final IconData themeIcon;
  final String themeDescription;
  final bool isDarkMode;

  const ProfileScreen({
    super.key,
    required this.onThemeToggle,
    required this.themeIcon,
    required this.themeDescription,
    required this.isDarkMode,
  });

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isLoading = false;

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      final authController = ref.read(authProvider.notifier);
      await authController.logout();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to logout: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    List<String> nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }
    return nameParts[0][0].toUpperCase();
  }

  Color _getAvatarColor(String email) {
    final hash = email.hashCode.abs();
    final hue = hash % 360;
    return HSLColor.fromAHSL(1.0, hue.toDouble(), 0.7, 0.5).toColor();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: colors.background,
        elevation: 0,
        // Tombol tema dihapus dari AppBar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: colors.divider, height: 1),
        ),
      ),
      body: authState.isLoading || _isLoading
          ? Center(child: CircularProgressIndicator(color: colors.primary))
          : user == null
          ? _buildNotLoggedInView(colors)
          : _buildSettingsView(colors, user),
    );
  }

  Widget _buildSettingsView(AppColors colors, User user) {
    final avatarColor = _getAvatarColor(user.email);
    final initials = _getInitials(user.name);
    final themeState = ref.watch(themeProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Text(
            'Account',
            style: AppTextStyles.h3(context).copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Profile Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [avatarColor, avatarColor.withBlue(avatarColor.blue + 50)],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: AppTextStyles.h3(context).copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.phone.isEmpty ? 'No phone number' : user.phone,
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Preferences Section
          Text(
            'Preferences',
            style: AppTextStyles.h3(context).copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Theme Toggle Card (dipindahkan ke body)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  widget.themeIcon,
                  color: colors.primary,
                  size: 20,
                ),
              ),
              title: Text(
                'Dark Mode',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                themeState.themeMode == ThemeMode.dark
                    ? 'Currently: Dark'
                    : 'Currently: Light',
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: 12,
                ),
              ),
              trailing: Switch(
                value: themeState.themeMode == ThemeMode.dark,
                onChanged: (_) => widget.onThemeToggle(),
                activeColor: colors.primary,
              ),
              onTap: widget.onThemeToggle,
            ),
          ),

          // Language Setting (example)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.language,
                  color: colors.primary,
                  size: 20,
                ),
              ),
              title: Text(
                'Language',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: const Text(
                'English',
                style: TextStyle(fontSize: 12),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: colors.textSecondary,
              ),
              onTap: () {
                // TODO: Implement language selection
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Language selection coming soon!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ),

          // Notifications Setting (example)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: colors.primary,
                  size: 20,
                ),
              ),
              title: Text(
                'Notifications',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: const Text(
                'Push notifications, email alerts',
                style: TextStyle(fontSize: 12),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: colors.textSecondary,
              ),
              onTap: () {
                // TODO: Implement notifications settings
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notifications settings coming soon!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Account Section
          Text(
            'Account',
            style: AppTextStyles.h3(context).copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Edit Profile
          _buildSettingsTile(
            colors: colors,
            icon: Icons.person_outline,
            label: 'Edit Profile',
            onTap: () {
              // TODO: Implement edit profile
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Edit profile coming soon!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),

          // Change Password
          _buildSettingsTile(
            colors: colors,
            icon: Icons.lock_outline,
            label: 'Change Password',
            onTap: () {
              // TODO: Implement change password
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Change password coming soon!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),

          // Privacy Policy
          _buildSettingsTile(
            colors: colors,
            icon: Icons.privacy_tip_outlined,
            label: 'Privacy Policy',
            onTap: () {
              // TODO: Implement privacy policy
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Privacy policy coming soon!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),

          // Terms of Service
          _buildSettingsTile(
            colors: colors,
            icon: Icons.description_outlined,
            label: 'Terms of Service',
            onTap: () {
              // TODO: Implement terms of service
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Terms of service coming soon!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Info Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Member Since',
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      user.createdAt != null
                          ? '${user.createdAt!.day} ${_getMonthName(user.createdAt!.month)} ${user.createdAt!.year}'
                          : 'Unknown',
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Account Type',
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // child: Text(
                      //   // user. == 'google' ? 'Google' : 'Email',
                      //   style: TextStyle(
                      //     color: colors.primary,
                      //     fontSize: 12,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Danger Zone
          Container(
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.error.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    color: colors.error.withOpacity(0.1),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: colors.error,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Danger Zone',
                        style: TextStyle(
                          color: colors.error,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: colors.error,
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: colors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: _handleLogout,
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: Icon(
                    Icons.delete_outline,
                    color: colors.error,
                  ),
                  title: Text(
                    'Delete Account',
                    style: TextStyle(
                      color: colors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: _handleDeleteAccount,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // App Version
          Center(
            child: Text(
              'Version 1.0.0',
              style: TextStyle(
                color: colors.textSecondary.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required AppColors colors,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: colors.primary,
            size: 20,
          ),
        ),
        title: Text(
          label,
          style: TextStyle(
            color: colors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: colors.textSecondary,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildNotLoggedInView(AppColors colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle,
              size: 100,
              color: colors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Not Logged In',
              style: AppTextStyles.h2(context).copyWith(
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Please login to view your settings',
              style: TextStyle(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.login),
              label: const Text('Login Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleDeleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete Permanently'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      final authController = ref.read(authProvider.notifier);
      await authController.deleteAccount();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account deleted successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete account: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}