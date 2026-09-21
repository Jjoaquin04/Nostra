import 'dart:ui';
import 'dart:isolate';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nostra/core/themes/app_color.dart';
import 'package:nostra/core/utils/snackbar_helper.dart';
import 'package:nostra/core/utils/user_config.dart';
import 'package:nostra/featured/domain/entity/expense.dart';
import 'package:nostra/featured/presentation/bloc/expense_bloc.dart';
import 'package:nostra/featured/presentation/bloc/expense_event.dart';
import 'package:nostra/featured/presentation/bloc/expense_state.dart';
import 'package:nostra/featured/presentation/widgets/expenses_screen/delete_confirmation_dialog.dart';
import 'package:nostra/featured/presentation/widgets/expenses_screen/expense_floating_action_buttons.dart';
import 'package:nostra/featured/presentation/widgets/expenses_screen/expense_list_builder.dart';
import 'package:nostra/featured/presentation/widgets/expenses_screen/selection_bottom_bar.dart';
import 'package:nostra/featured/presentation/widgets/expenses_screen/expense_app_bar.dart';
import 'package:nostra/featured/presentation/widgets/expenses_screen/summary_cards_widget.dart';
import 'package:nostra/featured/presentation/widgets/expenses_screen/add_expense_bottom_sheet.dart';
import 'package:nostra/main.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => ExpensesScreenState();
}

class ExpensesScreenState extends State<ExpensesScreen> {
  ReceivePort? _receivePort;

  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(
      GetExpensesByMonthEvent(time: DateTime.now()),
    );
    _initializeIsolateCommunication();
  }

  void _initializeIsolateCommunication() {
    _receivePort = ReceivePort();
    IsolateNameServer.registerPortWithName(
      _receivePort!.sendPort,
      mainIsolatePortName,
    );

    _receivePort!.listen((dynamic data) {
      if (data is String) {
        _processAndAddExpense(data);
      }
    });
  }

  Future<void> _processAndAddExpense(String jsonString) async {
    try {
      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      final amountStr = data['amount'] as String?;
      final amount = amountStr != null ? double.tryParse(amountStr) : null;
      final dateStr = data['date'] as String?;
      final date = (dateStr != null) ? DateTime.tryParse(dateStr) : null;
      final typeStr = data['type'] as String?;
      final fixedExpense = data['fixedExpense'] as int?;

      if (amount == null || date == null || typeStr == null) {
        return;
      }

      final expenseOwner = await UserConfig.getUserName();
      final name = data['name'] as String? ?? '';
      final category = data['category'] as String? ?? 'Otros';
      final type = typeStr == "expense"
          ? TransactionType.expense
          : TransactionType.income;

      // 4. Añadir el evento al BLoC.
      // El BLoC se encargará de guardarlo en Hive y actualizar el estado.
      if (mounted) {
        context.read<ExpenseBloc>().add(
          AddExpenseEvent(
            expenseOwner: expenseOwner,
            expenseName: name,
            amount: amount,
            category: category,
            date: date,
            type: type,
            fixedExpense: fixedExpense ?? 0,
          ),
        );
      }
      // La actualización del balance se hace automáticamente en el repositorio
    } catch (e) {
      return;
    }
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping(mainIsolatePortName);
    _receivePort?.close();
    super.dispose();
  }

  Future<void> saveExpense({
    required String name,
    required String category,
    required String amount,
    required DateTime date,
    required TransactionType type,
    required int fixedExpense,
  }) async {
    // Validar campos vacíos
    if (name.trim().isEmpty || category.isEmpty || amount.trim().isEmpty) {
      SnackBarHelper.showError(context, "Todos los campos son requeridos");
      return;
    }

    // Validar monto
    final parsedAmount = double.tryParse(amount.trim());
    if (parsedAmount == null || parsedAmount <= 0) {
      SnackBarHelper.showError(
        context,
        "Por favor ingresa un monto válido mayor a 0",
      );
      return;
    }

    // Guardar gasto
    context.read<ExpenseBloc>().add(
      AddExpenseEvent(
        expenseOwner: await UserConfig.getUserName(),
        expenseName: name.trim(),
        amount: parsedAmount,
        category: category,
        date: date,
        type: type,
        fixedExpense: fixedExpense,
      ),
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _showAddExpenseBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddExpenseBottomSheet(onSave: saveExpense);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExpenseBloc, ExpenseState>(
      listener: _handleExpenseStateChanges,
      builder: (context, state) {
        final isSelectionMode = state is ExpenseSelectionMode;
        final selectedCount = isSelectionMode ? state.selectedIds.length : 0;

        return Scaffold(
          backgroundColor: AppColor.background,
          appBar: const ExpenseAppBar(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SummaryCardsWidget(),
              const SizedBox(height: 20),
              Divider(
                height: 2,
                color: AppColor.secondary.withValues(alpha: 0.3),
                indent: 10,
                endIndent: 10,
              ),
              const Expanded(child: ExpenseListBuilder()),
            ],
          ),
          bottomNavigationBar: isSelectionMode
              ? SelectionBottomBar(
                  selectedCount: selectedCount,
                  onDelete: () => DeleteConfirmationDialog.show(context),
                )
              : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: isSelectionMode
              ? null
              : ExpenseFloatingActionButtons(
                  onAddExpense: _showAddExpenseBottomSheet,
                ),
        );
      },
    );
  }

  void _handleExpenseStateChanges(BuildContext context, ExpenseState state) {
    if (state is ExpenseAdded) {
      SnackBarHelper.showSuccess(context, 'Añadido un nuevo gasto');
    } else if (state is ExpenseUpdated) {
      SnackBarHelper.showSuccess(context, 'Gasto actualizado correctamente');
    } else if (state is ExpenseDeleted) {
      SnackBarHelper.showSuccess(context, 'Gasto eliminado');
      context.read<ExpenseBloc>().add(
        GetExpensesByMonthEvent(time: DateTime.now()),
      );
    } else if (state is ExpenseError) {
      SnackBarHelper.showError(context, 'Error: ${state.message}');
    }
  }
}
