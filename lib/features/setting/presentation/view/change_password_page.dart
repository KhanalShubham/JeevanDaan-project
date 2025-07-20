import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/app/service_locator/service_locator.dart';
import 'package:jeevandaan/features/setting/presentation/view_model/change_password_view_model.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<ChangePasswordViewModel>(),
      child: const ChangePasswordView(),
    );
  }
}

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change Password")),
      body: BlocListener<ChangePasswordViewModel, ChangePasswordState>(
        listener: (context, state) {
          if (state.status == ChangePasswordStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("Password changed successfully!"), backgroundColor: Colors.green),
            );
            Navigator.pop(context);
          }
          if (state.status == ChangePasswordStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.error ?? "An error occurred"), backgroundColor: Colors.red),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: "Current Password", border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty ? 'Cannot be empty' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: "New Password", border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Cannot be empty';
                    if (value.length < 6) return 'Must be at least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: "Confirm New Password", border: OutlineInputBorder()),
                  validator: (value) {
                    if (value != _newPasswordController.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: BlocBuilder<ChangePasswordViewModel, ChangePasswordState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state.status == ChangePasswordStatus.submitting
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<ChangePasswordViewModel>().add(
                                        PasswordChangeSubmitted(
                                          currentPassword: _currentPasswordController.text,
                                          newPassword: _newPasswordController.text,
                                        ),
                                      );
                                }
                              },
                        child: state.status == ChangePasswordStatus.submitting
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Update Password"),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}