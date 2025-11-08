part of 'elder_bloc.dart';

sealed class ElderEvent {}

class LoadEldersByUser extends ElderEvent {
  final String userId;
  final int userType;

  LoadEldersByUser(this.userId, this.userType);
}

class LinkElder extends ElderEvent {
  final String linkingCode;

  LinkElder(this.linkingCode);
}
