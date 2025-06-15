class BoardingState {
  final bool isCreateAccountHovered;
  final bool isLoginHovered;
  final bool navigateToSignup;
  final bool navigateToLogin;

  const BoardingState({
    this.isCreateAccountHovered = false,
    this.isLoginHovered = false,
    this.navigateToSignup = false,
    this.navigateToLogin = false,
  });

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
}