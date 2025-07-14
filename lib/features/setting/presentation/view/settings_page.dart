import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/features/setting/presentation/view/about_page.dart';
import 'package:jeevandaan/features/setting/presentation/view/change_password_page.dart';
import 'package:jeevandaan/features/setting/presentation/view/help_support_page.dart';
import 'package:jeevandaan/features/setting/presentation/view/update_profile_page.dart';
import 'package:jeevandaan/features/setting/presentation/view_model/settings_view_model.dart';
import 'package:jeevandaan/features/setting/presentation/widgets/settings_list_item.dart';
import 'package:jeevandaan/features/user/presentation/view/login.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<SettingsViewModel>()..add(LoadUserDetails()),
      child: const SettingsView(),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: BlocListener<SettingsViewModel, SettingsState>(
        listener: (context, state) {
          if (state.status == SettingsStatus.loggedOut) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Login()),
              (route) => false,
            );
          }
        },
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<SettingsViewModel>().add(LoadUserDetails());
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "ACCOUNT",
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // ✅ --- MODIFIED ONTAP LOGIC --- ✅
                        SettingsListItem(
                          icon: CupertinoIcons.person_fill,
                          title: "Edit Profile",
                          onTap: () async { // Make onTap async
                            // Navigate and wait for a result.
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const UpdateProfilePage()),
                            );

                            // If the result is 'true', the update was successful.
                            if (result == true) {
                              // Show the success message here, safely.
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Profile was updated!"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              // Refresh the user details on this page.
                              context.read<SettingsViewModel>().add(LoadUserDetails());
                            }
                          },
                        ),
                        const Divider(height: 1, indent: 50),
                        SettingsListItem(
                          icon: CupertinoIcons.lock_shield_fill,
                          title: "Change Password",
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => const ChangePasswordPage()));
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "SUPPORT & ABOUT",
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        SettingsListItem(
                          icon: CupertinoIcons.question_circle_fill,
                          title: "Help & Support",
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => const HelpSupportPage()));
                          },
                        ),
                        const Divider(height: 1, indent: 50),
                        SettingsListItem(
                          icon: CupertinoIcons.info_circle_fill,
                          title: "About Jeevandaan",
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => const AboutPage()));
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SettingsListItem(
                      icon: CupertinoIcons.arrow_right_square_fill,
                      title: "Logout",
                      onTap: () {
                        context.read<SettingsViewModel>().add(LogoutRequested());
                      },
                      textColor: Colors.red,
                      hideArrow: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}