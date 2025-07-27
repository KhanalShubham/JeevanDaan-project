// lib/features/user/presentation/view/login.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get_it/get_it.dart';
import 'package:jeevandaan/features/dashboard/presentation/view/mainnavigation.dart';
import 'package:jeevandaan/features/user/presentation/view/signup.dart';
import 'package:jeevandaan/features/user/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jeevandaan/core/network/api_service.dart';
import 'package:jeevandaan/features/user/data/repository/local_repository/user_local_repository_impl.dart';
import 'package:jeevandaan/features/request/presentation/view/admin_request_view.dart';
import 'package:jeevandaan/features/request/presentation/view_model/admin_request_view_model.dart';
import 'package:jeevandaan/features/request/data/repository/request_repository_impl.dart';
import 'package:jeevandaan/features/request/domain/repository/request_repository.dart';

final serviceLocator = GetIt.instance;

// This wrapper provides the ViewModel to the view.
class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<LoginViewModel>(),
      child: const LoginView(),
    );
  }
}

// This is the actual UI widget.
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSocialLoading = false;

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    final userRole = prefs.getString('user_role'); // Check stored role
    
    // Only auto-login for regular users, not admins
    if (token != null && token.isNotEmpty && userRole != 'admin') {
      // TODO: Optionally validate token with backend
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainNavigationView()),
      );
    }
  }

  Future<void> _handleSocialLogin({required String provider, required String token}) async {
    setState(() => _isSocialLoading = true);
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/api/user/social-login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'provider': provider,
          'token': token,
        }),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', data['token']);
        await prefs.setString('user_name', data['user']['name'] ?? '');
        await prefs.setString('user_email', data['user']['email'] ?? '');
        await prefs.setString('user_role', data['user']['role'] ?? 'user');
        
        // Navigate based on role
        if (mounted) {
          if (data['user']['role'] == 'admin') {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => AdminRequestView(
                  token: data['token'],
                  viewModel: AdminRequestViewModel(
                    requestRepository: serviceLocator<IRequestRepository>(),
                  ),
                ),
              ),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MainNavigationView()),
            );
          }
        }
      } else {
        throw Exception(data['error'] ?? 'Social login failed');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Social login error: $e')));
    } finally {
      setState(() => _isSocialLoading = false);
    }
  }

  Future<void> _handleLoginOfflineBanner(BuildContext context, bool isOffline, bool localAvailable) async {
    if (isOffline && localAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You are offline. Logging in with local data.'), backgroundColor: Colors.orange),
      );
    } else if (isOffline && !localAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You are offline and no local data is available.'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _storeLoginTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_login_timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  Future<bool> _isLoginValid() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt('last_login_timestamp');
    if (timestamp == null) return false;
    final lastLogin = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateTime.now().difference(lastLogin) < Duration(days: 1);
  }

  Future<void> _clearLoginTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('last_login_timestamp');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocListener<LoginViewModel, LoginState>(
          listener: (context, state) async {
            final isOffline = !(await ConnectivityService().isOnline);
            // Assume local data is available if UserLocalRepositoryImpl is registered in service locator
            final localAvailable = true; // Set to true if you always have local repo, or check via service locator
            if (state is LoginSuccess || state is LoginFailure) {
              await _handleLoginOfflineBanner(context, isOffline, localAvailable);
            }
            if (state is LoginSuccess) {
              await _storeLoginTimestamp();
              
              // Store user role for future reference
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('user_role', state.role);
              
              if (state.role == 'admin') {
                // Admin: Navigate to admin view (no bottom navigation)
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => AdminRequestView(
                      token: state.token,
                      viewModel: AdminRequestViewModel(
                        requestRepository: serviceLocator<IRequestRepository>(),
                      ),
                    ),
                  ),
                  (route) => false,
                );
              } else {
                // User: Navigate to normal dashboard
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const MainNavigationView()),
                  (route) => false,
                );
              }
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: theme.colorScheme.error,
                  ),
                );
            }
          },
          child: BlocBuilder<LoginViewModel, LoginState>(
            builder: (context, state) {
              bool isLoading = state is LoginLoading;
              bool obscureText = state is LoginInitial ? state.obscureText : true;

              return Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo at the top
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 72,
                            height: 72,
                          ),
                        ),
                        Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Sign in', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 32),
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      hintText: "Email",
                                      prefixIcon: Icon(Icons.email_outlined, color: theme.colorScheme.primary),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: MultiValidator([
                                      RequiredValidator(errorText: "Please enter your email"),
                                      EmailValidator(errorText: "Please enter a valid email"),
                                    ]),
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: obscureText,
                                    decoration: InputDecoration(
                                      hintText: "Password",
                                      prefixIcon: Icon(Icons.lock_outline, color: theme.colorScheme.primary),
                                      suffixIcon: IconButton(
                                        icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: theme.colorScheme.primary),
                                        onPressed: () => context.read<LoginViewModel>().add(TogglePasswordVisibility()),
                                      ),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    validator: MinLengthValidator(6, errorText: "Password must be at least 6 characters"),
                                  ),
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: theme.colorScheme.primary,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: isLoading
                                          ? null
                                          : () {
                                              if (_formKey.currentState!.validate()) {
                                                context.read<LoginViewModel>().add(
                                                      LoginSubmitted(
                                                        email: _emailController.text.trim(),
                                                        password: _passwordController.text.trim(),
                                                      ),
                                                    );
                                              }
                                            },
                                      child: isLoading
                                          ? const CircularProgressIndicator(color: Colors.white)
                                          : const Text("Sign In"),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // --- Social Login Buttons ---
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          icon: Image.asset('assets/images/google.png', width: 24, height: 24),
                                          label: const Text('Google'),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.black87,
                                            side: const BorderSide(color: Color(0xFF4285F4)),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                          ),
                                          onPressed: _isSocialLoading ? null : () async {
                                            try {
                                              final googleUser = await GoogleSignIn().signIn();
                                              if (googleUser == null) return; // User cancelled
                                              final googleAuth = await googleUser.authentication;
                                              final idToken = googleAuth.idToken;
                                              if (idToken == null) throw Exception('No Google ID token');
                                              await _handleSocialLogin(provider: 'google', token: idToken);
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google login error: $e')));
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          icon: Image.asset('assets/images/facebook.png', width: 24, height: 24),
                                          label: const Text('Facebook'),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.black87,
                                            side: const BorderSide(color: Color(0xFF1877F3)),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                          ),
                                          onPressed: _isSocialLoading ? null : () async {
                                            try {
                                              final result = await FacebookAuth.instance.login();
                                              if (result.status != LoginStatus.success) return;
                                              final accessToken = result.accessToken?.token;
                                              if (accessToken == null) throw Exception('No Facebook access token');
                                              await _handleSocialLogin(provider: 'facebook', token: accessToken);
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Facebook login error: $e')));
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account? ", style: theme.textTheme.bodyMedium),
                            GestureDetector(
                              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Signup())),
                              child: Text(
                                "Sign Up",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}