class BrewSession {
  final String methodId;
  final String methodName;
  final String dateIso;
  final double waterMl;
  final double coffeeGrams;
  final double ratio;
  final String grind;
  final int temperatureC;
  final int totalSeconds;

  BrewSession({
    required this.methodId,
    required this.methodName,
    required this.dateIso,
    required this.waterMl,
    required this.coffeeGrams,
    required this.ratio,
    required this.grind,
    required this.temperatureC,
    required this.totalSeconds,
  });

  Map<String, dynamic> toJson() => {
    'methodId': methodId,
    'methodName': methodName,
    'dateIso': dateIso,
    'waterMl': waterMl,
    'coffeeGrams': coffeeGrams,
    'ratio': ratio,
    'grind': grind,
    'temperatureC': temperatureC,
    'totalSeconds': totalSeconds,
  };

  factory BrewSession.fromJson(Map<String, dynamic> j) => BrewSession(
    methodId: j['methodId'],
    methodName: j['methodName'],
    dateIso: j['dateIso'],
    waterMl: (j['waterMl'] as num).toDouble(),
    coffeeGrams: (j['coffeeGrams'] as num).toDouble(),
    ratio: (j['ratio'] as num).toDouble(),
    grind: j['grind'],
    temperatureC: j['temperatureC'],
    totalSeconds: j['totalSeconds'],
  );
}