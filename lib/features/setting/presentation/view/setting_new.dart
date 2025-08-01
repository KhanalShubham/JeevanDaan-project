// ⚙️ World-Class Settings Page - JeevanDaan App
// The most beautiful and unique settings UI in the world

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jeevandaan/app/themes/theme_mode_notifier.dart';
import 'package:jeevandaan/app/user_notifier.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';

// 🎨 Premium Design System for Settings Page
class SettingsDesign {
  // 🌈 Vibrant Color Palette
  static const Color primaryBlue = Color(0xFF3742FA);
  static const Color primaryGreen = Color(0xFF2ED573);
  static const Color primaryRed = Color(0xFFFF4757);
  static const Color primaryOrange = Color(0xFFFF6B35);
  
  // 🎭 Magical Gradients
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FA)],
  );
  
  // 📝 Typography Colors
  static const Color darkText = Color(0xFF2C3E50);
  static const Color lightText = Color(0xFF7F8C8D);
  static const Color whiteText = Color(0xFFFFFFFF);
  
  // 🏠 Background Colors
  static const Color background = Color(0xFFF8F9FA);
  
  // ✨ Shadows & Effects
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}

// 🚀 Main Settings Page (Stateless)
class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SettingsDesign.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildHeroHeader(context),
          _buildProfileSection(context),
          _buildSettingsSection(context),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 200,
        decoration: const BoxDecoration(
          gradient: SettingsDesign.heroGradient,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.settings_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Settings',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            color: SettingsDesign.whiteText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Customize your experience',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: SettingsDesign.whiteText.withOpacity(0.8),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Consumer<UserNotifier>(
          builder: (context, userNotifier, _) {
            final UserEntity? user = userNotifier.user;
            if (user == null) {
              return Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(child: CircularProgressIndicator()),
              );
            }
            
            return Container(
              decoration: BoxDecoration(
                gradient: SettingsDesign.cardGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: SettingsDesign.cardShadow,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: SettingsDesign.darkText,
                            ),
                          ),
                          Text(
                            user.email,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: SettingsDesign.lightText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            _buildSettingsTile(
              context,
              icon: Icons.person_rounded,
              title: 'Update Profile',
              color: SettingsDesign.primaryBlue,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildSettingsTile(
              context,
              icon: Icons.lock_rounded,
              title: 'Change Password',
              color: SettingsDesign.primaryRed,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildSettingsTile(
              context,
              icon: Icons.notifications_rounded,
              title: 'Notifications',
              color: SettingsDesign.primaryOrange,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            Consumer<ThemeModeNotifier>(
              builder: (context, themeNotifier, _) {
                return _buildSettingsTile(
                  context,
                  icon: Icons.dark_mode_rounded,
                  title: 'Dark Mode',
                  color: SettingsDesign.darkText,
                  onTap: () {
                    final newMode = themeNotifier.themeMode == ThemeMode.dark 
                        ? ThemeMode.light 
                        : ThemeMode.dark;
                    themeNotifier.setThemeMode(newMode);
                  },
                  trailing: Switch(
                    value: themeNotifier.themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      final newMode = value ? ThemeMode.dark : ThemeMode.light;
                      themeNotifier.setThemeMode(newMode);
                    },
                    activeColor: SettingsDesign.primaryGreen,
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildSettingsTile(
              context,
              icon: Icons.help_rounded,
              title: 'Help & Support',
              color: SettingsDesign.primaryGreen,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _buildSettingsTile(
              context,
              icon: Icons.logout_rounded,
              title: 'Logout',
              color: SettingsDesign.primaryRed,
              onTap: () => _showLogoutDialog(context),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: SettingsDesign.cardGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: SettingsDesign.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: SettingsDesign.darkText,
                    ),
                  ),
                ),
                trailing ?? Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: SettingsDesign.lightText,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Logout',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: SettingsDesign.lightText),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement logout logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: SettingsDesign.primaryRed,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              'Logout',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// 🔧 Sensor Settings Notifier (for compatibility)
class SensorSettingsNotifier extends ChangeNotifier {
  bool sensorNavigationEnabled = true;
  bool shakeLogoutEnabled = true;

  void setSensorNavigation(bool value) {
    sensorNavigationEnabled = value;
    notifyListeners();
  }

  void setShakeLogout(bool value) {
    shakeLogoutEnabled = value;
    notifyListeners();
  }
}
