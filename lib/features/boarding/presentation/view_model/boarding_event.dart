import 'package:equatable/equatable.dart';

abstract class BoardingEvent extends Equatable {
  const BoardingEvent();

  @override
  List<Object> get props => [];
}

class CreateAccountHoverEvent extends BoardingEvent {
  final bool isHovered;
  const CreateAccountHoverEvent(this.isHovered);

  @override
  List<Object> get props => [isHovered];
}

class LoginHoverEvent extends BoardingEvent {
  final bool isHovered;
  const LoginHoverEvent(this.isHovered);

  @override
  List<Object> get props => [isHovered];
}

class NavigateToSignupEvent extends BoardingEvent {
  const NavigateToSignupEvent();
}

class NavigateToLoginEvent extends BoardingEvent {
  const NavigateToLoginEvent();
}

// ADDED: A new, specific event to reset all navigation flags.
class ResetNavigationEvent extends BoardingEvent {
  const ResetNavigationEvent();
}