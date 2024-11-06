import 'package:equatable/equatable.dart';

sealed class RecoveryState extends Equatable {
  @override
  List<Object> get props => [];
}

class RecoveryInitial extends RecoveryState {}

class RecoveryLoading extends RecoveryState {}

class RecoverySuccess extends RecoveryState {
  final String totpCode;

  RecoverySuccess({required this.totpCode});

  @override
  List<Object> get props => [totpCode];
}

class RecoveryFailure extends RecoveryState {
  final String error;

  RecoveryFailure(this.error);
  @override
  List<Object> get props => [error];
}
