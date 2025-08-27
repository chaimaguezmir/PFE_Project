class DiseaseEntity {
  const DiseaseEntity({
    required this.id,
    required this.name,
    required this.prescriptionCount,
  });

  final String id;
  final String name;
  final int prescriptionCount;
}