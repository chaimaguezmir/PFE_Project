class MedicineEntity {
  MedicineEntity({
    required this.id,
    required this.medicationName,
    required this.dosage,
    required this.form,
    required this.presentation,
    required this.dci,
    required this.therapeuticClass,
    required this.subClass,
    required this.laboratory,
    required this.ammNumber,
    required this.ammDate,
    required this.primaryPackaging,
    required this.packagingSpecification,
    required this.scheduleCategory,
    required this.shelfLife,
    required this.indications,
    required this.medicationType,
    required this.veicClassification,
    required this.barcode,
    required this.requiresPrescription,
  });

  final String id;
  final String medicationName; // nom_medicament
  final String dosage; // dosage
  final String form; // forme
  final String presentation; // presentation
  final String dci; // dci
  final String therapeuticClass; // classe_therapeutique
  final String subClass; // sous_classe
  final String laboratory; // laboratoire
  final String ammNumber; // numero_amm
  final String ammDate; // date_amm
  final String primaryPackaging; // conditionnement_primaire
  final String packagingSpecification; // specification_conditionnement
  final String scheduleCategory; // categorie_tableau
  final String shelfLife; // duree_conservation
  final String indications; // indications
  final String medicationType; // type_medicament
  final String veicClassification; // classification_veic
  final String barcode; // code_barre
  final bool requiresPrescription;

  // Helper getters for backward compatibility and display
  String get name => medicationName;
  String get manufacturer => laboratory;
  String get dosageForm => form;
  String get displayName => medicationName;

  // Helper getter for detailed info display
  String get fullMedicationInfo {
    final parts = <String>[];
    if (dosage.isNotEmpty) parts.add(dosage);
    if (form.isNotEmpty) parts.add(form);
    if (presentation.isNotEmpty) parts.add(presentation);
    return parts.join(' - ');
  }

  // Helper getter for therapeutic info
  String get therapeuticInfo {
    final parts = <String>[];
    if (therapeuticClass.isNotEmpty) parts.add(therapeuticClass);
    if (subClass.isNotEmpty) parts.add(subClass);
    return parts.join(' > ');
  }
}