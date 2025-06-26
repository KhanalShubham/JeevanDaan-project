import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_event.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_state.dart';
import 'package:jeevandaan/features/boarding/presentation/view_model/boarding_view_model.dart';
import 'package:jeevandaan/features/user/presentation/view/login.dart';
import 'package:jeevandaan/features/user/presentation/view/signup.dart';

class BoardingView extends StatelessWidget {
  const BoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BoardingViewModel, BoardingState>(
      listener: (context, state) {
        if (state.navigateToSignup) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Signup(),
            ),
          ).then((_) {
            // --- THIS IS THE KEY CHANGE ---
            // After returning from the Signup screen, dispatch the new, clear event.
            context.read<BoardingViewModel>().add(const ResetNavigationEvent());
          });
        }
        if (state.navigateToLogin) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Login(),
            ),
          ).then((_) {
            // --- THIS IS THE KEY CHANGE ---
            // Do the same for the Login navigation flow.
            context.read<BoardingViewModel>().add(const ResetNavigationEvent());
          });
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: SafeArea(
            child: Column(
              children: [
                // Your UI code remains unchanged...
                const Spacer(flex: 2),
                const Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Manage your courses efficiently',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const Text(
                  'and stay organized',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Image.asset(
                    'assets/images/child.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: BlocBuilder<BoardingViewModel, BoardingState>(
                    builder: (context, state) {
                      return MouseRegion(
                        onEnter: (_) => context.read<BoardingViewModel>().add(const CreateAccountHoverEvent(true)),
                        onExit: (_) => context.read<BoardingViewModel>().add(const CreateAccountHoverEvent(false)),
                        child: GestureDetector(
                          onTap: () {
                            context.read<BoardingViewModel>().add(const NavigateToSignupEvent());
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 56,
                            decoration: BoxDecoration(
                              color: state.isCreateAccountHovered ? Colors.purple[700] : Colors.purple,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.purple, width: 1),
                              boxShadow: state.isCreateAccountHovered
                                  ? [
                                      BoxShadow(
                                        color: Colors.purple.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      )
                                    ]
                                  : null,
                            ),
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                'Create an account',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: state.isCreateAccountHovered ? FontWeight.bold : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: BlocBuilder<BoardingViewModel, BoardingState>(
                    builder: (context, state) {
                      return MouseRegion(
                        onEnter: (_) => context.read<BoardingViewModel>().add(const LoginHoverEvent(true)),
                        onExit: (_) => context.read<BoardingViewModel>().add(const LoginHoverEvent(false)),
                        child: GestureDetector(
                          onTap: () {
                            context.read<BoardingViewModel>().add(const NavigateToLoginEvent());
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: state.isLoginHovered ? Colors.purple : Colors.grey.shade300,
                                width: 1,
                              ),
                              boxShadow: state.isLoginHovered
                                  ? [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      )
                                    ]
                                  : null,
                            ),
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                'Log In',
                                style: TextStyle(
                                  color: state.isLoginHovered ? Colors.purple : Colors.black87,
                                  fontSize: 16,
                                  fontWeight: state.isLoginHovered ? FontWeight.bold : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}