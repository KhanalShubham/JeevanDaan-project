import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/features/user/presentation/view_model/register_view_model/signup_event.dart';
import 'package:jeevandaan/features/user/presentation/view_model/register_view_model/signup_state.dart';
import 'package:jeevandaan/features/user/presentation/view_model/register_view_model/signup_view_model.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupViewModel(),
      child: const SignupView(),
    );
  }
}

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Add listeners to track input changes for form validation
    _nameController.addListener(_checkFormValidity);
    _emailController.addListener(_checkFormValidity);
    _phoneController.addListener(_checkFormValidity);
    _passwordController.addListener(_checkFormValidity); // Fixed: Added missing semicolon and method name
  }

  @override
  void dispose() {
    _nameController.removeListener(_checkFormValidity);
    _emailController.removeListener(_checkFormValidity);
    _phoneController.removeListener(_checkFormValidity);
    _passwordController.removeListener(_checkFormValidity); // Fixed: Added missing listener removal
    
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose(); // Fixed: Added missing dispose
    super.dispose();
  }

  void _checkFormValidity() {
    // Trigger form validation in the bloc
    context.read<SignupViewModel>().add(ValidateFormEvent());
  }

  bool _isCurrentFormValid() {
    return (_formKey.currentState?.validate() ?? false);
  }

  void _submitForm() {
    final viewModel = context.read<SignupViewModel>();
    final currentState = viewModel.state;
    
    if (_formKey.currentState!.validate() && 
        currentState.agreeToTerms && 
        currentState.selectedGender != null) {
      
      viewModel.add(
        SignupWithCredentialsEvent(
          context: context,
          name: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          password:  _passwordController.text, // Fixed: Added password parameter
          gender: currentState.selectedGender!,
        ),
      );
    } else if (!currentState.agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the terms and conditions')),
      );
    } else if (currentState.selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a gender')),
      );
    }
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
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Form(
                key: _formKey,
                onChanged: _checkFormValidity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          child: const Icon(Icons.arrow_back),
                          onTap: () => context.read<SignupViewModel>().add(
                                NavigateBackEvent(context: context),
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Sign up with your email or\nphone number',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 30),

                    // Name field with icon
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration('Name', Icons.person),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email field with icon
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration('Email', Icons.email),
                      validator: (value) {
                        final viewModel = context.read<SignupViewModel>();
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!viewModel.isValidEmail(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password field - Fixed: Now using correct controller and validation
                    TextFormField(
                      controller: _passwordController, // Fixed: Changed from _emailController
                      obscureText: true, // Fixed: Added password obscuring
                      decoration: _inputDecoration('Password', Icons.lock), // Fixed: Changed icon from Icons.password
                      validator: (value) {
                        final viewModel = context.read<SignupViewModel>();
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (!viewModel.isValidPasswordRegEx(value)) { // Fixed: Changed from isValidEmail to isValidPassword
                          return 'Please enter a valid password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Phone number field
                    Row(
                      children: [
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 40,
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: _inputDecoration('Phone Number', Icons.phone),
                            validator: (value) {
                              final viewModel = context.read<SignupViewModel>();
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              } else if (!viewModel.isValidPhone(value)) {
                                return 'Please enter a valid phone number';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Gender dropdown with dynamic icon
                    DropdownButtonFormField<String>(
                      value: state.selectedGender,
                      decoration: _inputDecoration('Gender', state.getGenderIcon()),
                      items: state.genderOptions.map((gender) {
                        IconData genderIcon;
                        switch (gender) {
                          case 'Male':
                            genderIcon = Icons.man;
                            break;
                          case 'Female':
                            genderIcon = Icons.woman;
                            break;
                          case 'Others':
                            genderIcon = Icons.transgender;
                            break;
                          default:
                            genderIcon = Icons.people;
                        }
                        
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Row(
                            children: [
                              Icon(genderIcon, size: 18, color: Colors.grey[700]),
                              const SizedBox(width: 10),
                              Text(gender),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        context.read<SignupViewModel>().add(
                              UpdateGenderEvent(gender: value),
                            );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a gender';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Terms and conditions checkbox
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
                              const Text('By signing up, you agree to the '),
                              InkWell(
                                onTap: () {
                                  context.read<SignupViewModel>().add(
                                        ShowTermsEvent(
                                          context: context,
                                          type: 'terms',
                                        ),
                                      );
                                },
                                child: const Text(
                                  'Terms of service',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                              const Text(' and '),
                              InkWell(
                                onTap: () {
                                  context.read<SignupViewModel>().add(
                                        ShowTermsEvent(
                                          context: context,
                                          type: 'privacy',
                                        ),
                                      );
                                },
                                child: const Text(
                                  'Privacy policy',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Sign Up button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: state.isLoading ? null : () {
                          final isFormValid = _isCurrentFormValid();
                          final canSubmit = isFormValid && 
                                          state.agreeToTerms && 
                                          state.selectedGender != null;
                          
                          if (canSubmit) {
                            _submitForm();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
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
                            : const Text(
                                'Sign Up',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),

                    // Or separator
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text('or', style: TextStyle(color: Colors.grey)),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                    ),

                    // Social icons row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            context.read<SignupViewModel>().add(
                                  SocialSignupEvent(
                                    context: context,
                                    provider: 'google',
                                  ),
                                );
                          },
                          icon: const Icon(
                            Icons.mail_outline,
                            size: 28,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 24),
                        IconButton(
                          onPressed: () {
                            context.read<SignupViewModel>().add(
                                  SocialSignupEvent(
                                    context: context,
                                    provider: 'facebook',
                                  ),
                                );
                          },
                          icon: const Icon(
                            Icons.facebook,
                            color: Colors.blue,
                            size: 32,
                          ),
                        ),
                      ],
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

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.grey[100],
    );
  }
}