import 'package:chat_app_ex/core/di/injection.dart';
import 'package:chat_app_ex/core/localization_cubit.dart';
import 'package:chat_app_ex/core/router/router.dart';
import 'package:chat_app_ex/features/login/view_model/auth_cubit.dart';
import 'package:chat_app_ex/firebase_options.dart';
import 'package:chat_app_ex/localization/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nested/nested.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await configureDependencies();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  runApp(
    MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<AuthCubit>(
          create: (BuildContext context) => getIt<AuthCubit>(),
        ),
        BlocProvider<LocalizationCubit>(
          create: (BuildContext context) => getIt<LocalizationCubit>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalizationCubit, LocalizationState>(
      builder: (BuildContext context, LocalizationState state) {
        return ScreenUtilInit(
          designSize: MediaQuery.sizeOf(context),
          minTextAdapt: true,
          splitScreenMode: true,
          child: MaterialApp.router(
            routerConfig: router,
            locale: Locale(state.locale),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,
            title: 'ChatApp Demo',
            theme: _buildTheme(Brightness.light),
            darkTheme: _buildTheme(Brightness.dark),
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}

ThemeData _buildTheme(Brightness brightness) {
  ThemeData baseTheme = ThemeData(brightness: brightness);

  return baseTheme.copyWith(
    textTheme: GoogleFonts.outfitTextTheme(baseTheme.textTheme),
  );
}
