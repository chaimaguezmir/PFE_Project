import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_mobile/core/resources/data_state.dart';
import 'package:flutter_mobile/domain/entities/services/PharmacyBoxEntity.dart';
import 'package:flutter_mobile/domain/repositories/pharmacy_repository.dart';
import 'package:formz/formz.dart';

part 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  ServicesCubit(this._pharmacyRepository) : super(const ServicesState());

  final PharmacyRepository _pharmacyRepository;

  void updateSearchText(String text) {
    emit(state.copyWith(searchQuery: text));
    searchBoxes(text, state.allBoxes);
  }

  void searchBoxes(String query, List<PharmacyBoxEntity> allBoxes) {
    if (query.isEmpty) {
      emit(state.copyWith(filteredBoxes: allBoxes, searchQuery: query));
      return;
    }

    final filteredBoxes = allBoxes
        .where((box) => box.groupName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    emit(state.copyWith(filteredBoxes: filteredBoxes, searchQuery: query));
  }

  void resetSearch(List<PharmacyBoxEntity> allBoxes) {
    emit(state.copyWith(filteredBoxes: allBoxes, searchQuery: ''));
  }

  void clearSearch() {
    emit(state.copyWith(filteredBoxes: state.allBoxes, searchQuery: ''));
  }

  void initializeBoxes(List<PharmacyBoxEntity> boxes) {
    emit(state.copyWith(filteredBoxes: boxes, allBoxes: boxes));
  }

  Future<void> fetchPharmacyBoxes() async {
    emit(state.copyWith(
      status: FormzSubmissionStatus.inProgress,
      errorMessage: null,
    ));

    final result = await _pharmacyRepository.getMyPharmacyBoxes();

    if (result is DataSuccess<List<PharmacyBoxEntity>>) {
      final boxes = result.data ?? [];
      emit(state.copyWith(
        allBoxes: boxes,
        filteredBoxes: boxes,
        status: FormzSubmissionStatus.success,
        errorMessage: null,
      ));
    } else {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: result.error ?? 'Failed to fetch pharmacy boxes',
      ));
    }
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }
}