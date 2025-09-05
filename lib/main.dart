import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ludo_game/global_state/app_global.dart';
import 'package:ludo_game/global_state/globalState.dart';
import 'package:ludo_game/ludo_game/board.dart';
import 'package:ludo_game/ludo_game/dice.dart';
import 'package:ludo_game/ludo_game/game.dart';
import 'package:ludo_game/presentation/resources/color_manager.dart';
import 'package:ludo_game/presentation/resources/theme/theme_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();

   await ColorManager().loadPrimaryColor();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
   MyApp({super.key});
  

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppThemes _appThemes = AppThemes();
  @override
  void initState() {
    super.initState();
    _appThemes.loadThemePreference();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _appThemes.isDarkMode,
        builder: (context, isDarkMode, _) {
          return MultiBlocProvider(
              providers: [BlocProvider(create: (_) => HomeBloc())],
              child: MaterialApp(
                navigatorKey: AppGlobal.navigatorKey,
                debugShowCheckedModeBanner: false,
                // initialRoute: Routes.splashPage,
                // onGenerateRoute: RouteGenerator.getRoute,
                
                home: HomePage(
                  isDarkMode: isDarkMode,
                ),
                theme: _appThemes.isDarkMode.value ? AppThemes.darkTheme : AppThemes.lightTheme,
              ));
        });
  }
}
