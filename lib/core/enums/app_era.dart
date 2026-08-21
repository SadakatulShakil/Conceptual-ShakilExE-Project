/// The two worlds. The whole app is written once and rendered per era.
enum AppEra {
  retro,
  modern;

  /// Persisted key value.
  String get key => name;

  /// Label shown in the status-bar time control.
  String get yearLabel => switch (this) {
        AppEra.retro => "'03",
        AppEra.modern => '2026',
      };

  String get fullYear => switch (this) {
        AppEra.retro => '2003',
        AppEra.modern => '2026',
      };

  /// The era you travel to when toggling.
  AppEra get opposite =>
      this == AppEra.modern ? AppEra.retro : AppEra.modern;

  static AppEra fromKey(String? value) => AppEra.values.firstWhere(
        (e) => e.key == value,
        orElse: () => AppEra.retro, // default landing world
      );
}
