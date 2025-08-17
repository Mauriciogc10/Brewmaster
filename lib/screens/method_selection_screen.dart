import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../data/methods.dart';
import '../widgets/method_card.dart';
import 'recipe_config_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class MethodSelectionScreen extends StatelessWidget {
  static const routeName = '/methods';
  const MethodSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elige tu método'),
        actions: [
          IconButton(icon: const Icon(Icons.history), onPressed: () => Navigator.pushNamed(context, HistoryScreen.routeName)),
          IconButton(icon: const Icon(Icons.settings), onPressed: () => Navigator.pushNamed(context, SettingsScreen.routeName)),
        ],
      ),
      body: GridView.count(
        crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 3,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          for (final m in appState.methods)
            MethodCard(
              title: m.name,
              icon: _iconFor(m.id),
              onTap: () {
                appState.selectMethod(m);
                Navigator.pushNamed(context, RecipeConfigScreen.routeName);
              },
            )
        ],
      ),
    );
  }

  IconData _iconFor(String id) {
    switch (id) {
      case 'v60': return Icons.filter_alt;
      case 'chemex': return Icons.filter_list;
      case 'french_press': return Icons.coffee;
      case 'aeropress': return Icons.compress;
      case 'siphon': return Icons.bubble_chart;
      case 'moka': return Icons.local_fire_department;
      default: return Icons.local_cafe;
    }
  }
}