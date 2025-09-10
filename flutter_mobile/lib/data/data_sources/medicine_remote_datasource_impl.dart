import 'package:dio/dio.dart';
import 'package:flutter_mobile/core/constants/api_endpoint.dart';
import 'package:flutter_mobile/data/data_sources/medicine_remote_datasource.dart';
import 'package:flutter_mobile/data/model/services/add_custom_my_medicine_request_model.dart';
import 'package:flutter_mobile/data/model/services/add_my_medicine_request_model.dart';
import 'package:flutter_mobile/data/model/services/add_purchase_history_request_model.dart';
import 'package:flutter_mobile/data/model/services/medicine_model.dart';
import 'package:flutter_mobile/data/model/services/my_medicine_model.dart';
import 'package:flutter_mobile/data/model/services/purchase_history_response_model.dart';

class MedicineRemoteDataSourceImpl implements MedicineRemoteDataSource {
  MedicineRemoteDataSourceImpl(this._dio);
  final Dio _dio;

  String _getMedicinesForBoxEndpoint(String pharmacyBoxId) =>
      '${ApiEndpoints.myMedicines}/pharmacy-box/$pharmacyBoxId';

  String _checkMyMedicineEndpoint(String pharmacyBoxId, String medicineId) =>
      '${ApiEndpoints.myMedicines}/pharmacy-box/$pharmacyBoxId/medicine/$medicineId';

  String _getMedicineByBarcodeEndpoint(String barcode) =>
      '${ApiEndpoints.medicines}/barcode/$barcode';

