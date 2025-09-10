class CreatePrescriptionRequestModel {
  const CreatePrescriptionRequestModel({
    required this.name,
    required this.diseaseIds,
  });

  final String name;
  final List<String> diseaseIds;

  Map<String, dynamic> toJson() => {
    'name': name,
    'diseaseIds': diseaseIds,
  };

  factory CreatePrescriptionRequestModel.fromJson(Map<String, dynamic> json) {
    return CreatePrescriptionRequestModel(
      name: json['name'] as String,
      diseaseIds: (json['diseaseIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }
}