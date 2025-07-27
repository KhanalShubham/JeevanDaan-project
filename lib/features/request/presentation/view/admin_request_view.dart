import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/features/request/presentation/view_model/admin_request_view_model.dart';
import 'package:jeevandaan/features/request/presentation/view_model/admin_request_event.dart';
import 'package:jeevandaan/features/request/presentation/view_model/admin_request_state.dart';
import 'package:jeevandaan/features/request/domain/entity/request_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminRequestView extends StatelessWidget {
  final String token;
  final AdminRequestViewModel viewModel;
  const AdminRequestView({Key? key, required this.token, required this.viewModel}) : super(key: key);

  Future<void> _clearAdminSession(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('user_role');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('last_login_timestamp');
    
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'declined':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel..add(GetAllRequestsForAdminEvent(token: token)),
      child: BlocBuilder<AdminRequestViewModel, AdminRequestState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Admin Requests'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    context.read<AdminRequestViewModel>().add(GetAllRequestsForAdminEvent(token: token));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    context.read<AdminRequestViewModel>().add(AdminLogoutEvent());
                    // Clear admin session and navigate to login
                    _clearAdminSession(context);
                  },
                ),
              ],
            ),
            body: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error, size: 64, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(
                              'Error: ${state.errorMessage}',
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<AdminRequestViewModel>().add(GetAllRequestsForAdminEvent(token: token));
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : state.requests.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.inbox, size: 64, color: Colors.grey),
                                const SizedBox(height: 16),
                                const Text(
                                  'No requests found',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'There are no requests to review at the moment.',
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                        itemCount: state.requests.length,
                        itemBuilder: (context, index) {
                          final request = state.requests[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.grey[300],
                                        child: Text(
                                          request.uploadedBy.isNotEmpty 
                                              ? request.uploadedBy[0].toUpperCase() 
                                              : 'U',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              request.uploadedBy.isNotEmpty 
                                                  ? request.uploadedBy 
                                                  : 'Unknown User',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              'Amount: \$${request.neededAmount}',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(request.status),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          request.status.toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Description:',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    request.description,
                                    style: const TextStyle(fontSize: 14),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Condition: ${request.condition}',
                                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                      ),
                                      if (request.status == 'pending')
                                        ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (_) => UpdateStatusDialog(
                                                request: request,
                                                token: token,
                                                viewModel: context.read<AdminRequestViewModel>(),
                                              ),
                                            );
                                          },
                                          child: const Text('Review'),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          );
        },
      ),
    );
  }
}

class UpdateStatusDialog extends StatefulWidget {
  final RequestEntity request;
  final String token;
  final AdminRequestViewModel viewModel;
  const UpdateStatusDialog({Key? key, required this.request, required this.token, required this.viewModel}) : super(key: key);

  @override
  State<UpdateStatusDialog> createState() => _UpdateStatusDialogState();
}

class _UpdateStatusDialogState extends State<UpdateStatusDialog> {
  String status = 'approved';
  String feedback = '';
  late num amount;

  @override
  void initState() {
    super.initState();
    amount = widget.request.neededAmount;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Request Status'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<String>(
            value: status,
            items: const [
              DropdownMenuItem(value: 'approved', child: Text('Approve')),
              DropdownMenuItem(value: 'declined', child: Text('Decline')),
            ],
            onChanged: (val) => setState(() => status = val ?? 'approved'),
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Feedback'),
            onChanged: (val) => feedback = val,
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Amount'),
            keyboardType: TextInputType.number,
            controller: TextEditingController(text: amount.toString()),
            onChanged: (val) => amount = num.tryParse(val) ?? widget.request.neededAmount,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.viewModel.add(UpdateRequestStatusEvent(
              requestId: widget.request.id!,
              status: status,
              neededAmount: amount,
              feedback: feedback,
              token: widget.token,
            ));
            Navigator.of(context).pop();
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
} 