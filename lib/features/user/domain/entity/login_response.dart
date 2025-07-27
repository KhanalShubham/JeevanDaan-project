class LoginResponse {
  final String token;
  final String role;
  final Map<String, dynamic>? user; // For admin response structure
  final String? name; // For user response structure
  final String? email; // For user response structure
  
  LoginResponse({
    required this.token, 
    required this.role,
    this.user,
    this.name,
    this.email,
  });
} 