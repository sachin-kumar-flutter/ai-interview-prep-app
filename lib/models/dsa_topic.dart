/// Topics available for DSA practice (shown in the topic picker).
enum DsaTopic {
  arrays('Arrays'),
  strings('Strings'),
  trees('Trees'),
  graphs('Graphs'),
  dynamicProgramming('Dynamic Programming');

  const DsaTopic(this.label);

  /// Human-readable name for UI and mock responses.
  final String label;
}
