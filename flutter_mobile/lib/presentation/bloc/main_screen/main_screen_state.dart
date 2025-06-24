part of 'main_screen_cubit.dart';

class MainScreenState extends Equatable {
  const MainScreenState({this.selectedIndex = 0});

  final int selectedIndex;

  MainScreenState copyWith({int? selectedIndex}) {
    return MainScreenState(selectedIndex: selectedIndex ?? this.selectedIndex);
  }

  @override
  List<Object> get props => [selectedIndex];
}
