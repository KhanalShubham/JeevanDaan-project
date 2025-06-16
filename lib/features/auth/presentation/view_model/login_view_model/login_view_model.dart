import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeevandaan/features/auth/domain/entity/user_entity.dart';
import 'package:jeevandaan/features/auth/domain/use_case/login_use_case.dart';
import 'package:jeevandaan/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:jeevandaan/features/auth/presentation/view_model/login_view_model/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc(this.loginUseCase) : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      try {
        await loginUseCase.execute(
          UserEntity(email: event.email, password: event.password),
        );
        emit(LoginSuccess());
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });
  }
}