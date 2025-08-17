class Settings {
  final bool metric; // true: ml & °C, false: oz & °F
  final bool sound;
  final bool vibration;

  const Settings({
    this.metric = true,
    this.sound = true,
    this.vibration = true,
  });

  Settings copyWith({bool? metric, bool? sound, bool? vibration}) => Settings(
    metric: metric ?? this.metric,
    sound: sound ?? this.sound,
    vibration: vibration ?? this.vibration,
  );

  Map<String, dynamic> toJson() => {'metric': metric, 'sound': sound, 'vibration': vibration};
  factory Settings.fromJson(Map<String, dynamic> j) => Settings(
    metric: j['metric'] ?? true,
    sound: j['sound'] ?? true,
    vibration: j['vibration'] ?? true,
  );
}