  @override
  Future<List<MyMedicineModel>> getMyMedicines(String pharmacyBoxId) async {
    try {
      print('Fetching medicines for pharmacy box: $pharmacyBoxId');
      final response = await _dio.get(
        _getMedicinesForBoxEndpoint(pharmacyBoxId),
      );

      if (response.statusCode == 200) {
        final data = response.data as List;
        print('Successfully fetched ${data.length} medicines');
        return data.map((json) => MyMedicineModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch medicines: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in getMyMedicines: ${e.message}');
      print('Status code: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('Unexpected error in getMyMedicines: $e');
      throw DioException(
        requestOptions: RequestOptions(
          path: _getMedicinesForBoxEndpoint(pharmacyBoxId),
        ),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<MedicineModel> getMedicineByBarcode(String barcode) async {
    try {
      print('Fetching medicine by barcode: $barcode');
      final response = await _dio.get(
        _getMedicineByBarcodeEndpoint(barcode),
      );

      if (response.statusCode == 200) {
        print('Successfully found medicine for barcode: $barcode');
        return MedicineModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch medicine: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in getMedicineByBarcode: ${e.message}');
      print('Status code: ${e.response?.statusCode}');
      rethrow;
    } catch (e) {
      print('Unexpected error in getMedicineByBarcode: $e');
      throw DioException(
        requestOptions: RequestOptions(
          path: _getMedicineByBarcodeEndpoint(barcode),
        ),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<MyMedicineModel?> checkMyMedicine(String pharmacyBoxId, String medicineId) async {
    try {
      print('Checking if medicine exists - PharmacyBox: $pharmacyBoxId, Medicine: $medicineId');
      final response = await _dio.get(
        _checkMyMedicineEndpoint(pharmacyBoxId, medicineId),
      );

      if (response.statusCode == 200) {
        print('Medicine already exists in pharmacy box');
        return MyMedicineModel.fromJson(response.data);
      } else {
        print('Medicine does not exist in pharmacy box');
        return null;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        print('Medicine not found in pharmacy box (404)');
        return null;
      }
      print('DioException in checkMyMedicine: ${e.message}');
      print('Status code: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('Unexpected error in checkMyMedicine: $e');
      throw DioException(
        requestOptions: RequestOptions(
          path: _checkMyMedicineEndpoint(pharmacyBoxId, medicineId),
        ),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<MyMedicineModel> addMyMedicine(AddMyMedicineRequestModel request) async {
    try {
      print('Adding new medicine to pharmacy box');
      print('Request data: ${request.toJson()}');

      final response = await _dio.post(
        ApiEndpoints.myMedicines,
        data: request.toJson(),
      );

      print('AddMyMedicine response status: ${response.statusCode}');
      print('AddMyMedicine response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Successfully added medicine to pharmacy box');
        return MyMedicineModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to add medicine: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in addMyMedicine: ${e.message}');
      print('Status code: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      print('Request data: ${e.requestOptions.data}');
      rethrow;
    } catch (e) {
      print('Unexpected error in addMyMedicine: $e');
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.myMedicines),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<PurchaseHistoryResponseModel> addPurchaseHistory(AddPurchaseHistoryRequestModel request) async {
    try {
      print('Adding purchase history');
      print('Purchase history request data: ${request.toJson()}');
      print('API Endpoint: ${ApiEndpoints.purchaseHistory}');

      final response = await _dio.post(
        ApiEndpoints.purchaseHistory,
        data: request.toJson(),
      );

      print('Purchase history response status: ${response.statusCode}');
      print('Purchase history response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Successfully added purchase history');

        if (response.data == null) {
          throw Exception('Response data is null');
        }

        return PurchaseHistoryResponseModel.fromJson(response.data);
      } else {
        print('Failed to add purchase history - Status: ${response.statusCode}');
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to add purchase history: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in addPurchaseHistory: ${e.message}');
      print('Status code: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      print('Request data: ${e.requestOptions.data}');
      rethrow;
    } catch (e) {
      print('Unexpected error in addPurchaseHistory: $e');
      print('Stack trace: ${StackTrace.current}');
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.purchaseHistory),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<List<MedicineModel>> getAllMedicines() async {
    try {
      print('Fetching all medicines from API');
      final response = await _dio.get(ApiEndpoints.medicines);

      if (response.statusCode == 200) {
        final data = response.data as List;
        print('Successfully fetched ${data.length} medicines');
        return data.map((json) => MedicineModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch medicines: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in getAllMedicines: ${e.message}');
      print('Status code: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('Unexpected error in getAllMedicines: $e');
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.medicines),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<MyMedicineModel> addCustomMyMedicine(AddCustomMyMedicineRequestModel request) async {
    try {
      print('Adding custom medicine to pharmacy box');
      print('Request data: ${request.toJson()}');

      final response = await _dio.post(
        '${ApiEndpoints.myMedicines}/custom',
        data: request.toJson(),
      );

      print('AddCustomMyMedicine response status: ${response.statusCode}');
      print('AddCustomMyMedicine response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Successfully added custom medicine to pharmacy box');
        return MyMedicineModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to add custom medicine: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in addCustomMyMedicine: ${e.message}');
      print('Status code: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      print('Request data: ${e.requestOptions.data}');
      rethrow;
    } catch (e) {
      print('Unexpected error in addCustomMyMedicine: $e');
      throw DioException(
        requestOptions: RequestOptions(path: '${ApiEndpoints.myMedicines}/custom'),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<List<MedicineModel>> searchMedicinesByName(String query) async {
    try {
      print('🌐 API: Searching medicines by name: "$query"');
      print('🌐 API: Endpoint: ${ApiEndpoints.searchMedicines}');
      print('🌐 API: Query params: {q: $query}');

      final response = await _dio.get(
        ApiEndpoints.searchMedicines,
        queryParameters: {'q': query},
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      print('🌐 API: Response status: ${response.statusCode}');
      print('🌐 API: Response data type: ${response.data.runtimeType}');

      if (response.statusCode == 200) {
        if (response.data == null) {
          print('🌐 API: Response data is null');
          return [];
        }

        if (response.data is! List) {
          print('🌐 API: Response data is not a List: ${response.data}');
          throw Exception('API returned unexpected data format: ${response.data.runtimeType}');
        }

        final data = response.data as List;
        print('🌐 API: Successfully found ${data.length} medicines for query: "$query"');

        // Log first few items for debugging
        for (int i = 0; i < data.length && i < 2; i++) {
          print('🌐 API: Item $i: ${data[i]['medicationName']} - ${data[i]['laboratory']}');
        }

        try {
          final medicines = data.map((json) {
            try {
              print('🔧 Parsing medicine: ${json['medicationName']}');

              // Validate required fields before parsing
              if (json['id'] == null) {
                print('🔧 Warning: Medicine has null ID, skipping');
                return null;
              }
              if (json['medicationName'] == null) {
                print('🔧 Warning: Medicine has null medicationName, skipping');
                return null;
              }
              if (json['laboratory'] == null) {
                print('🔧 Warning: Medicine has null laboratory, skipping');
                return null;
              }

              final medicine = MedicineModel.fromJson(json);
              print('🔧 Successfully parsed: ${medicine.medicationName} (barcode: "${medicine.barcode}")');
              return medicine;
            } catch (e) {
              print('🔧 Error parsing individual medicine: ${json['medicationName']}');
              print('🔧 Parse error: $e');
              // Skip this medicine and continue with others
              return null;
            }
          }).where((medicine) => medicine != null).cast<MedicineModel>().toList();

          print('🔧 Successfully parsed ${medicines.length} out of ${data.length} medicines');
          return medicines;
        } catch (e) {
          print('🔧 Error during medicines parsing: $e');
          throw Exception('Error parsing medicines data: $e');
        }
      } else {
        print('🌐 API: Bad response status: ${response.statusCode}');
        print('🌐 API: Response message: ${response.statusMessage}');
        print('🌐 API: Response data: ${response.data}');

        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to search medicines: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('🌐 API: DioException in searchMedicinesByName: ${e.message}');
      print('🌐 API: Error type: ${e.type}');
      print('🌐 API: Status code: ${e.response?.statusCode}');
      print('🌐 API: Response data: ${e.response?.data}');

      // Provide more specific error messages
      String userMessage;
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          userMessage = 'Délai de connexion dépassé. Vérifiez votre connexion internet.';
          break;
        case DioExceptionType.connectionError:
          userMessage = 'Erreur de connexion. Vérifiez votre connexion internet.';
          break;
        case DioExceptionType.badResponse:
          if (e.response?.statusCode == 404) {
            userMessage = 'Service de recherche non disponible.';
          } else if (e.response?.statusCode == 500) {
            userMessage = 'Erreur du serveur. Veuillez réessayer plus tard.';
          } else {
            userMessage = 'Erreur de recherche: ${e.response?.statusCode}';
          }
          break;
        default:
          userMessage = 'Erreur de recherche: ${e.message}';
      }

      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: userMessage,
        type: e.type,
      );
    } catch (e) {
      print('🌐 API: Unexpected error in searchMedicinesByName: $e');
      print('🌐 API: Error type: ${e.runtimeType}');
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.searchMedicines),
        message: 'Erreur inattendue lors de la recherche: $e',
      );
    }
  }

  @override
  Future<void> removeBarcode({
    required String medicineId,
    required String barcode,
  }) async {
    try {
      print('Removing barcode $barcode from medicine $medicineId');
      final response = await _dio.delete(
        '${ApiEndpoints.medicines}/$medicineId/barcode',
        data: {'barcode': barcode},
      );

      print('Remove barcode response status: ${response.statusCode}');
      print('Remove barcode response data: ${response.data}');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to remove barcode: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in removeBarcode: ${e.message}');
      print('Status code: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('Unexpected error in removeBarcode: $e');
      throw DioException(
        requestOptions: RequestOptions(path: '${ApiEndpoints.medicines}/$medicineId/barcode'),
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  @override
  Future<void> assignBarcode({
    required String medicineId,
    required String barcode,
  }) async {
    try {
      print('Assigning barcode $barcode to medicine $medicineId');
      final response = await _dio.put(
        '${ApiEndpoints.medicines}/$medicineId/barcode',
        data: {'barcode': barcode},
      );

      print('Assign barcode response status: ${response.statusCode}');
      print('Assign barcode response data: ${response.data}');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to assign barcode: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      print('DioException in assignBarcode: ${e.message}');
      print('Status code: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('Unexpected error in assignBarcode: $e');
      throw DioException(
        requestOptions: RequestOptions(path: '${ApiEndpoints.medicines}/$medicineId/barcode'),
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}