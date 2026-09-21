import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:home_widget/home_widget.dart';
import 'package:nostra/core/constant/hive_constants.dart';
import 'package:nostra/core/dependency_injection/dependecy_injection.dart';
import 'package:nostra/core/localization/locale_cubit.dart';
import 'package:nostra/core/utils/user_config.dart';
import 'package:nostra/featured/data/expense_model.dart';
import 'package:nostra/featured/data/expense_change_history.dart';
import 'package:nostra/featured/presentation/bloc/expense_bloc.dart';
import 'package:nostra/featured/presentation/bloc/notifications_bloc.dart';
import 'package:nostra/featured/presentation/pages/expenses_screen.dart';
import 'package:nostra/featured/presentation/pages/welcome_screen.dart';
import 'package:nostra/featured/data/datasources/notification_local_service.dart';
import 'package:nostra/l10n/app_localizations.dart';

const String mainIsolatePortName = "main_isolate_port";
// Callback de fondo para HomeWidget
@pragma('vm:entry-point')
void backgroundCallback(Uri? uri) async {
  if (uri?.host == 'update') {
    try {
      final dataString = await HomeWidget.getWidgetData<String>('expense_data');
      if (dataString == null) {
        return;
      }

      final SendPort? mainIsolatePort = IsolateNameServer.lookupPortByName(
        mainIsolatePortName,
      );
      if (mainIsolatePort != null) {
        mainIsolatePort.send(dataString);
      } else {
        WidgetsFlutterBinding.ensureInitialized();
        await Hive.initFlutter();
        if (!Hive.isAdapterRegistered(ExpenseModelAdapter().typeId)) {
          Hive.registerAdapter(ExpenseModelAdapter());
          Hive.registerAdapter(ExpenseChangeHistoryAdapter());
          Hive.registerAdapter(ChangeTypeAdapter());
        }

        final expenseBox = await Hive.openBox<ExpenseModel>(
          HiveConstants.expenseBox,
        );
        final userConfigBox = await Hive.openBox('user_config');

        final data = jsonDecode(dataString) as Map<String, dynamic>;
        final amountStr = data['amount'] as String?;
        final amount = amountStr != null ? double.tryParse(amountStr) : null;
        final dateStr = data['date'] as String?;
        final date = (dateStr != null) ? DateTime.tryParse(dateStr) : null;
        final typeStr = data['type'] as String?;
        final fixedExpense = data['fixedExpense'] as int?;

        if (amount == null || date == null || typeStr == null) {
          return;
        }

        final expenseOwner = userConfigBox.get(
          'user_name',
          defaultValue: 'Usuario',
        );

        final model = ExpenseModel(
          expenseOwner: expenseOwner,
          expenseName: data['name'] as String? ?? '',
          amount: amount,
          category: data['category'] as String? ?? 'Otros',
          date: date,
          type: typeStr == "expense" ? 0 : 1,
          fixedExpense: fixedExpense ?? 0,
        );

        await expenseBox.add(model);

        await expenseBox.close();

        await UserConfig.updateInitialBalance(
          await UserConfig.getInitialBalance() +
              (typeStr == "income" ? amount : -amount),
        );
        await userConfigBox.close();

        await HomeWidget.saveWidgetData<String>('expense_data', null);
      }
    } catch (e) {
      return;
    }
  }
}

void main() async {
  // 1. Inicialización estándar
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // 2. Registrar el callback de HomeWidget (MODIFICADO)
  HomeWidget.registerInteractivityCallback(backgroundCallback);

  // 3. Inicialización de Hive para la app principal
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseModelAdapter());
  Hive.registerAdapter(ExpenseChangeHistoryAdapter());
  Hive.registerAdapter(ChangeTypeAdapter());
  await Hive.openBox<ExpenseModel>(HiveConstants.expenseBox);
  await Hive.openBox('user_config');

  // 4. Inyección de dependencias y ejecutar la app
  setUpDependencyInjection();

  // 5. Inicializar notificaciones locales
  await getIt<NotificationLocalService>().init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt.get<ExpenseBloc>()),
        BlocProvider(create: (_) => getIt.get<LocaleCubit>()),
        BlocProvider(create: (_) => getIt.get<NotificationsBloc>()),
      ],
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, localeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            // Localization configuration
            locale: localeState.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('es'), // Spanish
            ],
            home: FutureBuilder<bool>(
              future: UserConfig.isUserConfigured(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.data == true) {
                  return const ExpensesScreen();
                }
                return const WelcomeScreen();
              },
            ),
          );
        },
      ),
    );
  }
}
