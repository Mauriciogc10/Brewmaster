import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/settings.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final s = appState.settings;

    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Sistema métrico (ml, °C)'),
            subtitle: const Text('Desactiva para usar onzas y °F'),
            value: s.metric,
            onChanged: (v) => appState.updateSettings(s.copyWith(metric: v)),
          ),
          SwitchListTile(
            title: const Text('Sonido al finalizar'),
            value: s.sound,
            onChanged: (v) => appState.updateSettings(s.copyWith(sound: v)),
          ),
          SwitchListTile(
            title: const Text('Vibración al finalizar'),
            value: s.vibration,
            onChanged: (v) => appState.updateSettings(s.copyWith(vibration: v)),
          ),
          const SizedBox(height: 16),
          const Text('Acerca de', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Brew Master • App de ejemplo Flutter para iOS, Android y Web.'),
        ],
      ),
    );
  }
}