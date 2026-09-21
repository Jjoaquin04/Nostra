import 'package:equatable/equatable.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class EnabledNotificationsEvent extends NotificationsEvent {}

class DisabledNotificationsEvent extends NotificationsEvent {}

class CheckNotificationsEvent extends NotificationsEvent {}
