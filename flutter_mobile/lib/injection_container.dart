import 'package:flutter_mobile/presentation/bloc/auth_cubit/auth_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;
Future<void> initInjectionContainer() async {
  // Register SharedPreferences

  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl()));
}
