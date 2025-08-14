class MedicineEntity {
  MedicineEntity({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.dosageForm, // Keep this for backward compatibility
    required this.requiresPrescription,
    required this.barcode,
    this.designation,
    this.dosage,
    this.form,
  });

  final String id;
  final String name;
  final String manufacturer;
  final String dosageForm; // This will be populated from 'form' field
  final bool requiresPrescription;
  final String barcode;

  // New fields from updated API
  final String? designation;
  final String? dosage;
  final String? form;

  // Helper getter for display purposes
  String get displayName {
    if (designation != null && designation!.isNotEmpty) {
      return designation!;
    }
    return name;
  }

  // Helper getter for full dosage info
  String get fullDosageInfo {
    final parts = <String>[];
    if (dosage != null && dosage!.isNotEmpty) {
      parts.add(dosage!);
    }
    if (form != null && form!.isNotEmpty) {
      parts.add(form!);
    } else if (dosageForm.isNotEmpty) {
      parts.add(dosageForm);
    }
    return parts.join(' - ');
  }
}