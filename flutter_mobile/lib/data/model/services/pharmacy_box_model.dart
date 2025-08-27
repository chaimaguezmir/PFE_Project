
import 'package:flutter_mobile/domain/entities/services/PharmacyBoxEntity.dart';

class PharmacyBoxModel extends PharmacyBoxEntity {
  PharmacyBoxModel({
    required super.id,
    required super.groupName,
    required super.medicationCount,
  });

  factory PharmacyBoxModel.fromJson(Map<String, dynamic> json) {
    return PharmacyBoxModel(
      id: json['id'] as String,
      groupName: json['groupName'] as String,
      medicationCount: json['medicationCount'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'groupName': groupName,
    'medicationCount': medicationCount,
  };
}