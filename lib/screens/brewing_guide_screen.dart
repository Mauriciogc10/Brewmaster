import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import 'timer_screen.dart';

class BrewingGuideScreen extends StatelessWidget {
  static const routeName = '/guide';
  const BrewingGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final m = appState.selectedMethod;
    if (m == null) return const Scaffold(body: Center(child: Text('No hay método seleccionado')));

    return Scaffold(
      appBar: AppBar(title: Text('Guía: ${m.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumen', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Molienda: ${appState.grind} • Temp: ${appState.temperatureC}°C • Tiempo: ${appState.totalSeconds ~/ 60}–${(appState.totalSeconds/60).ceil()} min'),
            const SizedBox(height: 16),
            Text('Pasos', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: appState.steps.length,
                itemBuilder: (_, i) {
                  final step = appState.steps[i];
                  return ListTile(
                    leading: CircleAvatar(child: Text('${i+1}')),
                    title: Text(step.title),
                    trailing: Text('${step.seconds}s'),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, TimerScreen.routeName),
                icon: const Icon(Icons.timer),
                label: const Text('Iniciar temporizador'),
              ),
            )
          ],
        ),
      ),
    );
  }
}