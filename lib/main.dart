import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/app_state.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/recipe_config_screen.dart';
import 'screens/brewing_guide_screen.dart';
import 'screens/timer_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = AppState();
  await appState.load();
  runApp(
    ChangeNotifierProvider(
      create: (_) => appState,
      child: const CoffeeApp(),
    ),
  );
}

class CoffeeApp extends StatelessWidget {
  const CoffeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.brown.shade50,
        foregroundColor: Colors.brown.shade900,
        elevation: 0,
      ),
    );

    return MaterialApp(
      title: 'Brew Master',
      theme: theme,
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
        RecipeConfigScreen.routeName: (_) => const RecipeConfigScreen(),
        BrewingGuideScreen.routeName: (_) => const BrewingGuideScreen(),
        TimerScreen.routeName: (_) => const TimerScreen(),
        HistoryScreen.routeName: (_) => const HistoryScreen(),
        SettingsScreen.routeName: (_) => const SettingsScreen(),
      },
    );
  }
}