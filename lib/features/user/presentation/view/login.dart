// lib/features/user/presentation/view/login.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get_it/get_it.dart';
import 'package:jeevandaan/features/dashboard/presentation/view/mainnavigation.dart';
import 'package:jeevandaan/features/user/presentation/view/signup.dart';
import 'package:jeevandaan/features/user/presentation/view_model/login_view_model/login_view_model.dart';

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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        // BlocListener handles "side effects" like navigation and showing SnackBars.
        // It does not rebuild the UI.
        child: BlocListener<LoginViewModel, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              // On success, navigate to the main screen and remove all previous routes.
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const MainNavigationView()),
                (route) => false,
              );
            } else if (state is LoginFailure) {
              // On failure, show an error message.
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
            }
          },
          // BlocBuilder rebuilds the UI in response to state changes.
          child: BlocBuilder<LoginViewModel, LoginState>(
            builder: (context, state) {
              bool isLoading = state is LoginLoading;
              bool obscureText = state is LoginInitial ? state.obscureText : true;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 20),
                        // Back button (optional, if this screen can be pushed)
                        if (Navigator.canPop(context))
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                        const SizedBox(height: 30),
                        const Text('Sign in', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 40),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(hintText: "Email", prefixIcon: Icon(Icons.email_outlined)),
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
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => context.read<LoginViewModel>().add(TogglePasswordVisibility()),
                            ),
                          ),
                          validator: MinLengthValidator(6, errorText: "Password must be at least 6 characters"),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE53935), // Primary Red
                              foregroundColor: Colors.white,
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
                                : const Text("Sign In", style: TextStyle(fontSize: 18)),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account? "),
                            GestureDetector(
                              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Signup())),
                              child: const Text("Sign Up", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE53935))),
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