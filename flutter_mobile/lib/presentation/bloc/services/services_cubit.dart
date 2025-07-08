import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

part 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  ServicesCubit() : super(const ServicesState());

  //resetSearch
  void resetSearch(List<BoxData> allBoxes) {
    emit(state.copyWith(filteredBoxes: allBoxes, searchQuery: ''));
  }

  void searchBoxes(String query, List<BoxData> allBoxes) {
    if (query.isEmpty) {
      emit(state.copyWith(filteredBoxes: allBoxes, searchQuery: ''));
      return;
    }

    final filteredBoxes = allBoxes
        .where((box) => box.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    emit(state.copyWith(filteredBoxes: filteredBoxes, searchQuery: query));
  }

  void initializeBoxes(List<BoxData> boxes) {
    emit(state.copyWith(filteredBoxes: boxes));
  }
}

// BoxData class (add this to your cubit file or import from services screen)
class BoxData extends Equatable {
  const BoxData({required this.title, required this.count});
  final String title;
  final String count;

  @override
  List<Object> get props => [title, count];
}
