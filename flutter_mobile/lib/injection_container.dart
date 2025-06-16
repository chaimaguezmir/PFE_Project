import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/network/network_controller.dart';
import 'package:flutter_mobile/data/data_sources/auth_remote_datasource.dart';
import 'package:flutter_mobile/data/data_sources/auth_remote_datasource_impl.dart';
import 'package:flutter_mobile/data/data_sources/group_remote_datasource.dart';
import 'package:flutter_mobile/data/data_sources/group_remote_datasource_impl.dart';
import 'package:flutter_mobile/data/repositories/auth_repository_impl.dart';
import 'package:flutter_mobile/data/repositories/group_repository_impl.dart';
import 'package:flutter_mobile/domain/repositories/auth_repository.dart';
import 'package:flutter_mobile/domain/repositories/group_repository.dart';
import 'package:flutter_mobile/presentation/bloc/auth/forgot_password/forgot_password_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/auth/login/login_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/auth/onboarding/auth_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/auth/signup/signup_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/group/group_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/main_screen/main_screen_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initInjectionContainer() async {
  // ============================================================================
  // External Dependencies
  // ============================================================================

  // HTTP Client
  sl.registerLazySingleton<Dio>(() => Dio());

  // Shared Preferences
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // ============================================================================
  // Data Sources
  // ============================================================================

  // Auth Remote Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<GroupRemoteDataSource>(
    () => GroupRemoteDataSourceImpl(sl()),
  );

  // ============================================================================
  // Repositories
  // ============================================================================

  // Auth Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<GroupRepository>(() => GroupRepositoryImpl(sl()));

  // ============================================================================
  // BLoC / Cubits
  // ============================================================================

  // Auth Related Cubits
  sl.registerFactory<SignUpCubit>(() => SignUpCubit(sl()));
  sl.registerFactory<LoginCubit>(() => LoginCubit(sl()));
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl()));
  sl.registerFactory<ForgotPasswordCubit>(() => ForgotPasswordCubit(sl()));

  // Main Screen Cubit
  sl.registerFactory<MainScreenCubit>(() => MainScreenCubit());
  sl.registerFactory<GroupCubit>(() => GroupCubit(sl()));

  // ============================================================================
  // Other Dependencies
  sl.registerLazySingleton<NetworkController>(() => NetworkController());
}
