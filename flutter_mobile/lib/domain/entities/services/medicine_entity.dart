class MedicineEntity {
  MedicineEntity({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.dosageForm,
    required this.requiresPrescription,
    required this.barcode,
  });

  final String id;
  final String name;
  final String manufacturer;
  final String dosageForm;
  final bool requiresPrescription;
  final String barcode;
}