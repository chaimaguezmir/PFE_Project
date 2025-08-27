class AddCustomMyMedicineRequestModel {
  AddCustomMyMedicineRequestModel({
    required this.pharmacyBoxId,
    required this.name,
    required this.form,
  });

  final String pharmacyBoxId;
  final String name;
  final String form;

  Map<String, dynamic> toJson() => {
    'pharmacyBoxId': pharmacyBoxId,
    'name': name,
    'form': form,
  };
}