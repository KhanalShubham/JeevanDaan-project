import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jeevandaan/app/themes/theme_mode_notifier.dart';
import 'package:jeevandaan/app/user_notifier.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';
import 'package:jeevandaan/features/setting/domain/use_case/change_password_use_case.dart';
import 'package:jeevandaan/features/setting/domain/use_case/update_profile_use_case.dart';
import 'package:jeevandaan/app/service_locator/service_locator.dart';
import 'package:jeevandaan/app/shared_pref/token_shared_prefs.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          Consumer<UserNotifier>(
            builder: (context, userNotifier, _) {
              final UserEntity? user = userNotifier.user;
              if (user == null) {
                return const SizedBox();
              }
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            child: Text(
                              user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user.name, style: theme.textTheme.titleLarge),
                                Text(user.email, style: theme.textTheme.bodyMedium),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.phone, size: 18, color: theme.colorScheme.primary),
                          const SizedBox(width: 6),
                          Text(user.contact, style: theme.textTheme.bodyMedium),
                          const SizedBox(width: 16),
                          Icon(Icons.medical_services, size: 18, color: theme.colorScheme.primary),
                          const SizedBox(width: 6),
                          Text(user.disease, style: theme.textTheme.bodyMedium),
                        ],
                      ),
                      if (user.description.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(user.description, style: theme.textTheme.bodyMedium),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
          // Theme Switcher
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: ListTile(
              leading: Icon(Icons.brightness_6_rounded, color: theme.colorScheme.primary),
              title: const Text('Theme Mode'),
              trailing: Consumer<ThemeModeNotifier>(
                builder: (context, themeNotifier, _) {
                  return Switch(
                    value: themeNotifier.themeMode == ThemeMode.dark,
                    onChanged: (isDark) {
                      themeNotifier.setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
                    },
                    activeColor: theme.colorScheme.primary,
                  );
                },
              ),
            ),
          ),
          // Update Name
          _settingsTile(context, icon: Icons.person, title: 'Update Name', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UpdateNamePage()))),
          // Update Description
          _settingsTile(context, icon: Icons.description, title: 'Update Description', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UpdateDescriptionPage()))),
          // Update Contact
          _settingsTile(context, icon: Icons.phone, title: 'Update Contact', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UpdateContactPage()))),
          // Update Disease
          _settingsTile(context, icon: Icons.medical_services, title: 'Update Disease', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UpdateDiseasePage()))),
          // Update Password
          _settingsTile(context, icon: Icons.lock, title: 'Update Password', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UpdatePasswordPage()))),
          // About App
          _settingsTile(context, icon: Icons.info_outline, title: 'About This App', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutAppPage()))),
          // Help & Support
          _settingsTile(context, icon: Icons.help_outline, title: 'Help & Support', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpSupportPage()))),
          // About Me
          _settingsTile(context, icon: Icons.account_circle, title: 'About Me', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutMePage()))),
          // Privacy Policy
          _settingsTile(context, icon: Icons.privacy_tip, title: 'Privacy Policy', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()))),
          // Terms of Service
          _settingsTile(context, icon: Icons.gavel, title: 'Terms of Service', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsOfServicePage()))),
          // Feedback
          _settingsTile(context, icon: Icons.feedback, title: 'Feedback', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FeedbackPage()))),
          // FAQ
          _settingsTile(context, icon: Icons.question_answer, title: 'FAQ', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FAQPage()))),
          // Logout
          _settingsTile(context, icon: Icons.logout, title: 'Logout', onTap: () async {
            final shouldLogout = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
            if (shouldLogout == true) {
              // TODO: Implement actual logout logic
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged out!')));
            }
          }, color: Colors.red),
        ],
      ),
    );
  }

  Widget _settingsTile(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap, Color? color}) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: color ?? theme.colorScheme.primary),
        title: Text(title, style: theme.textTheme.titleMedium?.copyWith(color: color ?? theme.colorScheme.onSurface)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: theme.colorScheme.primary),
        onTap: onTap,
      ),
    );
  }
}

// --- Placeholder Pages ---
class UpdateNamePage extends StatefulWidget {
  const UpdateNamePage({super.key});
  @override
  State<UpdateNamePage> createState() => _UpdateNamePageState();
}

