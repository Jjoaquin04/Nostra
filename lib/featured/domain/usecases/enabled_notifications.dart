import 'package:dartz/dartz.dart';
import 'package:nostra/core/errors/failure.dart';
import 'package:nostra/core/usecases/usecase.dart';
import 'package:nostra/featured/domain/repository/notifications_repository.dart';

class EnabledNotifications extends Usecase<void, NoParams> {
  final NotificationsRepository repository;

  EnabledNotifications(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.enabledNotifications();
  }
}
