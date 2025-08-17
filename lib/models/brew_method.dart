class BrewMethod {
  final String id;
  final String name;
  final double defaultRatio; // 1:ratio (agua)
  final String grind;
  final int temperatureC;
  final int totalSeconds;
  final List<BrewStep> steps;

  // UI additions
  final String difficulty;        // 'Fácil', 'Intermedio', 'Avanzado'
  final String imageAsset;        // assets/images/..
  final List<String> equipment;   // e.g., ['V60','Filtros','Balanza']

  const BrewMethod({
    required this.id,
    required this.name,
    required this.defaultRatio,
    required this.grind,
    required this.temperatureC,
    required this.totalSeconds,
    required this.steps,
    required this.difficulty,
    required this.imageAsset,
    required this.equipment,
  });

  String get timeRangeText {
    final min = (totalSeconds / 60.0) - 0.5;
    final max = (totalSeconds / 60.0) + 0.5;
    String fmt(double v) {
      final floor = v.floor();
      final frac = v - floor;
      if (frac < 0.25) return '$floor';
      if (frac < 0.75) return '${floor}-${floor+1}';
      return '${floor+1}';
    }
    // More stable simple display:
    final minM = (totalSeconds / 60.0).floor();
    final maxM = (totalSeconds / 60.0).ceil();
    return '$minM-${maxM} min';
  }

  String get equipmentSummary => equipment.join(', ');
}

class BrewStep {
  final String title;
  final int seconds;
  const BrewStep({required this.title, required this.seconds});

  Map<String, dynamic> toJson() => {'title': title, 'seconds': seconds};
  factory BrewStep.fromJson(Map<String, dynamic> j) => BrewStep(title: j['title'], seconds: j['seconds']);
}