import 'package:dio/dio.dart';
import 'package:flutter_mobile/data/repositories/auth_repository_impl.dart';
import 'package:flutter_mobile/domain/repositories/auth_repository.dart';
import 'package:flutter_mobile/presentation/bloc/onboarding/auth_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/signup/signup_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initInjectionContainer() async {
  sl.registerLazySingleton<Dio>(() => Dio());


  // Register Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // Register SharedPreferences
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  sl.registerFactory(()=>SignUpCubit(sl()));
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl()));
}
