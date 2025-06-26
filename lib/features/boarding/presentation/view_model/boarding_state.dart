import 'package:equatable/equatable.dart';

class BoardingState extends Equatable {
  final bool isCreateAccountHovered;
  final bool isLoginHovered;
  final bool navigateToSignup;
  final bool navigateToLogin;

  const BoardingState({
    required this.isCreateAccountHovered,
    required this.isLoginHovered,
    required this.navigateToSignup,
    required this.navigateToLogin,
  });

  // ADDED: An initial state constructor for clarity.
  const BoardingState.initial()
      : isCreateAccountHovered = false,
        isLoginHovered = false,
        navigateToSignup = false,
        navigateToLogin = false;

  BoardingState copyWith({
    bool? isCreateAccountHovered,
    bool? isLoginHovered,
    bool? navigateToSignup,
    bool? navigateToLogin,
  }) {
    return BoardingState(
      isCreateAccountHovered: isCreateAccountHovered ?? this.isCreateAccountHovered,
      isLoginHovered: isLoginHovered ?? this.isLoginHovered,
      navigateToSignup: navigateToSignup ?? this.navigateToSignup,
      navigateToLogin: navigateToLogin ?? this.navigateToLogin,
    );
  }

  // ADDED: props list for Equatable to work correctly.
  @override
  List<Object> get props => [
        isCreateAccountHovered,
        isLoginHovered,
        navigateToSignup,
        navigateToLogin,
      ];
}