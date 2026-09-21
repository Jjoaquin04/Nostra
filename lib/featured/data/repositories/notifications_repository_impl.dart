import 'package:dartz/dartz.dart';
import 'package:nostra/core/errors/exception.dart';
import 'package:nostra/core/errors/failure.dart';
import 'package:nostra/core/utils/user_config.dart';
import 'package:nostra/featured/domain/repository/notifications_repository.dart';
import 'package:nostra/featured/presentation/bloc/notifications_state.dart';
import 'package:nostra/featured/data/datasources/notification_local_service.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationLocalService notificationLocalService;

  NotificationsRepositoryImpl({required this.notificationLocalService});

  @override
  Future<Either<Failure, bool>> checkNotificationsOptions() async {
    try {
      final notiOption = await UserConfig.checkNotificationsOption();
      if (notiOption == NotificationStatus.enabled.name) {
        return Right(true);
      } else {
        return Right(false);
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> disabledNotifications() async {
    try {
      await UserConfig.updateNotificationsOption(
        NotificationStatus.disabled.name,
      );
      await notificationLocalService.cancelAllNotifications();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> enabledNotifications() async {
    try {
      await notificationLocalService.requestPermissions();
      await UserConfig.updateNotificationsOption(
        NotificationStatus.enabled.name,
      );

      await notificationLocalService.showInstantNotifications(
        0,
        'Notificaciones activadas',
        'Acabas de activar las notificaciones mensuales',
      );

      await notificationLocalService.scheduleReminder(
        1,
        'Revisa tus gastos',
        '¡Ya es fin de mes! No olvides añadir tus gastos fijos.',
      );

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
