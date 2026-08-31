import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:machine_test_court_click/utiiity/app_theme/app_theme.dart';
import 'package:machine_test_court_click/utiiity/get_it_locator.dart';
import 'package:machine_test_court_click/utiiity/router/app_routers.dart';

import 'feature/home/presentation/bloc/home_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/.env');
  setupServiceLocator();
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => HomeBloc())

      ],
        child: MaterialApp.router(
          title: 'Court Click Movies',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          // The UI is designed around the dark, Netflix-style palette, so dark
          // mode is forced regardless of system setting. Both ThemeData
          // definitions exist so this can be switched to ThemeMode.system later.
          themeMode: ThemeMode.dark,
          routerConfig: appRouter,
        )

    );
  }
}

