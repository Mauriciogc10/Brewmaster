import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../widgets/timer_widget.dart';
import 'history_screen.dart';

class TimerScreen extends StatefulWidget {
  static const routeName = '/timer';
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final controller = StepTimerController();

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final steps = appState.steps;

    return Scaffold(
      appBar: AppBar(title: const Text('Temporizador')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StepTimer(
              steps: steps,
              controller: controller,
              onFinished: () {
                appState.addToHistory();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('¡Listo! Se guardó en Historial')));
                Navigator.pushReplacementNamed(context, HistoryScreen.routeName);
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: controller.onStart,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Iniciar'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: controller.onPause,
                  icon: const Icon(Icons.pause),
                  label: const Text('Pausar'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: controller.onReset,
                  icon: const Icon(Icons.replay),
                  label: const Text('Reiniciar'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}