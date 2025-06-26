class ApiEndpoints{
  ApiEndpoints._();

  //timeouts
  static const connectionTimeout=Duration(seconds:1000);
  static const receiveTimeout=Duration(seconds:1000);

  //this is for my andriod emulator
  static const String serverAddress="http://localhost:5050";

  static const String baseUrl="$serverAddress/api/";
  

  //authentication part
  static const String login="/auth/login";
  static const String register="/auth/register";
  static const String getAllUser="/approved";
  
}