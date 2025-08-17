import 'dart:async';
import 'package:flutter/material.dart';
import '../models/brew_method.dart';
import '../utils/format.dart';

class StepTimerController {
  void Function()? onStart;
  void Function()? onPause;
  void Function()? onReset;
}

class StepTimer extends StatefulWidget {
  final List<BrewStep> steps;
  final void Function()? onFinished;
  final StepTimerController? controller;
  const StepTimer({super.key, required this.steps, this.onFinished, this.controller});

  @override
  State<StepTimer> createState() => _StepTimerState();
}

class _StepTimerState extends State<StepTimer> {
  int currentStep = 0;
  int remaining = 0;
  Timer? _timer;
  bool running = false;

  @override
  void initState() {
    super.initState();
    remaining = widget.steps.isNotEmpty ? widget.steps.first.seconds : 0;
    if (widget.controller != null) {
      widget.controller!.onStart = start;
      widget.controller!.onPause = pause;
      widget.controller!.onReset = reset;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void tick(_) {
    if (remaining > 0) {
      setState(() => remaining--);
    } else {
      // siguiente paso o fin
      if (currentStep < widget.steps.length - 1) {
        setState(() {
          currentStep++;
          remaining = widget.steps[currentStep].seconds;
        });
      } else {
        _timer?.cancel();
        setState(() => running = false);
        if (widget.onFinished != null) widget.onFinished!();
      }
    }
  }

  void start() {
    if (running) return;
    setState(() => running = true);
    _timer = Timer.periodic(const Duration(seconds: 1), tick);
  }

  void pause() {
    _timer?.cancel();
    setState(() => running = false);
  }

  void reset() {
    _timer?.cancel();
    setState(() {
      running = false;
      currentStep = 0;
      remaining = widget.steps.isNotEmpty ? widget.steps.first.seconds : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.steps.isEmpty) {
      return const Text('No hay pasos configurados');
    }
    final step = widget.steps[currentStep];
    final totalSteps = widget.steps.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Paso ${currentStep + 1} de $totalSteps', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(step.title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Center(
          child: Text(
            fmtSeconds(remaining),
            style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: running ? pause : start,
              icon: Icon(running ? Icons.pause : Icons.play_arrow),
              label: Text(running ? 'Pausar' : 'Iniciar'),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: reset,
              icon: const Icon(Icons.replay),
              label: const Text('Reiniciar'),
            ),
          ],
        )
      ],
    );
  }
}