import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:fake_store/features/authentication/domain/entities/user.dart';
import 'package:fake_store/features/authentication/domain/usecases/check_auth_status_use_case.dart';
import 'package:fake_store/features/authentication/domain/usecases/get_user_details_use_case.dart';
import 'package:fake_store/features/authentication/domain/usecases/login_use_case.dart';
import 'package:fake_store/features/authentication/domain/usecases/logout_use_case.dart';
import 'package:fake_store/features/authentication/domain/usecases/params/login_params.dart';

part 'auth_state.dart';

@LazySingleton()
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetUserDetailsUseCase getUserDetailsUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;

  AuthCubit(
    this.loginUseCase,
    this.logoutUseCase,
    this.getUserDetailsUseCase,
    this.checkAuthStatusUseCase,
  ) : super(AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());

    final isLoggedIn = await checkAuthStatusUseCase();
    if (isLoggedIn) {
      // For FakeStore API, we'll assume user ID is 1 for the demo user
      final userResult = await getUserDetailsUseCase(1);
      userResult.fold(
        (failure) => emit(const Authenticated(token: 'logged_in')),
        (user) => emit(Authenticated(token: 'logged_in', user: user)),
      );
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> login(String username, String password) async {
    emit(AuthLoading());

    final params = LoginParams(username: username, password: password);
    final result = await loginUseCase(params);
    result.fold((failure) => emit(AuthError(message: failure.message)), (
      token,
    ) async {
      // Get user details after successful login
      final userResult = await getUserDetailsUseCase(
        1,
      ); // FakeStore API demo user
      userResult.fold(
        (failure) => emit(Authenticated(token: token)),
        (user) => emit(Authenticated(token: token, user: user)),
      );
    });
  }

  Future<void> logout() async {
    emit(AuthLoading());

    final result = await logoutUseCase();
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(Unauthenticated()),
    );
  }
}
