import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/app/service_locator/service_locator.dart';
import 'package:jeevandaan/features/user/presentation/view/login.dart' hide serviceLocator;
import 'package:jeevandaan/features/user/presentation/view_model/register_view_model/signup_event.dart';
import 'package:jeevandaan/features/user/presentation/view_model/register_view_model/signup_state.dart';
import 'package:jeevandaan/features/user/presentation/view_model/register_view_model/signup_view_model.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<SignupViewModel>(),
      child: const SignupView(),
    );
  }
}

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> with TickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _contactController = TextEditingController();
  final _diseaseController = TextEditingController();
  final _descriptionController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    context.read<SignupViewModel>().stream.listen((state) {
      _animationController.reset();
      _animationController.forward();
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _contactController.dispose();
    _diseaseController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocConsumer<SignupViewModel, SignupState>(
          listenWhen: (prev, current) =>
              prev.errorMessage != current.errorMessage ||
              prev.isSuccess != current.isSuccess ||
              prev.shouldPop != current.shouldPop ||
              prev.showDialog != current.showDialog,
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!), backgroundColor: theme.colorScheme.error),
              );
            }
            if (state.isSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sign up successful! Please log in.'), backgroundColor: Colors.green),
              );
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const Login()),
                (route) => false,
              );
            }
            if (state.shouldPop) {
              Navigator.of(context).pop();
            }
            if (state.showDialog) {
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: Text(state.dialogType == 'terms' ? 'Terms of Use' : 'Privacy Policy'),
                  content: Text('Your ${state.dialogType} content goes here.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 64,
                        height: 64,
                      ),
                    ),
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () => context.read<SignupViewModel>().add(SignupPreviousStepTapped()),
                                  child: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text('Join Jeevan Daan', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text('Start your journey of making a difference', style: theme.textTheme.bodyMedium),
                            const SizedBox(height: 30),
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: _buildCurrentField(context, state),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: state.isLoading
                                    ? null
                                    : () {
                                        context.read<SignupViewModel>().add(
                                              SignupNextStepTapped(
                                                name: _nameController.text,
                                                email: _emailController.text,
                                                password: _passwordController.text,
                                                contact: _contactController.text,
                                                disease: _diseaseController.text,
                                                description: _descriptionController.text,
                                              ),
                                            );
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                child: state.isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                                      )
                                    : Text(state.currentStep < 6 ? 'Continue' : 'Create Account'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCurrentField(BuildContext context, SignupState state) {
    switch (state.currentStep) {
      case 0:
        return _buildTextField(controller: _nameController, label: 'Name', icon: Icons.person, hint: 'Enter your name');
      case 1:
        return _buildTextField(controller: _emailController, label: 'Email Address', icon: Icons.email, hint: 'Enter your email address', keyboardType: TextInputType.emailAddress);
      case 2:
        return _buildTextField(controller: _passwordController, label: 'Password', icon: Icons.lock, hint: 'Create a secure password', obscureText: true);
      case 3:
        return _buildTextField(controller: _contactController, label: 'Contact Number', icon: Icons.phone, hint: 'Enter your contact number', keyboardType: TextInputType.phone);
      case 4:
        return _buildTextField(controller: _diseaseController, label: 'Disease', icon: Icons.medical_services, hint: 'Enter your disease');
      case 5:
        return _buildTextField(controller: _descriptionController, label: 'Description', icon: Icons.description, hint: 'Enter a description', maxLines: 3);
      case 6:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: state.agreeToTerms,
              activeColor: Colors.green,
              onChanged: (value) => context.read<SignupViewModel>().add(SignupTermsToggled(hasAgreed: value ?? false)),
            ),
            Expanded(
              child: Wrap(
                alignment: WrapAlignment.start,
                children: [
                  const Text('By creating an account, you agree to the '),
                  InkWell(
                    onTap: () => context.read<SignupViewModel>().add(SignupShowTermsTapped(type: 'terms')),
                    child: const Text('Terms of Use', style: TextStyle(color: Colors.green, decoration: TextDecoration.underline)),
                  ),
                  const Text(' and '),
                  InkWell(
                    onTap: () => context.read<SignupViewModel>().add(SignupShowTermsTapped(type: 'privacy')),
                    child: const Text('Privacy Policy', style: TextStyle(color: Colors.green, decoration: TextDecoration.underline)),
                  ),
                ],
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType? keyboardType,
    bool obscureText = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey, size: 20),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.green, width: 2)),
          ),
        ),
      ],
    );
  }
}