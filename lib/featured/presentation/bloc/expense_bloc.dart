import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:nostra/core/constant/hive_constants.dart';
import 'package:nostra/core/usecases/usecase.dart';
import 'package:nostra/featured/data/expense_model.dart';
import 'package:nostra/featured/domain/usecases/add_expense.dart';
import 'package:nostra/featured/domain/usecases/delete_expense.dart';
import 'package:nostra/featured/domain/usecases/get_expenses.dart';
import 'package:nostra/featured/domain/usecases/get_expenses_by_month.dart';
import 'package:nostra/featured/domain/usecases/update_expense.dart';
import 'package:nostra/featured/presentation/bloc/expense_event.dart';
import 'package:nostra/featured/presentation/bloc/expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final GetExpenses getExpensesUseCase;
  final AddExpense addExpenseUseCase;
  final UpdateExpense updateExpenseUseCase;
  final DeleteExpense deleteExpenseUseCase;
  final GetExpensesByMonth getExpensesByMonthUseCase;

  StreamSubscription? _streamSubscription;
  DateTime _currentDate = DateTime.now();

  ExpenseBloc({
    required this.getExpensesUseCase,
    required this.addExpenseUseCase,
    required this.updateExpenseUseCase,
    required this.deleteExpenseUseCase,
    required this.getExpensesByMonthUseCase,
  }) : super(const ExpenseInitial()) {
    // Registrar manejadores de eventos
    on<LoadExpensesEvent>(_onLoadExpenses);
    on<AddExpenseEvent>(_onAddExpense);
    on<UpdateExpenseEvent>(_onUpdateExpense);
    on<DeleteExpenseEvent>(_onDeleteExpense);
    on<GetExpensesByMonthEvent>(_getMonthExpenses);
    on<EnableSelectionModeEvent>(_onEnableSelectionMode);
    on<DisableSelectionModeEvent>(_onDisableSelectionMode);
    on<ToggleExpenseSelectionEvent>(_onToggleExpenseSelection);
    on<SelectAllExpensesEvent>(_onSelectAllExpenses);
    on<DeselectAllExpensesEvent>(_onDeselectAllExpenses);
    on<DeleteSelectedExpensesEvent>(_onDeleteSelectedExpenses);

    _listenBoxChanges();
  }

  void _listenBoxChanges() {
    final Box<ExpenseModel> box = Hive.box<ExpenseModel>(
      HiveConstants.expenseBox,
    );

    _streamSubscription = box.watch().listen((event) {
      add(GetExpensesByMonthEvent(time: _currentDate));
    });
  }

  /// Cargar todos los gastos
  Future<void> _onLoadExpenses(
    LoadExpensesEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());

    final result = await getExpensesUseCase(const NoParams());

    result.fold((failure) => emit(ExpenseError(message: failure.message)), (
      expenses,
    ) {
      // Calcular el total
      final total = expenses.fold<double>(
        0.0,
        (sum, expense) => sum + expense.amount,
      );

      emit(ExpenseLoaded(expenses: expenses, totalAmount: total));
    });
  }

  /// Agregar un nuevo gasto
  Future<void> _onAddExpense(
    AddExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());

    final result = await addExpenseUseCase(
      ExpenseParams(
        expenseOwner: event.expenseOwner,
        expenseName: event.expenseName,
        amount: event.amount,
        category: event.category,
        date: event.date,
        type: event.type,
        fixedExpense: event.fixedExpense,
      ),
    );

    result.fold((failure) => emit(ExpenseError(message: failure.message)), (
      expense,
    ) {
      emit(ExpenseAdded(expense: expense));
      // Recargar la lista de gastos
      add(GetExpensesByMonthEvent(time: DateTime.now()));
    });
  }

  /// Actualizar un gasto existente
  Future<void> _onUpdateExpense(
    UpdateExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());

    final result = await updateExpenseUseCase(event.expense);

    result.fold((failure) => emit(ExpenseError(message: failure.message)), (_) {
      emit(ExpenseUpdated(expense: event.expense));
      // Recargar gastos del mes actual
      add(GetExpensesByMonthEvent(time: DateTime.now()));
    });
  }

  /// Eliminar un gasto
  Future<void> _onDeleteExpense(
    DeleteExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());

    final result = await deleteExpenseUseCase(event.expense);

    result.fold((failure) => emit(ExpenseError(message: failure.message)), (_) {
      emit(const ExpenseDeleted());
      // Recargar gastos del mes actual
      add(GetExpensesByMonthEvent(time: DateTime.now()));
    });
  }

  Future<void> _getMonthExpenses(
    GetExpensesByMonthEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());

    _currentDate = event.time;

    final result = await getExpensesByMonthUseCase(
      ExpensesByMonthParams(time: event.time),
    );

    result.fold(
      (failure) => emit(ExpenseError(message: failure.message)),
      (expenses) => emit(ExpenseLoaded(expenses: expenses)),
    );
  }

  /// Activar modo de selección múltiple
  Future<void> _onEnableSelectionMode(
    EnableSelectionModeEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    if (state is ExpenseLoaded) {
      final loadedState = state as ExpenseLoaded;
      emit(
        ExpenseSelectionMode(
          expenses: loadedState.expenses,
          selectedIds: {},
          totalAmount: loadedState.totalAmount,
        ),
      );
    }
  }

  /// Desactivar modo de selección múltiple
  Future<void> _onDisableSelectionMode(
    DisableSelectionModeEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    if (state is ExpenseSelectionMode) {
      final selectionState = state as ExpenseSelectionMode;
      emit(
        ExpenseLoaded(
          expenses: selectionState.expenses,
          totalAmount: selectionState.totalAmount,
        ),
      );
    }
  }

  /// Seleccionar/deseleccionar un gasto
  Future<void> _onToggleExpenseSelection(
    ToggleExpenseSelectionEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    if (state is ExpenseSelectionMode) {
      final selectionState = state as ExpenseSelectionMode;
      final selectedIds = Set<String>.from(selectionState.selectedIds);

      if (selectedIds.contains(event.expenseId)) {
        selectedIds.remove(event.expenseId);
      } else {
        selectedIds.add(event.expenseId);
      }

      emit(selectionState.copyWith(selectedIds: selectedIds));
    }
  }

  /// Seleccionar todos los gastos
  Future<void> _onSelectAllExpenses(
    SelectAllExpensesEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    if (state is ExpenseSelectionMode) {
      final selectionState = state as ExpenseSelectionMode;
      final allIds = selectionState.expenses
          .where((e) => e.id != null)
          .map((e) => e.id!)
          .toSet();

      emit(selectionState.copyWith(selectedIds: allIds));
    }
  }

  /// Deseleccionar todos los gastos
  Future<void> _onDeselectAllExpenses(
    DeselectAllExpensesEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    if (state is ExpenseSelectionMode) {
      final selectionState = state as ExpenseSelectionMode;
      emit(selectionState.copyWith(selectedIds: {}));
    }
  }

  /// Eliminar gastos seleccionados
  Future<void> _onDeleteSelectedExpenses(
    DeleteSelectedExpensesEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    if (state is ExpenseSelectionMode) {
      final selectionState = state as ExpenseSelectionMode;

      emit(const ExpenseLoading());

      // Eliminar cada gasto seleccionado
      for (final expenseId in selectionState.selectedIds) {
        final expense = selectionState.expenses.firstWhere(
          (e) => e.id == expenseId,
        );
        await deleteExpenseUseCase(expense);
      }

      // Recargar gastos del mes actual
      add(GetExpensesByMonthEvent(time: DateTime.now()));
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