class _UpdateNamePageState extends State<UpdateNamePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserNotifier>(context, listen: false).user;
    _nameController = TextEditingController(text: user?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Update Name')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red))),
                      if (!_isLoading)
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.red),
                          onPressed: () => setState(() => _errorMessage = null),
                        ),
                    ],
                  ),
                ),
              ],
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Name cannot be empty' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                              _errorMessage = null;
                            });
                            final userNotifier = Provider.of<UserNotifier>(context, listen: false);
                            final user = userNotifier.user;
                            if (user == null) return;
                            try {
                              final tokenSharedPrefs = serviceLocator<TokenSharedPrefs>();
                              final tokenResult = await tokenSharedPrefs.getToken();
                              String? token;
                              tokenResult.fold((failure) => token = null, (t) => token = t);
                              if (token == null || token!.isEmpty) {
                                setState(() => _errorMessage = 'User not authenticated!');
                                setState(() => _isLoading = false);
                                return;
                              }
                              final updateProfileUseCase = serviceLocator<UpdateProfileUseCase>();
                              final updatedUser = await updateProfileUseCase(
                                token!,
                                name: _nameController.text,
                                description: user.description,
                                contact: user.contact,
                                disease: user.disease,
                              );
                              updatedUser.fold(
                                (failure) => setState(() => _errorMessage = failure.message ?? 'Failed to update name.'),
                                (newUser) {
                                  userNotifier.setUser(newUser);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Name updated!'), backgroundColor: Colors.green));
                                  Navigator.pop(context);
                                },
                              );
                            } catch (e) {
                              setState(() => _errorMessage = 'Unexpected error: $e');
                            } finally {
                              setState(() => _isLoading = false);
                            }
                          }
                        },
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpdateDiseasePage extends StatefulWidget {
  const UpdateDiseasePage({super.key});
  @override
  State<UpdateDiseasePage> createState() => _UpdateDiseasePageState();
}

class _UpdateDiseasePageState extends State<UpdateDiseasePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _diseaseController;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserNotifier>(context, listen: false).user;
    _diseaseController = TextEditingController(text: user?.disease ?? '');
  }

  @override
  void dispose() {
    _diseaseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Update Disease')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red))),
                      if (!_isLoading)
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.red),
                          onPressed: () => setState(() => _errorMessage = null),
                        ),
                    ],
                  ),
                ),
              ],
              TextFormField(
                controller: _diseaseController,
                decoration: const InputDecoration(labelText: 'Disease', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Disease cannot be empty' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                              _errorMessage = null;
                            });
                            final userNotifier = Provider.of<UserNotifier>(context, listen: false);
                            final user = userNotifier.user;
                            if (user == null) return;
                            try {
                              final tokenSharedPrefs = serviceLocator<TokenSharedPrefs>();
                              final tokenResult = await tokenSharedPrefs.getToken();
                              String? token;
                              tokenResult.fold((failure) => token = null, (t) => token = t);
                              if (token == null || token!.isEmpty) {
                                setState(() => _errorMessage = 'User not authenticated!');
                                setState(() => _isLoading = false);
                                return;
                              }
                              final updateProfileUseCase = serviceLocator<UpdateProfileUseCase>();
                              final updatedUser = await updateProfileUseCase(
                                token!,
                                name: user.name,
                                description: user.description,
                                contact: user.contact,
                                disease: _diseaseController.text,
                              );
                              updatedUser.fold(
                                (failure) => setState(() => _errorMessage = failure.message ?? 'Failed to update disease.'),
                                (newUser) {
                                  userNotifier.setUser(newUser);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Disease updated!'), backgroundColor: Colors.green));
                                  Navigator.pop(context);
                                },
                              );
                            } catch (e) {
                              setState(() => _errorMessage = 'Unexpected error: $e');
                            } finally {
                              setState(() => _isLoading = false);
                            }
                          }
                        },
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpdateContactPage extends StatefulWidget {
  const UpdateContactPage({super.key});
  @override
  State<UpdateContactPage> createState() => _UpdateContactPageState();
}

