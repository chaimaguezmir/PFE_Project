// Medicine data model
class Medicine {
  const Medicine({
    required this.name,
    required this.description,
    required this.type,
    required this.iconPath,
  });

  final String name;
  final String description;
  final String type;
  final String iconPath;
}