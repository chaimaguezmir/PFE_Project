import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/network/network_controller.dart';
import 'package:flutter_mobile/data/data_sources/auth_remote_datasource.dart';
import 'package:flutter_mobile/data/data_sources/auth_remote_datasource_impl.dart';
import 'package:flutter_mobile/data/data_sources/group_remote_datasource.dart';
import 'package:flutter_mobile/data/data_sources/group_remote_datasource_impl.dart';
import 'package:flutter_mobile/data/data_sources/medicine_remote_datasource.dart';
import 'package:flutter_mobile/data/data_sources/medicine_remote_datasource_impl.dart';
import 'package:flutter_mobile/data/data_sources/pharmacy_remote_datasource.dart';
import 'package:flutter_mobile/data/data_sources/pharmacy_remote_datasource_impl.dart';
import 'package:flutter_mobile/data/data_sources/prescription_remote_datasource.dart';
import 'package:flutter_mobile/data/data_sources/prescription_remote_datasource_impl.dart';
import 'package:flutter_mobile/data/data_sources/treatment_remote_datasource.dart';
import 'package:flutter_mobile/data/data_sources/treatment_remote_datasource_impl.dart';
import 'package:flutter_mobile/data/repositories/auth_repository_impl.dart';
import 'package:flutter_mobile/data/repositories/group_repository_impl.dart';
import 'package:flutter_mobile/data/repositories/medicine_repository_impl.dart';
import 'package:flutter_mobile/data/repositories/pharmacy_repository_impl.dart';
import 'package:flutter_mobile/data/repositories/prescription_repository_impl.dart';
import 'package:flutter_mobile/data/repositories/treatment_repository_impl.dart';
import 'package:flutter_mobile/domain/repositories/auth_repository.dart';
import 'package:flutter_mobile/domain/repositories/group_repository.dart';
import 'package:flutter_mobile/domain/repositories/medicine_repository.dart';
import 'package:flutter_mobile/domain/repositories/pharmacy_repository.dart';
import 'package:flutter_mobile/domain/repositories/prescription_repository.dart';
import 'package:flutter_mobile/domain/repositories/treatment_repository.dart';
import 'package:flutter_mobile/presentation/bloc/auth/auth/auth_bloc.dart';
import 'package:flutter_mobile/presentation/bloc/auth/forgot_password/forgot_password_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/auth/login/login_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/auth/onboarding/auth_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/auth/signup/signup_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/group/group_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/home/prescription_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/home/welcome_screen_cubit.dart';

import 'package:flutter_mobile/presentation/bloc/profile/profile_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/services/services_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/data_sources/auth_interceptor.dart';

final sl = GetIt.instance;
final dio = Dio();


Future<void> initInjectionContainer() async {
  // Dio configuration
  dio.options = BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 30),

  );
  // Shared Preferences
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Dio (register first)
  sl.registerLazySingleton<Dio>(() => dio);

  // Interceptor (register after Dio)
  sl.registerLazySingleton<Interceptor>(
    () => AuthInterceptor(sl<Dio>(), sl<SharedPreferences>()),
  );
  // Add Interceptor to Dio
  dio.interceptors.add(sl<Interceptor>());

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<GroupRemoteDataSource>(
    () => GroupRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<PharmacyRemoteDataSource>(() => PharmacyRemoteDataSourceImpl(sl()),);
  sl.registerLazySingleton<MedicineRemoteDataSource>(() => MedicineRemoteDataSourceImpl(sl()),);
  sl.registerLazySingleton<PrescriptionRemoteDataSource>(
        () => PrescriptionRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<TreatmentRemoteDataSource>(
        () => TreatmentRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<GroupRepository>(() => GroupRepositoryImpl(sl()));
  sl.registerLazySingleton<PharmacyRepository>(() => PharmacyRepositoryImpl(sl()),);
  sl.registerLazySingleton<MedicineRepository>(() => MedicineRepositoryImpl(sl()),);
  sl.registerLazySingleton<PrescriptionRepository>(
        () => PrescriptionRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<TreatmentRepository>(
        () => TreatmentRepositoryImpl(sl()),
  );


  // BLoCs / Cubits
  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl()));
  sl.registerFactory<SignUpCubit>(() => SignUpCubit(sl()));
  sl.registerFactory<LoginCubit>(() => LoginCubit(sl()));
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl()));
  sl.registerFactory<ForgotPasswordCubit>(() => ForgotPasswordCubit(sl()));
  sl.registerFactory<GroupCubit>(() => GroupCubit(sl()));
  sl.registerFactory<ServicesCubit>(() => ServicesCubit(sl(), sl()));
  sl.registerLazySingleton<AuthBloc>(() => AuthBloc(sl(), sl()));
  sl.registerFactory<PrescriptionCubit>(() => PrescriptionCubit(sl(), sl()));
  sl.registerFactory<WelcomeScreenCubit>(() => WelcomeScreenCubit());

  // Network Controller
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
}
