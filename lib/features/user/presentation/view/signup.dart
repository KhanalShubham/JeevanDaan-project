import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/features/user/presentation/view/login.dart';
import 'package:jeevandaan/features/user/presentation/view_model/register_view_model/signup_event.dart';
import 'package:jeevandaan/features/user/presentation/view_model/register_view_model/signup_state.dart';
import 'package:jeevandaan/features/user/presentation/view_model/register_view_model/signup_view_model.dart';
 // Make sure you import your service locator

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Get the fully prepared ViewModel from the service locator
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
  // The View only holds controllers and animation logic.
  // All state (_currentStep, etc.) is now in the BLoC.
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
    // Add a listener to reset the animation when the step changes
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
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<SignupViewModel, SignupState>(
          listener: (context, state) {
            // Show error snackbar if an error message exists
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.red,
                ),
              );
            }
            // On success, show a success message and navigate to the Login screen
            if (state.isSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Sign up successful! Please log in.'),
                    backgroundColor: Colors.green),
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const Login()),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => context.read<SignupViewModel>().add(
                              SignupPreviousStepTapped(context: context),
                            ),
                        child: const Icon(Icons.arrow_back, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // App Icon
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.green, Colors.teal],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.favorite, color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Join Hope Care',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Start your journey of making a difference',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),

                  // The current form field, animated
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildCurrentField(context, state),
                  ),

                  // Navigation Button
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
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: state.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              state.currentStep < 6 ? 'Continue' : 'Create Account',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),

                  // Link to Login Screen
                  if (state.currentStep == 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Login()),
                          );
                        },
                        child: const Text(
                          'Already have an account? Sign in here',
                          style: TextStyle(color: Colors.green, fontSize: 14),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Builds the form field widget based on the current step from the BLoC state.
  Widget _buildCurrentField(BuildContext context, SignupState state) {
    switch (state.currentStep) {
      case 0:
        return _buildTextField(
          controller: _nameController,
          label: 'Name',
          icon: Icons.person,
          hint: 'Enter your name',
        );
      case 1:
        return _buildTextField(
          controller: _emailController,
          label: 'Email Address',
          icon: Icons.email,
          hint: 'Enter your email address',
          keyboardType: TextInputType.emailAddress,
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              controller: _passwordController,
              label: 'Password',
              icon: Icons.lock,
              hint: 'Create a secure password',
              obscureText: true,
            ),
            if (_passwordController.text.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildPasswordStrengthIndicator(),
            ],
          ],
        );
      case 3:
        return _buildTextField(
          controller: _contactController,
          label: 'Contact Number',
          icon: Icons.phone,
          hint: 'Enter your contact number',
          keyboardType: TextInputType.phone,
        );
      case 4:
        return _buildTextField(
          controller: _diseaseController,
          label: 'Disease',
          icon: Icons.medical_services,
          hint: 'Enter your disease',
        );
      case 5:
        return _buildTextField(
          controller: _descriptionController,
          label: 'Description',
          icon: Icons.description,
          hint: 'Enter a description',
          maxLines: 3,
        );
      case 6:
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: state.agreeToTerms, // Use state to control the checkbox
                  activeColor: Colors.green,
                  onChanged: (value) {
                    context.read<SignupViewModel>().add(
                          SignupTermsToggled(hasAgreed: value ?? false),
                        );
                  },
                  shape: const CircleBorder(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      const Text('By creating an account, you agree to the '),
                      InkWell(
                        onTap: () {
                          context.read<SignupViewModel>().add(
                                SignupShowTermsTapped(context: context, type: 'terms'),
                              );
                        },
                        child: const Text(
                          'Terms of Use',
                          style: TextStyle(color: Colors.green, decoration: TextDecoration.underline),
                        ),
                      ),
                      const Text(' and '),
                      InkWell(
                        onTap: () {
                          context.read<SignupViewModel>().add(
                                SignupShowTermsTapped(context: context, type: 'privacy'),
                              );
                        },
                        child: const Text(
                          'Privacy Policy',
                          style: TextStyle(color: Colors.green, decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  /// A reusable helper widget for creating styled text fields.
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
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.5),
          ),
          // We call setState to rebuild the password strength indicator live
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  /// A UI helper to show the password strength visually.
  Widget _buildPasswordStrengthIndicator() {
    int getPasswordStrength(String password) {
      int strength = 0;
      if (password.length >= 8) strength++;
      if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
      if (RegExp(r'[a-z]').hasMatch(password)) strength++;
      if (RegExp(r'[0-9]').hasMatch(password)) strength++;
      if (RegExp(r'[!@#$%^&*()_+\-=[\]{};:"\\|,.<>/?]').hasMatch(password)) strength++;
      return strength;
    }

    final strength = getPasswordStrength(_passwordController.text);
    Color strengthColor = Colors.grey[200]!;
    String strengthText = "Weak";

    if (strength > 0) {
      if (strength <= 2) {
        strengthColor = Colors.red;
        strengthText = "Weak";
      } else if (strength <= 4) {
        strengthColor = Colors.orange;
        strengthText = "Medium";
      } else {
        strengthColor = Colors.green;
        strengthText = "Strong";
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(5, (index) {
            return Expanded(
              child: Container(
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: index < strength ? strengthColor : Colors.grey[200],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          'Password strength: $strengthText',
          style: TextStyle(fontSize: 12, color: strengthColor),
        ),
      ],
    );
  }
}