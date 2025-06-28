// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:chat_app_ex/core/di/injection.dart' as _i830;
import 'package:chat_app_ex/core/localization_cubit.dart' as _i85;
import 'package:chat_app_ex/core/router/router.dart' as _i874;
import 'package:chat_app_ex/core/services/services.dart' as _i658;
import 'package:chat_app_ex/features/home/vide_model/home_cubit.dart' as _i686;
import 'package:chat_app_ex/features/login/data/repositories/auth_repository_impl.dart'
    as _i945;
import 'package:chat_app_ex/features/login/data/services/country_service.dart'
    as _i253;
import 'package:chat_app_ex/features/login/view_model/auth_cubit.dart' as _i471;
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_messaging/firebase_messaging.dart' as _i892;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    final serviceModule = _$ServiceModule();
    gh.factory<_i686.HomeCubit>(() => _i686.HomeCubit());
    gh.factory<_i253.CountryService>(() => _i253.CountryService());
    gh.lazySingleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => registerModule.firestore);
    gh.lazySingleton<_i892.FirebaseMessaging>(() => registerModule.message);
    await gh.lazySingletonAsync<_i460.SharedPreferences>(
      () => serviceModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i874.AuthNotifier>(() => _i874.AuthNotifier());
    gh.factory<_i85.LocalizationCubit>(
      () => _i85.LocalizationCubit(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i945.AuthRepository>(
      () => _i945.AuthRepositoryImpl(
        gh<_i59.FirebaseAuth>(),
        gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i658.APIServices>(
      () => _i658.APIServices(
        gh<_i974.FirebaseFirestore>(),
        gh<_i59.FirebaseAuth>(),
        gh<_i892.FirebaseMessaging>(),
      ),
    );
    gh.factory<_i471.AuthCubit>(
      () => _i471.AuthCubit(gh<_i945.AuthRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i830.RegisterModule {}

class _$ServiceModule extends _i830.ServiceModule {}