class _UpdateContactPageState extends State<UpdateContactPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _contactController;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserNotifier>(context, listen: false).user;
    _contactController = TextEditingController(text: user?.contact ?? '');
  }

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Update Contact')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red))),
                      if (!_isLoading)
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.red),
                          onPressed: () => setState(() => _errorMessage = null),
                        ),
                    ],
                  ),
                ),
              ],
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(labelText: 'Contact', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Contact cannot be empty' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                              _errorMessage = null;
                            });
                            final userNotifier = Provider.of<UserNotifier>(context, listen: false);
                            final user = userNotifier.user;
                            if (user == null) return;
                            try {
                              final tokenSharedPrefs = serviceLocator<TokenSharedPrefs>();
                              final tokenResult = await tokenSharedPrefs.getToken();
                              String? token;
                              tokenResult.fold((failure) => token = null, (t) => token = t);
                              if (token == null || token!.isEmpty) {
                                setState(() => _errorMessage = 'User not authenticated!');
                                setState(() => _isLoading = false);
                                return;
                              }
                              final updateProfileUseCase = serviceLocator<UpdateProfileUseCase>();
                              final updatedUser = await updateProfileUseCase(
                                token!,
                                name: user.name,
                                description: user.description,
                                contact: _contactController.text,
                                disease: user.disease,
                              );
                              updatedUser.fold(
                                (failure) => setState(() => _errorMessage = failure.message ?? 'Failed to update contact.'),
                                (newUser) {
                                  userNotifier.setUser(newUser);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contact updated!'), backgroundColor: Colors.green));
                                  Navigator.pop(context);
                                },
                              );
                            } catch (e) {
                              setState(() => _errorMessage = 'Unexpected error: $e');
                            } finally {
                              setState(() => _isLoading = false);
                            }
                          }
                        },
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpdateDescriptionPage extends StatefulWidget {
  const UpdateDescriptionPage({super.key});
  @override
  State<UpdateDescriptionPage> createState() => _UpdateDescriptionPageState();
}

