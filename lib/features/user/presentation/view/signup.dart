import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:jeevandaan/features/user/domain/repository/user_repository.dart';
import 'package:jeevandaan/features/user/presentation/view/login.dart';
import 'package:jeevandaan/features/user/presentation/view_model/register_view_model/signup_event.dart';
import 'package:jeevandaan/features/user/presentation/view_model/register_view_model/signup_state.dart';
import 'package:jeevandaan/features/user/presentation/view_model/register_view_model/signup_view_model.dart';

final serviceLocator = GetIt.instance;

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupViewModel(userRepository: serviceLocator<IUserRepository>()),
      child: const SignupView(),
    );
  }
}

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _contactController = TextEditingController();
  final _diseaseController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _currentStep = 0;
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
    _animationController.forward();

    // Add listeners for form validation
    _nameController.addListener(_checkFormValidity);
    _emailController.addListener(_checkFormValidity);
    _passwordController.addListener(_checkFormValidity);
    _contactController.addListener(_checkFormValidity);
    _diseaseController.addListener(_checkFormValidity);
    _descriptionController.addListener(_checkFormValidity);
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

  void _checkFormValidity() {
    context.read<SignupViewModel>().add(ValidateFormEvent());
  }

  bool _isCurrentFieldValid() {
    switch (_currentStep) {
      case 0:
        return _nameController.text.isNotEmpty;
      case 1:
        return context.read<SignupViewModel>().isValidEmail(_emailController.text);
      case 2:
        return context.read<SignupViewModel>().isValidPasswordRegEx(_passwordController.text);
      case 3:
        return context.read<SignupViewModel>().isValidContact(_contactController.text);
      case 4:
        return _diseaseController.text.isNotEmpty;
      case 5:
        return _descriptionController.text.isNotEmpty;
      default:
        return false;
    }
  }

  void _submitForm() {
    final viewModel = context.read<SignupViewModel>();
    final currentState = viewModel.state;

    if (currentState.agreeToTerms) {
      viewModel.add(
        SignupWithCredentialsEvent(
          context: context,
          name: _nameController.text,
          email: _emailController.text,
          contact: _contactController.text,
          password: _passwordController.text,
          disease: _diseaseController.text,
          description: _descriptionController.text,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the terms and conditions')),
      );
    }
  }

  void _nextStep() {
    if (_isCurrentFieldValid()) {
      setState(() {
        _animationController.reset();
        _currentStep++;
        _animationController.forward();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_getErrorMessage()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _animationController.reset();
        _currentStep--;
        _animationController.forward();
      });
    } else {
      context.read<SignupViewModel>().add(NavigateBackEvent(context: context));
    }
  }

  String _getErrorMessage() {
    switch (_currentStep) {
      case 0:
        return 'Please enter your name';
      case 1:
        return 'Please enter a valid email';
      case 2:
        return 'Please enter a valid password';
      case 3:
        return 'Please enter a valid contact number';
      case 4:
        return 'Please enter your disease';
      case 5:
        return 'Please enter a description';
      default:
        return 'Please complete the field';
    }
  }

  int _getPasswordStrength(String password) {
    int strength = 0;
    if (password.length >= 8) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'[a-z]').hasMatch(password)) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[!@#$%^&*()_+\-=[\]{};:"\\|,.<>/?]').hasMatch(password)) strength++;
    return strength;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<SignupViewModel, SignupState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state.isSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sign up successful!')),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: _previousStep,
                          child: const Icon(Icons.arrow_back, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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

                    // Field Display (One at a time)
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildCurrentField(context, state),
                    ),

                    // Navigation Buttons
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: state.isLoading
                            ? null
                            : () {
                                if (_currentStep < 6) {
                                  _nextStep();
                                } else if (_isCurrentFieldValid() && state.agreeToTerms) {
                                  _submitForm();
                                }
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
                                _currentStep < 6 ? 'Continue' : 'Create Account',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),

                    // Login Link
                    if (_currentStep == 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Login(),
                              ),
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
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCurrentField(BuildContext context, SignupState state) {
    switch (_currentStep) {
      case 0:
        return _buildTextField(
          controller: _nameController,
          label: 'Name',
          icon: Icons.person,
          hint: 'Enter your name',
          validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
        );
      case 1:
        return _buildTextField(
          controller: _emailController,
          label: 'Email Address',
          icon: Icons.email,
          hint: 'Enter your email address',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter your email';
            if (!context.read<SignupViewModel>().isValidEmail(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
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
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter your password';
                if (!context.read<SignupViewModel>().isValidPasswordRegEx(value)) {
                  return 'Password must contain uppercase, lowercase, number, and special character';
                }
                return null;
              },
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
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter your contact number';
            if (!context.read<SignupViewModel>().isValidContact(value)) {
              return 'Please enter a valid contact number';
            }
            return null;
          },
        );
      case 4:
        return _buildTextField(
          controller: _diseaseController,
          label: 'Disease',
          icon: Icons.medical_services,
          hint: 'Enter your disease',
          validator: (value) => value == null || value.isEmpty ? 'Please enter your disease' : null,
        );
      case 5:
        return _buildTextField(
          controller: _descriptionController,
          label: 'Description',
          icon: Icons.description,
          hint: 'Enter a description',
          maxLines: 3,
          validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
        );
      case 6:
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: state.agreeToTerms,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    context.read<SignupViewModel>().add(
                          ToggleTermsAgreementEvent(agreed: value ?? false),
                        );
                  },
                  shape: const CircleBorder(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Wrap(
                    children: [
                      const Text('By creating an account, you agree to the '),
                      InkWell(
                        onTap: () {
                          context.read<SignupViewModel>().add(
                                ShowTermsEvent(context: context, type: 'terms'),
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
                                ShowTermsEvent(context: context, type: 'privacy'),
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
            if (!state.agreeToTerms)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'You must agree to the Terms of Use and Privacy Policy',
                  style: TextStyle(color: Colors.red, fontSize: 12),
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
    String? Function(String?)? validator,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
          validator: validator,
          onChanged: (value) => _checkFormValidity(),
        ),
      ],
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    final strength = _getPasswordStrength(_passwordController.text);
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
                  color: index < strength
                      ? strength <= 2
                          ? Colors.red
                          : strength <= 3
                              ? Colors.yellow
                              : Colors.green
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          'Password strength: ${strength <= 2 ? "Weak" : strength <= 3 ? "Medium" : "Strong"}',
          style: TextStyle(
            fontSize: 12,
            color: strength <= 2
                ? Colors.red
                : strength <= 3
                    ? Colors.yellow[700]
                    : Colors.green,
          ),
        ),
      ],
    );
  }
}