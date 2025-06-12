import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? _selectedGender;
  bool _agreeToTerms = false;

  final List<String> _genderOptions = ['Male', 'Female', 'Others'];

  // Track form validity
  bool _isFormValid = false;

  // Method to check if the form is currently valid
  void _checkFormValidity() {
    bool isValid = _formKey.currentState?.validate() ?? false;
    isValid = isValid && _agreeToTerms && _selectedGender != null;
    
    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    // Phone validation depends on country, but generally allowing digits and optional plus sign
    return RegExp(r'^[0-9]{6,15}$').hasMatch(phone);
  }

  @override
  void initState() {
    super.initState();
    // Add listeners to track input changes
    _nameController.addListener(_checkFormValidity);
    _emailController.addListener(_checkFormValidity);
    _phoneController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    _nameController.removeListener(_checkFormValidity);
    _emailController.removeListener(_checkFormValidity);
    _phoneController.removeListener(_checkFormValidity);
    
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _agreeToTerms) {
      // Successful signup
      _showSnackbar('Sign up successful!');
      Navigator.pop(context);
    } else if (!_agreeToTerms) {
      _showSnackbar('Please agree to the terms and conditions');
    }
  }

  // Get appropriate icon based on selected gender
  IconData _getGenderIcon() {
    switch (_selectedGender) {
      case 'Male':
        return Icons.man;
      case 'Female':
        return Icons.woman;
      case 'Others':
        return Icons.transgender;
      default:
        return Icons.people;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                      onTap: () => Navigator.pop(context),
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
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!_isValidEmail(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone number field with country code picker
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
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          } else if (!_isValidPhone(value)) {
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
                  value: _selectedGender,
                  decoration: _inputDecoration('Gender', _getGenderIcon()),
                  items: _genderOptions.map((gender) {
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
                    setState(() {
                      _selectedGender = value;
                      _checkFormValidity();
                    });
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
                      value: _agreeToTerms,
                      activeColor: Colors.green,
                      onChanged: (value) {
                        setState(() {
                          _agreeToTerms = value ?? false;
                          _checkFormValidity();
                        });
                      },
                      shape: const CircleBorder(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Wrap(
                        children: [
                          const Text('By signing up, you agree to the '),
                          InkWell(
                            onTap: () {},
                            child: const Text(
                              'Terms of service',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                          const Text(' and '),
                          InkWell(
                            onTap: () {},
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

                // Sign Up button (disabled when form is invalid)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isFormValid ? _submitForm : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
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

                // Social icons only row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        _showSnackbar('Google sign up tapped');
                      },
                      icon: Image.asset(
                        'assets/lottie/images/google.png',
                        width: 28,
                        height: 28,
                      ),
                    ),
                    const SizedBox(width: 24),
                    IconButton(
                      onPressed: () {
                        _showSnackbar('Facebook sign up tapped');
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