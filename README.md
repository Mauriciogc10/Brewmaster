# Brew Master (Flutter)

App de café de especialidad (V60, Chemex, Prensa francesa, AeroPress, Sifón japonés, Moka italiana).
Incluye:
- Splash Screen
- Method Selection Screen
- Recipe Configuration Screen
- Brewing Guide Screen
- Timer Screen
- Brewing History Screen
- Settings Screen

## Requisitos
- Flutter 3.x (Dart >= 3.3.0)
- iOS/Android/Web

## Cómo correr
```bash
flutter pub get
flutter run -d chrome   # Web
flutter run -d ios      # iOS (requiere Xcode)
flutter run -d android  # Android
```

## Notas
- Se usa `provider` para el estado y `shared_preferences` para persistir el historial y ajustes.
- Las recetas default están en `lib/data/methods.dart`. Puedes ajustar ratios, molienda, temperatura y pasos.
- La UI está en español y es Material 3.

Creado: 2025-08-13# Brewmaster
