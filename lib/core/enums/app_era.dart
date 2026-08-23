/// The two worlds. The whole app is written once and rendered per era.
enum AppEra {
  retro,
  modern;

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
}
