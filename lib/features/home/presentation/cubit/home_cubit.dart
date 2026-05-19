import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  // Example functionality
  Future<void> fetchHomeData() async {
    emit(HomeLoading());
    try {
      // Fetch data here
      // Replace with use case execution
      emit(const HomeLoaded());
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}
