import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../domain/usecases/search_users_usecase.dart';
import 'user_search_event.dart';
import 'user_search_state.dart';

// Función helper reutilizable
EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) {
    return events.debounceTime(duration).switchMap(mapper);
  };
}

class UserSearchBloc extends Bloc<UserSearchEvent, UserSearchState> {
  final SearchUsersUseCase searchUsersUseCase;

  UserSearchBloc({required this.searchUsersUseCase})
    : super(UserSearchInitial()) {
    on<SearchUsersEvent>(
      _onSearchUsers,
      transformer: debounce(const Duration(milliseconds: 400)),
    );
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onSearchUsers(
    SearchUsersEvent event,
    Emitter<UserSearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(UserSearchInitial());
      return;
    }

    emit(UserSearchLoading());

    try {
      final users = await searchUsersUseCase(
        query: event.query,
        roleId: event.roleId,
      );

      if (users.isEmpty) {
        emit(UserSearchEmpty());
      } else {
        emit(UserSearchLoaded(users));
      }
    } catch (e) {
      emit(UserSearchError(e.toString()));
    }
  }

  void _onClearSearch(ClearSearchEvent event, Emitter<UserSearchState> emit) {
    emit(UserSearchInitial());
  }
}
