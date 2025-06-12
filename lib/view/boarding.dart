import 'package:flutter/material.dart';
import 'package:jeevandaan/view/login.dart';
import 'package:jeevandaan/view/signup.dart';
//this is boardingscreen 
//let's do code

class BoardingScreen extends StatefulWidget {
  const BoardingScreen({Key? key}) : super(key: key);

  @override
  _BoardingState createState() => _BoardingState();
}

class _BoardingState extends State<BoardingScreen> {
  bool isLoginHovered = false;
  bool isCreateAccountHovered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Welcome Text
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              // Donate something text
              const Text(
                'Donate something and save',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const Text(
                'someone\'s life',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40),
              // Child Image
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Image.asset(
                  'assets/images/child.png', // Make sure to add this image to your assets
                  fit: BoxFit.contain,
                ),
              ),
              const Spacer(),
              // Create Account Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: MouseRegion(
                  onEnter: (_) => setState(() => isCreateAccountHovered = true),
                  onExit: (_) => setState(() => isCreateAccountHovered = false),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Signup()),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 56,
                      decoration: BoxDecoration(
                        color: isCreateAccountHovered ? Colors.purple[700] : Colors.purple,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.purple, width: 1),
                        boxShadow: isCreateAccountHovered
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
                            fontWeight: isCreateAccountHovered ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Login Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: MouseRegion(
                  onEnter: (_) => setState(() => isLoginHovered = true),
                  onExit: (_) => setState(() => isLoginHovered = false),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isLoginHovered ? Colors.purple : Colors.grey.shade300,
                          width: 1,
                        ),
                        boxShadow: isLoginHovered
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
                            color: isLoginHovered ? Colors.purple : Colors.black87,
                            fontSize: 16,
                            fontWeight: isLoginHovered ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}