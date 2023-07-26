import 'package:hitchride/src/features/account/data/model/user.dart';

abstract class UserState {}

class UserLoading extends UserState {}

class UserData extends UserState {
  final HitchRideUser user;

  UserData(this.user);
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}