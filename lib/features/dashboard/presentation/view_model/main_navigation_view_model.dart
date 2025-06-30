import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/features/dashboard/presentation/view_model/main_navigation_state.dart';
import 'package:jeevandaan/features/user/presentation/view/login.dart';
import 'package:jeevandaan/features/user/presentation/view_model/login_view_model/login_view_model.dart';


class MainNavigationViewModel extends Cubit<MainNavigationState> {
  MainNavigationViewModel({required this.loginViewModel}) : super(MainNavigationState.initial());

  final LoginViewModel loginViewModel;

  void onTabTapped(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  void logout(BuildContext context) {
    // Wait for 2 seconds
    Future.delayed(const Duration(seconds: 2), () async {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BlocProvider.value(value: loginViewModel, child: LoginView()),
          ),
        );
      }
    });
  }
}