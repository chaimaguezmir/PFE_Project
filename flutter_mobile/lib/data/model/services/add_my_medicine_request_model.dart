class AddMyMedicineRequestModel {
  AddMyMedicineRequestModel({
    required this.pharmacyBoxId,
    required this.medicineId,
    required this.name,
    required this.form,
  });

  final String pharmacyBoxId;
  final String medicineId;
  final String name;
  final String form;

  Map<String, dynamic> toJson() => {
    'pharmacyBoxId': pharmacyBoxId,
    'medicineId': medicineId,
    'name': name,
    'form': form,
  };
}