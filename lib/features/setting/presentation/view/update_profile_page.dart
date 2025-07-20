import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/app/service_locator/service_locator.dart';
import 'package:jeevandaan/features/setting/presentation/view_model/update_profile_view_model.dart';
import 'package:jeevandaan/features/user/domain/entity/user_entity.dart';
import 'package:provider/provider.dart';
import 'package:jeevandaan/app/user_notifier.dart';

class UpdateProfilePage extends StatelessWidget {
  const UpdateProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<UpdateProfileViewModel>()..add(LoadProfile()),
      child: const UpdateProfileView(),
    );
  }
}

class UpdateProfileView extends StatefulWidget {
  const UpdateProfileView({super.key});

  @override
  State<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _diseaseController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _contactController = TextEditingController();
    _diseaseController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _diseaseController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: BlocConsumer<UpdateProfileViewModel, UpdateProfileState>(
        // ✅ --- NEW, SIMPLIFIED LISTENER --- ✅
        listener: (context, state) {
          if (!mounted) return;

          // Populate fields when data first loads.
          if (state.status == UpdateProfileStatus.success) {
            _nameController.text = state.user?.name ?? '';
            _contactController.text = state.user?.contact ?? '';
            _diseaseController.text = state.user?.disease ?? '';
            _descriptionController.text = state.user?.description ?? '';
          }

          // On success, JUST pop and send back 'true'.
          if (state.status == UpdateProfileStatus.updateSuccess) {
            // Update the global UserNotifier with the new user info
            if (state.user != null) {
              Provider.of<UserNotifier>(context, listen: false).setUser(state.user!);
            }
            Navigator.pop(context, true); // Send 'true' back to SettingsPage.
          }

          // On failure, show the error message here (this is safe).
          if (state.status == UpdateProfileStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error ?? "An unknown error occurred"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == UpdateProfileStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // ... All your TextFormFields remain the same ...
                  TextFormField(
                    controller: _nameController,
                    decoration:
                        const InputDecoration(labelText: "Full Name", border: OutlineInputBorder()),
                    validator: (value) => value!.isEmpty ? 'Name cannot be empty' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _contactController,
                    decoration:
                        const InputDecoration(labelText: "Contact", border: OutlineInputBorder()),
                    validator: (value) => value!.isEmpty ? 'Contact cannot be empty' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _diseaseController,
                    decoration:
                        const InputDecoration(labelText: "Disease", border: OutlineInputBorder()),
                    validator: (value) => value!.isEmpty ? 'Disease cannot be empty' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                        labelText: "Description", border: OutlineInputBorder()),
                    maxLines: 3,
                    validator: (value) => value!.isEmpty ? 'Description cannot be empty' : null,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: state.status == UpdateProfileStatus.submitting
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                final updatedUser = UserEntity(
                                  userId: state.user?.userId,
                                  email: state.user!.email,
                                  password: state.user!.password,
                                  name: _nameController.text,
                                  contact: _contactController.text,
                                  disease: _diseaseController.text,
                                  description: _descriptionController.text,
                                );
                                context
                                    .read<UpdateProfileViewModel>()
                                    .add(SubmitProfile(user: updatedUser));
                              }
                            },
                      child: state.status == UpdateProfileStatus.submitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Save Changes"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}