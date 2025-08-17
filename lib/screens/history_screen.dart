import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';

class HistoryScreen extends StatelessWidget {
  static const routeName = '/history';
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de preparaciones'),
        actions: [
          if (appState.history.isNotEmpty)
            IconButton(
              onPressed: appState.clearHistory,
              icon: const Icon(Icons.delete_forever),
              tooltip: 'Borrar historial',
            )
        ],
      ),
      body: appState.history.isEmpty
          ? const Center(child: Text('Aún no tienes preparaciones guardadas'))
          : ListView.separated(
              itemCount: appState.history.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (_, i) {
                final s = appState.history[i];
                final dt = DateTime.tryParse(s.dateIso)?.toLocal();
                final dateStr = dt != null ? '${dt.year}-${dt.month.toString().padLeft(2,'0')}-${dt.day.toString().padLeft(2,'0')} ${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}' : s.dateIso;
                return ListTile(
                  leading: const Icon(Icons.coffee),
                  title: Text('${s.methodName} • ${s.coffeeGrams.toStringAsFixed(1)} g café • ${s.waterMl.toStringAsFixed(0)} ml agua'),
                  subtitle: Text('Ratio 1:${s.ratio.toStringAsFixed(1)} • ${dateStr}'),
                );
              },
            ),
    );
  }
}