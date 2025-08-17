String fmtSeconds(int s) {
  final m = (s / 60).floor();
  final r = s % 60;
  return '${m.toString().padLeft(2,'0')}:${r.toString().padLeft(2,'0')}';
}