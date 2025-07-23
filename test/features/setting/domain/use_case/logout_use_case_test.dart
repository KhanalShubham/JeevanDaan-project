import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jeevandaan/features/setting/domain/use_case/logout_use_case.dart';
import 'package:jeevandaan/app/shared_pref/token_shared_prefs.dart';
import 'package:dartz/dartz.dart';
import 'package:jeevandaan/core/error/failure.dart';

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

void main() {
  test('calls clearToken on TokenSharedPrefs', () async {
    final prefs = MockTokenSharedPrefs();
    final usecase = LogoutUseCase(tokenSharedPrefs: prefs);
    when(() => prefs.clearToken()).thenAnswer((_) async => const Right(null));
    await usecase();
    verify(() => prefs.clearToken()).called(1);
  });
}