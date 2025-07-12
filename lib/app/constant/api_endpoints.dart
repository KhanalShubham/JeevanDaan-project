class ApiEndpoints {
  ApiEndpoints._();

  //timeouts
  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);
  
  static const String serverAddress = "http://10.0.2.2:5050"; 
  // For physical device, use your PC's IP: static const String serverAddress = "http://192.168.1.10:5050";

  // Base URL is correct
  static const String baseUrl = "$serverAddress/api/";

  static const String login = "auth/login";       
  static const String register = "auth/register";   
  
  static const String getAllUser = "auth/approved";

  // Base path for requests
  static const String request = "request/";

  // POST: Add a new request (router.route('/').post)
  static const String addRequest = "${request}"; // It's the base 'request/' endpoint for POST

  // GET: Get all requests made by the logged-in user (router.route('/my-requests').get)
  static const String getMyRequests = "${request}my-requests";

  // DELETE: Delete a specific request by ID (router.route('/:id').delete)
  // This endpoint requires the request ID to be appended to the path.
  // Example usage in Flutter: '${ApiEndpoints.deleteRequest}/$requestId'
  static const String deleteRequest = "${request}"; // Base for deleting by ID

  static const String getMe = "auth/me";
   static const String getDashboardRequests = "request/my-requests"; // Reusing for clarity

  // --- Chat Endpoints ---
  static const String chat = "chat/";
  
  // POST: Upload a file for a chat message
  // The full path would be /api/chat/upload
  static const String uploadChatFile = "${chat}upload";

  // GET: Fetch message history between the current user and another user
  // This requires the other user's ID to be appended.
  // Example: '${ApiEndpoints.getChatHistory}/$otherUserId'
  static const String getChatHistory = "${chat}history";

  // GET: For an admin to get a list of all their conversations
  static const String getConversations = "${chat}conversations";

}