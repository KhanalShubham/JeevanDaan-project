abstract class BoardingEvent {
  const BoardingEvent();
}

class CreateAccountHoverEvent extends BoardingEvent {
  final bool isHovered;
  const CreateAccountHoverEvent(this.isHovered);
}

class LoginHoverEvent extends BoardingEvent {
  final bool isHovered;
  const LoginHoverEvent(this.isHovered);
}

class NavigateToSignupEvent extends BoardingEvent {
  const NavigateToSignupEvent();
}

class NavigateToLoginEvent extends BoardingEvent {
  const NavigateToLoginEvent();
}