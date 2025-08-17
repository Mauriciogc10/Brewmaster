import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import 'brewing_guide_screen.dart';

class RecipeConfigScreen extends StatefulWidget {
  static const routeName = '/config';
  const RecipeConfigScreen({super.key});

  @override
  State<RecipeConfigScreen> createState() => _RecipeConfigScreenState();
}

class _RecipeConfigScreenState extends State<RecipeConfigScreen> {
  final waterCtrl = TextEditingController();
  final ratioCtrl = TextEditingController();
  final tempCtrl = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final s = context.read<AppState>();
    waterCtrl.text = s.waterMl.toStringAsFixed(0);
    ratioCtrl.text = s.ratio.toStringAsFixed(1);
    tempCtrl.text = s.temperatureC.toString();
  }

  @override
  void dispose() {
    waterCtrl.dispose();
    ratioCtrl.dispose();
    tempCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final m = appState.selectedMethod;
    if (m == null) return const Scaffold(body: Center(child: Text('No hay método seleccionado')));

    return Scaffold(
      appBar: AppBar(title: Text('Configurar: ${m.name}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: waterCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Agua (ml)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) {
                      final d = double.tryParse(v);
                      if (d != null) appState.updateConfig(waterMl: d);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: ratioCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Ratio (1:x)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) {
                      final d = double.tryParse(v);
                      if (d != null) appState.updateConfig(ratio: d);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: appState.grind,
                    items: const [
                      DropdownMenuItem(value: 'Fina', child: Text('Fina')),
                      DropdownMenuItem(value: 'Fina-media', child: Text('Fina-media')),
                      DropdownMenuItem(value: 'Media', child: Text('Media')),
                      DropdownMenuItem(value: 'Media-fina', child: Text('Media-fina')),
                      DropdownMenuItem(value: 'Gruesa', child: Text('Gruesa')),
                    ],
                    onChanged: (v) => appState.updateConfig(grind: v),
                    decoration: const InputDecoration(labelText: 'Molienda', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: tempCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Temperatura (°C)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) {
                      final d = int.tryParse(v);
                      if (d != null) appState.updateConfig(temperatureC: d);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(child: Text('Café necesario: ${appState.coffeeGrams.toStringAsFixed(1)} g')),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, BrewingGuideScreen.routeName),
                      icon: const Icon(Icons.menu_book),
                      label: const Text('Ver guía'),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Pasos', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...List.generate(appState.steps.length, (i) {
              final step = appState.steps[i];
              return ListTile(
                leading: CircleAvatar(child: Text('${i+1}')),
                title: Text(step.title),
                trailing: Text('${step.seconds}s'),
              );
            }),
          ],
        ),
      ),
    );
  }
}