class _UpdateDescriptionPageState extends State<UpdateDescriptionPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserNotifier>(context, listen: false).user;
    _descriptionController = TextEditingController(text: user?.description ?? '');
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Update Description')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red))),
                      if (!_isLoading)
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.red),
                          onPressed: () => setState(() => _errorMessage = null),
                        ),
                    ],
                  ),
                ),
              ],
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty ? 'Description cannot be empty' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                              _errorMessage = null;
                            });
                            final userNotifier = Provider.of<UserNotifier>(context, listen: false);
                            final user = userNotifier.user;
                            if (user == null) return;
                            try {
                              final tokenSharedPrefs = serviceLocator<TokenSharedPrefs>();
                              final tokenResult = await tokenSharedPrefs.getToken();
                              String? token;
                              tokenResult.fold((failure) => token = null, (t) => token = t);
                              if (token == null || token!.isEmpty) {
                                setState(() => _errorMessage = 'User not authenticated!');
                                setState(() => _isLoading = false);
                                return;
                              }
                              final updateProfileUseCase = serviceLocator<UpdateProfileUseCase>();
                              final updatedUser = await updateProfileUseCase(
                                token!,
                                name: user.name,
                                description: _descriptionController.text,
                                contact: user.contact,
                                disease: user.disease,
                              );
                              updatedUser.fold(
                                (failure) => setState(() => _errorMessage = failure.message ?? 'Failed to update description.'),
                                (newUser) {
                                  userNotifier.setUser(newUser);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Description updated!'), backgroundColor: Colors.green));
                                  Navigator.pop(context);
                                },
                              );
                            } catch (e) {
                              setState(() => _errorMessage = 'Unexpected error: $e');
                            } finally {
                              setState(() => _isLoading = false);
                            }
                          }
                        },
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Static Pages ---
class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});
  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Update Password')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red))),
                      if (!_isLoading)
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.red),
                          onPressed: () => setState(() => _errorMessage = null),
                        ),
                    ],
                  ),
                ),
              ],
              TextFormField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Current Password', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Current password required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New Password', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'New password required';
                  if (value.length < 6) return 'At least 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirm New Password', border: OutlineInputBorder()),
                validator: (value) {
                  if (value != _newPasswordController.text) return 'Passwords do not match';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                              _errorMessage = null;
                            });
                            try {
                              final changePasswordUseCase = serviceLocator<ChangePasswordUseCase>();
                              await changePasswordUseCase(ChangePasswordParams(
                                currentPassword: _currentPasswordController.text,
                                newPassword: _newPasswordController.text,
                              ));
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password updated!'), backgroundColor: Colors.green));
                              Navigator.pop(context);
                            } catch (e) {
                              setState(() => _errorMessage = 'Unexpected error: $e');
                            } finally {
                              setState(() => _isLoading = false);
                            }
                          }
                        },
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('About This App')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Column(
              children: [
                SvgPicture.asset('assets/images/card.svg', height: 120),
                const SizedBox(height: 16),
                Text('Jeevan Daan', style: theme.textTheme.headlineLarge),
                const SizedBox(height: 8),
                Text('A modern, green-themed app for hope and healing.', style: theme.textTheme.bodyLarge),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [Icon(Icons.verified, color: theme.colorScheme.primary), const SizedBox(width: 8), Text('Key Features', style: theme.textTheme.titleMedium)]),
                        const SizedBox(height: 8),
                        Text('• Real-time profile updates\n• Secure chat\n• Request management\n• Beautiful UI\n• And more!', style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 16),
                        Row(children: [Icon(Icons.info_outline, color: theme.colorScheme.primary), const SizedBox(width: 8), Text('Version 1.0.0', style: theme.textTheme.bodyMedium)]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Column(
              children: [
                SvgPicture.asset('assets/images/help.svg', height: 120),
                const SizedBox(height: 16),
                Text('Need help?', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text('Contact us at support@jeevandaan.com or check the FAQ below.', style: theme.textTheme.bodyLarge),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Frequently Asked Questions', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text('Q: How do I update my profile?\nA: Go to Settings > Update Profile.\n\nQ: How do I contact support?\nA: Email us at support@jeevandaan.com.', style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AboutMePage extends StatelessWidget {
  const AboutMePage({super.key});
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserNotifier>(context).user;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('About Me')),
      body: user == null
          ? const Center(child: Text('No user info available.'))
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(radius: 48, child: Text(user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U', style: theme.textTheme.headlineLarge)),
                      const SizedBox(height: 16),
                      Text(user.name, style: theme.textTheme.headlineMedium),
                      Text(user.email, style: theme.textTheme.bodyLarge),
                      const SizedBox(height: 16),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [Icon(Icons.phone, color: theme.colorScheme.primary), const SizedBox(width: 8), Text(user.contact, style: theme.textTheme.bodyMedium)]),
                              const SizedBox(height: 8),
                              Row(children: [Icon(Icons.medical_services, color: theme.colorScheme.primary), const SizedBox(width: 8), Text(user.disease, style: theme.textTheme.bodyMedium)]),
                              if (user.description.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(user.description, style: theme.textTheme.bodyMedium),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Column(
              children: [
                SvgPicture.asset('assets/images/privacy.svg', height: 120),
                const SizedBox(height: 16),
                Text('Your Privacy Matters', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text('We respect your privacy and protect your data.\n\nSample policy: We do not share your information with third parties. All data is encrypted and securely stored.', style: theme.textTheme.bodyLarge),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('For more details, contact privacy@jeevandaan.com.', style: theme.textTheme.bodyMedium),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Service')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Column(
              children: [
                SvgPicture.asset('assets/images/terms.svg', height: 120),
                const SizedBox(height: 16),
                Text('Terms of Service', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text('By using Jeevan Daan, you agree to our terms.\n\nSample terms: Use the app responsibly. Do not misuse features. Respect other users.', style: theme.textTheme.bodyLarge),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('For full terms, visit our website or contact legal@jeevandaan.com.', style: theme.textTheme.bodyMedium),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final _feedbackController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Column(
              children: [
                SvgPicture.asset('assets/images/feedback.svg', height: 120),
                const SizedBox(height: 16),
                Text('We value your feedback!', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text('Let us know what you think about Jeevan Daan.', style: theme.textTheme.bodyLarge),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _feedbackController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: 'Your feedback',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_feedbackController.text.isNotEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thank you for your feedback!'), backgroundColor: Colors.green));
                                _feedbackController.clear();
                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('FAQ')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Column(
              children: [
                SvgPicture.asset('assets/images/faq.svg', height: 120),
                const SizedBox(height: 16),
                Text('Frequently Asked Questions', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Q: How do I update my profile?', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text('A: Go to Settings > Update Profile and edit your details.', style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 16),
                        Text('Q: How do I contact support?', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text('A: Email us at support@jeevandaan.com.', style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 16),
                        Text('Q: Is my data secure?', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text('A: Yes, all your data is encrypted and securely stored.', style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSubPage extends StatelessWidget {
  final String title;
  final Widget child;
  const _SettingsSubPage({required this.title, required this.child});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
