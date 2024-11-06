import 'package:equatable/equatable.dart';

abstract class RecoveryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RecoveryRequested extends RecoveryEvent {
  final String username;
  final String password;
  final String recoveryCode;

  RecoveryRequested({required this.username, required this.password, required this.recoveryCode});

  @override
  List<Object> get props => [username, password, recoveryCode];
}
