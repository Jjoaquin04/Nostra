import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nostra/core/usecases/usecase.dart';
import 'package:nostra/featured/domain/usecases/check_notifications_option.dart';
import 'package:nostra/featured/domain/usecases/disabled_notifications.dart';
import 'package:nostra/featured/domain/usecases/enabled_notifications.dart';
import 'package:nostra/featured/presentation/bloc/notifications_event.dart';
import 'package:nostra/featured/presentation/bloc/notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final EnabledNotifications enabledNotifications;
  final DisabledNotifications disabledNotifications;
  final CheckNotificationsOption checkNotificationsOption;

  NotificationsBloc({
    required this.enabledNotifications,
    required this.disabledNotifications,
    required this.checkNotificationsOption,
  }) : super(const NotificationsState()) {
    on<EnabledNotificationsEvent>(_onEnabledNotification);
    on<DisabledNotificationsEvent>(_onDisabledNotification);
    on<CheckNotificationsEvent>(_onCheckNotification);
  }

  Future<void> _onEnabledNotification(EnabledNotificationsEvent event, Emitter<NotificationsState> emit) async {
    emit(const NotificationsState(status: NotificationStatus.loading));
    final result = await enabledNotifications(const NoParams());
    result.fold(
      (failure) => emit(const NotificationsState(status: NotificationStatus.failure)),
      (_) => emit(const NotificationsState(status: NotificationStatus.enabled)),
    );
  }
  
  Future<void> _onDisabledNotification(DisabledNotificationsEvent event, Emitter<NotificationsState> emit) async {
    emit(const NotificationsState(status: NotificationStatus.loading));
    final result = await disabledNotifications(const NoParams());
    result.fold(
      (failure) => emit(const NotificationsState(status: NotificationStatus.failure)),
      (_) => emit(const NotificationsState(status: NotificationStatus.disabled)),
    );
  }
  
  Future<void> _onCheckNotification(CheckNotificationsEvent event, Emitter<NotificationsState> emit) async {
    emit(const NotificationsState(status: NotificationStatus.loading));
    final result = await checkNotificationsOption(const NoParams());
    result.fold(
      (failure) => emit(const NotificationsState(status: NotificationStatus.failure)),
      (isEnabled) => emit(NotificationsState(
        status: isEnabled ? NotificationStatus.enabled : NotificationStatus.disabled,
      )),
    );
  }
}
