import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/setting_view_model.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final _profileFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contactController = TextEditingController();
  final _diseaseController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  String? token;

  @override
  void initState() {
    super.initState();
    // TODO: Replace with your actual token retrieval logic
    token = "YOUR_AUTH_TOKEN_HERE";
    if (token != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<SettingViewModel>(context, listen: false).loadProfile(token!);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _contactController.dispose();
    _diseaseController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingViewModel>(
      builder: (context, vm, child) {
        if (vm.isLoading && vm.user == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (vm.user != null) {
          _nameController.text = vm.user!.name;
          _descriptionController.text = vm.user!.description;
          _contactController.text = vm.user!.contact;
          _diseaseController.text = vm.user!.disease;
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Profile", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Form(
                key: _profileFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: "Name"),
                      validator: (v) => v == null || v.isEmpty ? 'Name required' : null,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: "Description"),
                    ),
                    TextFormField(
                      controller: _contactController,
                      decoration: const InputDecoration(labelText: "Contact"),
                      validator: (v) => v == null || v.isEmpty ? 'Contact required' : null,
                    ),
                    TextFormField(
                      controller: _diseaseController,
                      decoration: const InputDecoration(labelText: "Disease"),
                      validator: (v) => v == null || v.isEmpty ? 'Disease required' : null,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: vm.isLoading
                          ? null
                          : () {
                              if (_profileFormKey.currentState!.validate() && token != null) {
                                vm.updateProfile(
                                  token!,
                                  name: _nameController.text,
                                  description: _descriptionController.text,
                                  contact: _contactController.text,
                                  disease: _diseaseController.text,
                                );
                              }
                            },
                      child: const Text("Update Profile"),
                    ),
                  ],
                ),
              ),
              const Divider(height: 32),
              Text("Change Password", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Form(
                key: _passwordFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _currentPasswordController,
                      decoration: const InputDecoration(labelText: "Current Password"),
                      obscureText: true,
                      validator: (v) => v == null || v.isEmpty ? 'Current password required' : null,
                    ),
                    TextFormField(
                      controller: _newPasswordController,
                      decoration: const InputDecoration(labelText: "New Password"),
                      obscureText: true,
                      validator: (v) => v == null || v.isEmpty ? 'New password required' : null,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: vm.isLoading
                          ? null
                          : () {
                              if (_passwordFormKey.currentState!.validate() && token != null) {
                                vm.changePassword(
                                  token!,
                                  _currentPasswordController.text,
                                  _newPasswordController.text,
                                );
                                _currentPasswordController.clear();
                                _newPasswordController.clear();
                              }
                            },
                      child: const Text("Change Password"),
                    ),
                  ],
                ),
              ),
              if (vm.error != null) ...[
                const SizedBox(height: 16),
                Text(vm.error!, style: const TextStyle(color: Colors.red)),
              ],
              if (vm.successMessage != null) ...[
                const SizedBox(height: 16),
                Text(vm.successMessage!, style: const TextStyle(color: Colors.green)),
              ],
            ],
          ),
        );
      },
    );
  }
}
