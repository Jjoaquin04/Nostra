import 'package:get_it/get_it.dart';
import 'package:nostra/core/localization/locale_cubit.dart';
import 'package:nostra/featured/data/datasources/expense_local_datasource.dart';
import 'package:nostra/featured/data/datasources/expense_local_datasource_impl.dart';
import 'package:nostra/featured/data/repositories/expense_repository_impl.dart';
import 'package:nostra/featured/data/repositories/notifications_repository_impl.dart';
import 'package:nostra/featured/data/datasources/notification_local_service.dart';
import 'package:nostra/featured/data/datasources/notifications_local_service_impl.dart';
import 'package:nostra/featured/domain/repository/expense_repository.dart';
import 'package:nostra/featured/domain/usecases/add_expense.dart';
import 'package:nostra/featured/domain/usecases/delete_expense.dart';
import 'package:nostra/featured/domain/usecases/get_expenses.dart';
import 'package:nostra/featured/domain/usecases/update_expense.dart';
import 'package:nostra/featured/domain/usecases/get_expenses_by_month.dart';
import 'package:nostra/featured/domain/repository/notifications_repository.dart';
import 'package:nostra/featured/domain/usecases/check_notifications_option.dart';
import 'package:nostra/featured/domain/usecases/disabled_notifications.dart';
import 'package:nostra/featured/domain/usecases/enabled_notifications.dart';
import 'package:nostra/featured/presentation/bloc/bloc.dart';
import 'package:nostra/featured/presentation/bloc/notifications_bloc.dart';

final getIt = GetIt.instance;

void setUpDependencyInjection() {
  getIt.registerLazySingleton<ExpenseLocalDataSource>(
    () => ExpenseLocalDatasourceImpl(),
  );

  getIt.registerLazySingleton<ExpenseRepository>(
    () =>
        ExpenseRepositoryImpl(localDataSource: getIt<ExpenseLocalDataSource>()),
  );

  getIt.registerLazySingleton(() => GetExpenses(getIt<ExpenseRepository>()));

  getIt.registerLazySingleton(() => AddExpense(getIt<ExpenseRepository>()));

  getIt.registerLazySingleton(() => DeleteExpense(getIt<ExpenseRepository>()));

  getIt.registerLazySingleton(() => UpdateExpense(getIt<ExpenseRepository>()));

  getIt.registerLazySingleton(
    () => GetExpensesByMonth(getIt<ExpenseRepository>()),
  );

  getIt.registerFactory<ExpenseBloc>(
    () => ExpenseBloc(
      getExpensesUseCase: getIt(),
      addExpenseUseCase: getIt(),
      updateExpenseUseCase: getIt(),
      deleteExpenseUseCase: getIt(),
      getExpensesByMonthUseCase: getIt(),
    ),
  );
  // Locale Cubit (singleton for app-wide language state)
  getIt.registerLazySingleton<LocaleCubit>(() => LocaleCubit());

  getIt.registerLazySingleton(
    () => CheckNotificationsOption(getIt<NotificationsRepository>()),
  );
  getIt.registerLazySingleton(
    () => EnabledNotifications(getIt<NotificationsRepository>()),
  );
  getIt.registerLazySingleton(
    () => DisabledNotifications(getIt<NotificationsRepository>()),
  );

  getIt.registerLazySingleton<NotificationLocalService>(
    () => NotificationsLocalServiceImpl(),
  );

  getIt.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(
      notificationLocalService: getIt<NotificationLocalService>(),
    ),
  );
  getIt.registerFactory<NotificationsBloc>(
    () => NotificationsBloc(
      enabledNotifications: getIt(),
      disabledNotifications: getIt(),
      checkNotificationsOption: getIt(),
    ),
  );
}
