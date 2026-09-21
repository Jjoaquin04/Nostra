import 'package:dartz/dartz.dart';
import 'package:nostra/core/errors/failure.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, void>> enabledNotifications();
  Future<Either<Failure, void>> disabledNotifications();
  Future<Either<Failure, bool>> checkNotificationsOptions();
}
