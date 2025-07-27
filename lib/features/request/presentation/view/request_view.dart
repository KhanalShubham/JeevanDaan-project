import 'dart:io';
import 'package:file_picker/file_picker.dart'; // Ensure file_picker is imported if you use it for documents
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jeevandaan/features/request/presentation/view_model/request_event.dart';
import 'package:jeevandaan/features/request/presentation/view_model/request_state.dart';
import 'package:jeevandaan/features/request/presentation/view_model/request_view_model.dart';
import 'package:intl/intl.dart';
import 'package:jeevandaan/core/network/api_service.dart';
import 'package:provider/provider.dart';
import 'package:jeevandaan/app/user_notifier.dart';
import 'package:jeevandaan/app/shared_pref/token_shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

class AppColors {
  static const Color primaryRed = Color(0xFFE53935); 
  static const Color primaryRedLight = Color(0xFFFFCDD2); 
  static const Color accentBlue = Color(0xFF2196F3); 
  static const Color accentBlueLight = Color(0xFFBBDEFB); 
  static const Color darkText = Color(0xFF212121);
  static const Color greyText = Color(0xFF616161);
  static const Color lightGrey = Color(0xFFE0E0E0);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color dangerRed = Color(0xFFF44336);
  static const Color white = Colors.white;
  static const Color backgroundLight = Color(0xFFF5F5F5); 
}

class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [AppColors.primaryRed, Color(0xFFD32F2F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient accentGradient = LinearGradient(
    colors: [AppColors.accentBlue, Color(0xFF1976D2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppStyles {
  static const TextStyle heading1 = TextStyle(
      fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.darkText);
  static const TextStyle heading2 = TextStyle(
      fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.darkText);
  static const TextStyle subheading = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.greyText);
  static const TextStyle cardTitle = TextStyle(
      fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkText);
  static const TextStyle cardSubtitle =
      TextStyle(fontSize: 14, color: AppColors.greyText);
  static const TextStyle statusText =
      TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
}

class AppDecorations {
  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.15),
        spreadRadius: 2,
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static InputDecoration inputDecoration({String? labelText, Widget? prefixIcon}) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: AppColors.greyText),
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.lightGrey, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.accentBlue, width: 2),
      ),
      prefixIcon: prefixIcon,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    );
  }
}

// This is the wrapper widget that provides the ViewModel
class RequestView extends StatelessWidget {
  final bool isAddForm; // To determine if it's the add form or the list view

  const RequestView({super.key, this.isAddForm = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<RequestViewModel>(),
      child: _RequestPage(isAddForm: isAddForm), // The actual UI page
    );
  }
}

class _RequestPage extends StatefulWidget {
  final bool isAddForm;

  const _RequestPage({required this.isAddForm});

  @override
  State<_RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<_RequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _neededAmountController = TextEditingController();
  final _inDepthStoryController = TextEditingController();
  final _citizenController = TextEditingController();

  File? _supportingDocFile;
  File? _userImageFile;
  File? _citizenshipImageFile;

  String _selectedCondition = 'critical';

