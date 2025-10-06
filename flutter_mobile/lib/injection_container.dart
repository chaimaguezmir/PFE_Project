import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_mobile/data/data_sources/auth_remote_datasource.dart';
import 'package:flutter_mobile/data/data_sources/auth_remote_datasource_impl.dart';
import 'package:flutter_mobile/data/data_sources/disease_remote_datasource.dart';
import 'package:flutter_mobile/data/data_sources/disease_remote_datasource_impl.dart';
import 'package:flutter_mobile/data/data_sources/group_remote_datasource.dart';
import 'package:flutter_mobile/data/data_sources/group_remote_datasource_impl.dart';
import 'package:flutter_mobile/data/data_sources/medicine_remote_datasource.dart';
import 'package:flutter_mobile/data/data_sources/medicine_remote_datasource_impl.dart';
import 'package:flutter_mobile/data/data_sources/pharmacy_remote_datasource.dart';
import 'package:flutter_mobile/data/data_sources/pharmacy_remote_datasource_impl.dart';
import 'package:flutter_mobile/data/data_sources/prescription_remote_datasource.dart';
import 'package:flutter_mobile/data/data_sources/prescription_remote_datasource_impl.dart';
import 'package:flutter_mobile/data/data_sources/profile_remote_datasource.dart';
import 'package:flutter_mobile/data/data_sources/profile_remote_datasource_impl.dart';
import 'package:flutter_mobile/data/data_sources/reminder_remote_data_source.dart';
import 'package:flutter_mobile/data/data_sources/reminder_remote_data_source_impl.dart';
import 'package:flutter_mobile/data/data_sources/treatment_remote_datasource.dart';
import 'package:flutter_mobile/data/data_sources/treatment_remote_datasource_impl.dart';

// User Management Data Sources
import 'package:flutter_mobile/data/data_sources/user_reminder_remote_data_source.dart';
import 'package:flutter_mobile/data/data_sources/user_reminder_remote_data_source_impl.dart';
import 'package:flutter_mobile/data/data_sources/user_prescription_remote_data_source.dart';
import 'package:flutter_mobile/data/data_sources/user_prescription_remote_data_source_impl.dart';
import 'package:flutter_mobile/data/data_sources/user_treatment_remote_data_source.dart';
import 'package:flutter_mobile/data/data_sources/user_treatment_remote_data_source_impl.dart';

import 'package:flutter_mobile/data/repositories/auth_repository_impl.dart';
import 'package:flutter_mobile/data/repositories/group_repository_impl.dart';
import 'package:flutter_mobile/data/repositories/medicine_repository_impl.dart';
import 'package:flutter_mobile/data/repositories/pharmacy_repository_impl.dart';
import 'package:flutter_mobile/data/repositories/prescription_repository_impl.dart';
import 'package:flutter_mobile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_mobile/data/repositories/treatment_repository_impl.dart';
import 'package:flutter_mobile/data/repositories/reminder_repository_impl.dart';
import 'package:flutter_mobile/data/repositories/disease_repository_impl.dart';
import 'package:flutter_mobile/domain/repositories/user_prescription_repository.dart';
import 'package:flutter_mobile/data/repositories/user_prescription_repository_impl.dart';

// User Management Repositories
import 'package:flutter_mobile/data/repositories/user_reminder_repository_impl.dart';
import 'package:flutter_mobile/data/repositories/user_treatment_repository_impl.dart';

import 'package:flutter_mobile/domain/repositories/auth_repository.dart';
import 'package:flutter_mobile/domain/repositories/group_repository.dart';
import 'package:flutter_mobile/domain/repositories/medicine_repository.dart';
import 'package:flutter_mobile/domain/repositories/pharmacy_repository.dart';
import 'package:flutter_mobile/domain/repositories/prescription_repository.dart';
import 'package:flutter_mobile/domain/repositories/profile_repository.dart';
import 'package:flutter_mobile/domain/repositories/reminder_repository.dart';
import 'package:flutter_mobile/domain/repositories/treatment_repository.dart';
import 'package:flutter_mobile/domain/repositories/disease_repository.dart';

// User Management Domain Repositories
import 'package:flutter_mobile/domain/repositories/user_reminder_repository.dart';
import 'package:flutter_mobile/domain/repositories/user_treatment_repository.dart';

import 'package:flutter_mobile/presentation/bloc/auth/auth/auth_bloc.dart';
import 'package:flutter_mobile/presentation/bloc/auth/forgot_password/forgot_password_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/auth/login/login_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/auth/onboarding/auth_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/auth/signup/signup_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/group/group_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/home/prescription_creation_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/home/prescription_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/home/welcome_screen_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/profile/edit_profile_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/profile/profile_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/services/services_cubit.dart';

