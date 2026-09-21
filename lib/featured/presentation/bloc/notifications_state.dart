import 'package:equatable/equatable.dart';

enum NotificationStatus { loading, enabled, disabled, failure }

class NotificationsState extends Equatable {
  final NotificationStatus status;

  const NotificationsState({this.status = NotificationStatus.disabled});

  @override
  List<Object?> get props => [status];
}