  final ImagePicker _picker = ImagePicker();

  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    // Fetch requests if it's the list view
    if (!widget.isAddForm) {
      Future.microtask(() async {
        final user = Provider.of<UserNotifier>(context, listen: false).user;
        if (user != null && user.role == 'admin') {
          final prefs = await SharedPreferences.getInstance();
          final tokenResult = await TokenSharedPrefs(sharedPreferences: prefs).getToken();
          String? token = tokenResult.fold((l) => null, (r) => r);
          if (token != null && token.isNotEmpty) {
            context.read<RequestViewModel>().add(GetAllRequestsForAdminEvent(token: token));
          }
        } else {
          context.read<RequestViewModel>().add(GetMyRequestsEvent());
        }
      });
    }
  }

  Future<void> _checkConnectivity() async {
    final online = await ConnectivityService().isOnline;
    setState(() {
      _isOffline = !online;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
    _neededAmountController.dispose();
    _inDepthStoryController.dispose();
    _citizenController.dispose();
  }

  // Updated _pickFile to handle both images (via ImagePicker) and documents (via FilePicker)
  Future<void> _pickFile(
      Function(File?) setFile, ImageSource source, bool isDocument) async {
    File? pickedAppFile;

    if (isDocument) {
      // Use file_picker for documents (PDFs, etc.)
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'], // Allow specific document types
      );

      if (result != null && result.files.single.path != null) {
        pickedAppFile = File(result.files.single.path!);
      }
    } else {
      // Use image_picker for images
      final XFile? pickedImage = await _picker.pickImage(source: source);
      if (pickedImage != null) {
        pickedAppFile = File(pickedImage.path);
      }
    }

    if (pickedAppFile != null) {
      // Optional: Basic file type validation before setState, similar to backend
      final String fileExtension = pickedAppFile.path.split('.').last.toLowerCase();
      final List<String> allowedExtensions = ['jpg', 'jpeg', 'png', 'pdf']; // Match backend
      if (!allowedExtensions.contains(fileExtension)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Unsupported file type: .$fileExtension. Only JPEG, JPG, PNG, and PDF files are allowed.')),
        );
        return; // Do not set the file if unsupported
      }

      setState(() {
        setFile(pickedAppFile);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File picking cancelled or no file selected.')),
      );
    }
  }

  void _submitAddRequest() {
    if (_formKey.currentState!.validate()) {
      if (_supportingDocFile == null ||
          _userImageFile == null ||
          _citizenshipImageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select all required files.')),
        );
        return;
      }

      context.read<RequestViewModel>().add(
            AddRequestEvent(
              description: _descriptionController.text,
              neededAmount: num.parse(_neededAmountController.text),
              condition: _selectedCondition,
              inDepthStory: _inDepthStoryController.text,
              citizen: _citizenController.text,
              supportingDoc: _supportingDocFile!,
              userImage: _userImageFile!,
              citizenshipImage: _citizenshipImageFile!,
              context: context,
            ),
          );
    }
  }

  // Function to confirm deletion
  Future<void> _confirmDelete(String requestId) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text(
              'Are you sure you want to delete this request? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      context
          .read<RequestViewModel>()
          .add(DeleteRequestEvent(requestId: requestId, context: context));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isOffline) {
      return Scaffold(
        appBar: AppBar(title: const Text('Requests')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.wifi_off, size: 64, color: Colors.orange),
              SizedBox(height: 24),
              Text('Connect to the internet and try again.', style: TextStyle(fontSize: 18, color: Colors.grey)),
            ],
          ),
        ),
      );
    }
    return BlocBuilder<RequestViewModel, RequestState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.isAddForm ? 'Add Request' : 'Requests'),
            actions: [
              if (!widget.isAddForm)
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Add Request',
                  onPressed: () {
                    context.read<RequestViewModel>().add(NavigateToAddRequestEvent(context: context));
                  },
                ),
            ],
          ),
          body: widget.isAddForm
              ? _buildAddRequestForm(context, state)
              : _buildMyRequestsList(context, state),
        );
      },
    );
  }

  // --- Widget Builders for better separation ---

  Widget _buildAddRequestForm(BuildContext context, RequestState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Details about the request', style: AppStyles.heading2),
            const SizedBox(height: 15),
            TextFormField(
              controller: _descriptionController,
              decoration: AppDecorations.inputDecoration(
                labelText: 'Short Description',
                prefixIcon: const Icon(Icons.short_text, color: AppColors.greyText),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _neededAmountController,
              decoration: AppDecorations.inputDecoration(
                labelText: 'Needed Amount (e.g., 5000)',
                prefixIcon: const Icon(Icons.attach_money, color: AppColors.greyText),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the needed amount';
                }
                if (num.tryParse(value) == null || num.parse(value) <= 0) {
                  return 'Please enter a valid positive amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: _selectedCondition,
              decoration: AppDecorations.inputDecoration(
                labelText: 'Condition',
                prefixIcon: const Icon(Icons.medical_services, color: AppColors.greyText),
              ),
              items: const [
                DropdownMenuItem(value: 'critical', child: Text('Critical')),
                DropdownMenuItem(value: 'moderate', child: Text('Moderate')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCondition = value!;
                });
              },
              dropdownColor: AppColors.white,
              style: AppStyles.cardSubtitle.copyWith(color: AppColors.darkText),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _inDepthStoryController,
              decoration: AppDecorations.inputDecoration(
                labelText: 'In-depth Story',
                prefixIcon: const Icon(Icons.article, color: AppColors.greyText),
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please tell the in-depth story';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _citizenController,
              decoration: AppDecorations.inputDecoration(
                labelText: 'Citizen Name/ID',
                prefixIcon: const Icon(Icons.person, color: AppColors.greyText),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter citizen information';
                }
                return null;
              },
            ),
            const SizedBox(height: 25),
            _buildFilePicker('Supporting Document (PDF/Image)', _supportingDocFile,
                (file) => _supportingDocFile = file, true),
            _buildFilePicker('Your Image', _userImageFile,
                (file) => _userImageFile = file, false),
            _buildFilePicker('Citizenship Image', _citizenshipImageFile,
                (file) => _citizenshipImageFile = file, false),
            const SizedBox(height: 30),
            Center(
              child: Container(
                width: double.infinity, // Make button full width
                height: 55, // Fixed height for button
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: AppGradients.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryRed.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: state.isLoading ? null : _submitAddRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // Make button transparent
                    shadowColor: Colors.transparent, // No shadow from ElevatedButton
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.zero, // Remove default padding
                  ),
                  child: state.isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text('Submit Request',
                          style: AppStyles.heading2
                              .copyWith(color: AppColors.white, fontSize: 18)),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePicker(
      String title, File? file, Function(File?) setFile, bool isDocument) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppStyles.subheading.copyWith(color: AppColors.darkText)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.lightGrey),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    file != null ? file.path.split('/').last : 'No file selected',
                    style: AppStyles.cardSubtitle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.photo_library, color: AppColors.accentBlue),
                  onPressed: () => _pickFile(setFile, ImageSource.gallery, isDocument),
                  tooltip: 'Pick from Gallery',
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt, color: AppColors.accentBlue),
                  onPressed: () => _pickFile(setFile, ImageSource.camera, isDocument),
                  tooltip: 'Take Photo',
                ),
                if (file != null)
                  IconButton(
                    icon: const Icon(Icons.clear, color: AppColors.dangerRed),
                    onPressed: () {
                      setState(() {
                        setFile(null);
                      });
                    },
                    tooltip: 'Clear Selection',
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyRequestsList(BuildContext context, RequestState state) {
    if (state.isLoading && state.requests.isEmpty) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryRed));
    } else if (state.requests.isEmpty && state.errorMessage == null) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_rounded, size: 80, color: AppColors.lightGrey),
          const SizedBox(height: 10),
          Text('No requests yet!',
              style: AppStyles.heading2.copyWith(color: AppColors.greyText)),
          const SizedBox(height: 5),
          Text('Tap the + button to create a new blood request.',
              textAlign: TextAlign.center, style: AppStyles.subheading),
        ],
      ));
    } else if (state.errorMessage != null && state.requests.isEmpty) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded,
              size: 80, color: AppColors.dangerRed),
          const SizedBox(height: 10),
          Text('Failed to load requests',
              style: AppStyles.heading2.copyWith(color: AppColors.dangerRed)),
          const SizedBox(height: 5),
          Text(state.errorMessage!,
              textAlign: TextAlign.center, style: AppStyles.subheading),
        ],
      ));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: state.requests.length,
      itemBuilder: (context, index) {
        final request = state.requests[index];
        Color statusColor;
        IconData statusIcon;

        switch (request.status) {
          case 'approved':
            statusColor = AppColors.successGreen;
            statusIcon = Icons.check_circle_rounded;
            break;
          case 'declined':
            statusColor = AppColors.dangerRed;
            statusIcon = Icons.cancel_rounded;
            break;
          default: // pending
            statusColor = AppColors.warningOrange;
            statusIcon = Icons.watch_later_rounded;
        }

        return Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: InkWell( // Added InkWell for a ripple effect on tap
            onTap: () {
              // Optional: Navigate to a detailed view of the request
              // Navigator.push(context, MaterialPageRoute(builder: (context) => RequestDetailScreen(request: request)));
            },
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          request.description,
                          style: AppStyles.cardTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(statusIcon, size: 18, color: statusColor),
                            const SizedBox(width: 5),
                            Text(
                              request.status.toUpperCase(),
                              style: AppStyles.statusText.copyWith(color: statusColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Divider(color: AppColors.lightGrey.withOpacity(0.5)),
                  const SizedBox(height: 10),
                  _buildInfoRow(Icons.monetization_on_rounded, 'Needed Amount:',
                      'Rs. ${NumberFormat('#,##0').format(request.neededAmount)}', AppColors.accentBlue),
                  _buildInfoRow(Icons.medication_rounded, 'Condition:',
                      request.condition, AppColors.primaryRed),
                  if (request.feedback != null && request.feedback!.isNotEmpty)
                    _buildInfoRow(Icons.comment_rounded, 'Admin Feedback:',
                        request.feedback!, AppColors.greyText),
                  if (request.createdAt != null)
                    _buildInfoRow(
                        Icons.calendar_today_rounded,
                        'Requested On:',
                        DateFormat('yyyy-MM-dd – hh:mm a')
                            .format(request.createdAt!),
                        AppColors.greyText),
                  const SizedBox(height: 15),
                  if (request.status == 'pending' && request.id != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: state.isLoading
                            ? null
                            : () => _confirmDelete(request.id!),
                        icon: state.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(AppColors.white),
                                ),
                              )
                            : const Icon(Icons.delete_forever_rounded,
                                color: AppColors.white),
                        label: Text(
                          state.isLoading ? 'Processing...' : 'Delete Pending Request',
                          style: const TextStyle(color: AppColors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.dangerRed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 10),
          Text('$label ',
              style: AppStyles.cardSubtitle.copyWith(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(value, style: AppStyles.cardSubtitle),
          ),
        ],
      ),
    );
  }
}