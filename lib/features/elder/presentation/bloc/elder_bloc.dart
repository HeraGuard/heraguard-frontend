import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heraguard_frontend/features/elder/domain/entities/elder.dart';
import 'package:heraguard_frontend/features/elder/domain/usecases/get_elders_by_user_usecase.dart';
import 'package:heraguard_frontend/features/elder/domain/usecases/link_elder_usecase.dart';

part 'elder_event.dart';
part 'elder_state.dart';

class ElderBloc extends Bloc<ElderEvent, ElderState> {
  final GetEldersByUserUsecase getEldersByUser;
  final LinkElderUsecase linkElder;

  ElderBloc({required this.getEldersByUser, required this.linkElder})
    : super(ElderInitial()) {
    on<LoadEldersByUser>(_onLoadEldersByUser);
    on<LinkElder>(_onLinkElder);
  }

  Future<void> _onLoadEldersByUser(
    LoadEldersByUser event,
    Emitter<ElderState> emit,
  ) async {
    emit(ElderLoading());
    try {
      final elders = await getEldersByUser(event.userId, event.userType);
      emit(ElderLoaded(elders: elders));
    } catch (e) {
      emit(ElderError(message: e.toString()));
    }
  }

  Future<void> _onLinkElder(LinkElder event, Emitter<ElderState> emit) async {
    emit(ElderLoading());
    try {
      await linkElder(event.linkingCode);
      emit(ElderLinkSuccess());
    } catch (e) {
      emit(ElderError(message: e.toString()));
    }
  }
}