// User Management Cubits
import 'package:flutter_mobile/presentation/bloc/user_management/user_welcome_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/user_management/user_prescription_cubit.dart';
import 'package:flutter_mobile/presentation/bloc/user_management/user_prescription_creation_cubit.dart';

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/data_sources/auth_interceptor.dart';

final sl = GetIt.instance;
final dio = Dio();

Future<void> initInjectionContainer() async {
  // ============================================
  // Core Dependencies
  // ============================================

  // Dio configuration
  dio.options = BaseOptions(
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
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

  // Network Controller
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  // ============================================
  // Data Sources - Current User
  // ============================================

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<GroupRemoteDataSource>(
    () => GroupRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<PharmacyRemoteDataSource>(
    () => PharmacyRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<MedicineRemoteDataSource>(
    () => MedicineRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<PrescriptionRemoteDataSource>(
    () => PrescriptionRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<TreatmentRemoteDataSource>(
    () => TreatmentRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ReminderRemoteDataSource>(
    () => ReminderRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<DiseaseRemoteDataSource>(
    () => DiseaseRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl()),
  );

  // ============================================
  // Data Sources - User Management (Group Medical)
  // ============================================

  sl.registerLazySingleton<UserReminderRemoteDataSource>(
    () => UserReminderRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<UserPrescriptionRemoteDataSource>(
    () => UserPrescriptionRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<UserTreatmentRemoteDataSource>(
    () => UserTreatmentRemoteDataSourceImpl(sl()),
  );

  // ============================================
  // Repositories - Current User
  // ============================================

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<GroupRepository>(() => GroupRepositoryImpl(sl()));
  sl.registerLazySingleton<PharmacyRepository>(
    () => PharmacyRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<MedicineRepository>(
    () => MedicineRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<PrescriptionRepository>(
    () => PrescriptionRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<TreatmentRepository>(
    () => TreatmentRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ReminderRepository>(
    () => ReminderRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<DiseaseRepository>(
    () => DiseaseRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );

  // ============================================
  // Repositories - User Management (Group Medical)
  // ============================================

  sl.registerLazySingleton<UserReminderRepository>(
    () => UserReminderRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<UserPrescriptionRepository>(
    () => UserPrescriptionRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<UserTreatmentRepository>(
    () => UserTreatmentRepositoryImpl(sl()),
  );

  // ============================================
  // BLoCs / Cubits - Authentication
  // ============================================

  sl.registerFactory<SignUpCubit>(() => SignUpCubit(sl()));
  sl.registerFactory<LoginCubit>(() => LoginCubit(sl()));
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl()));
  sl.registerFactory<ForgotPasswordCubit>(() => ForgotPasswordCubit(sl()));
  sl.registerLazySingleton<AuthBloc>(() => AuthBloc(sl(), sl()));

  // ============================================
  // BLoCs / Cubits - Profile
  // ============================================

  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl()));
  sl.registerFactory<EditProfileCubit>(
    () => EditProfileCubit(sl<ProfileRepository>(), sl<SharedPreferences>()),
  );

  // ============================================
  // BLoCs / Cubits - Group
  // ============================================

  sl.registerFactory<GroupCubit>(() => GroupCubit(sl()));

  // ============================================
  // BLoCs / Cubits - Services
  // ============================================

  sl.registerFactory<ServicesCubit>(() => ServicesCubit(sl(), sl()));

  // ============================================
  // BLoCs / Cubits - Home (Current User)
  // ============================================

  sl.registerFactory<PrescriptionCubit>(() => PrescriptionCubit(sl(), sl()));
  sl.registerFactory<WelcomeScreenCubit>(
    () => WelcomeScreenCubit(reminderRepository: sl()),
  );
  sl.registerFactory<PrescriptionCreationCubit>(
    () => PrescriptionCreationCubit(sl(), sl(), sl(), sl(), sl(), sl()),
  );

  // ============================================
  // BLoCs / Cubits - User Management (Group Medical)
  // ============================================

  sl.registerFactory<UserWelcomeCubit>(
    () => UserWelcomeCubit(userReminderRepository: sl()),
  );
  sl.registerFactory<UserPrescriptionCubit>(
    () => UserPrescriptionCubit(sl(), sl()),
  );
  sl.registerFactory<UserPrescriptionCreationCubit>(
    () => UserPrescriptionCreationCubit(sl(), sl(), sl(), sl(), sl()),
  );
}
