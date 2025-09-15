class CreatePrescriptionEntity {
  const CreatePrescriptionEntity({
    required this.name,
    required this.diseaseIds,
  });

  final String name;
  final List<String> diseaseIds;

  // Validation methods
  bool get isValid => name.trim().isNotEmpty && diseaseIds.isNotEmpty;

  bool get hasMultipleDiseases => diseaseIds.length > 1;

  String get diseaseIdsString => diseaseIds.join(', ');

  // Helper method to create a copy with updated values
  CreatePrescriptionEntity copyWith({
    String? name,
    List<String>? diseaseIds,
  }) {
    return CreatePrescriptionEntity(
      name: name ?? this.name,
      diseaseIds: diseaseIds ?? this.diseaseIds,
    );
  }
}