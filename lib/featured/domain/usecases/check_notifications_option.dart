import 'package:dartz/dartz.dart';
import 'package:nostra/core/errors/failure.dart';
import 'package:nostra/core/usecases/usecase.dart';
import 'package:nostra/featured/domain/repository/notifications_repository.dart';

class CheckNotificationsOption extends Usecase<bool, NoParams> {
  final NotificationsRepository repository;

  CheckNotificationsOption(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.checkNotificationsOptions();
  }
}
