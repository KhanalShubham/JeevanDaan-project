class ApiEndpoints {
  ApiEndpoints._();

  //timeouts
  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  // --- FIX 1: CHANGE THE HOSTNAME ---
  // This is for your Android emulator
  static const String serverAddress = "http://10.0.2.2:5050"; 
  // For physical device, use your PC's IP: static const String serverAddress = "http://192.168.1.10:5050";

  // Base URL is correct
  static const String baseUrl = "$serverAddress/api/";

  // --- FIX 2: REMOVE LEADING SLASHES ---
  // authentication part
  static const String login = "auth/login";       // Removed leading slash
  static const String register = "auth/register";   // Removed leading slash
  
  // NOTE: You defined getAllUser as "/approved" but your userRoute.js has it at the same level as register/login.
  // It should probably also be "auth/approved". I will assume this for the fix.
  // If your approved route is truly at the root, you need a different setup.
  // Based on your backend code, this should be the correct path.
  static const String getAllUser = "auth/approved";
}