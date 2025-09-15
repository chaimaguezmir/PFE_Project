// lib/data/data_sources/disease_remote_datasource.dart
import 'package:flutter_mobile/data/model/prescription/disease_model.dart';

abstract class DiseaseRemoteDataSource {
  Future<List<DiseaseModel>> getDiseases();
}