import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:nostra/core/constant/hive_constants.dart';
import 'package:nostra/core/errors/exception.dart';
import 'package:nostra/core/errors/failure.dart';
import 'package:nostra/core/utils/expense_change_history_helper.dart';
import 'package:nostra/core/utils/user_config.dart';
import 'package:nostra/featured/data/datasources/expense_local_datasource.dart';
import 'package:nostra/featured/data/expense_model.dart';
import 'package:nostra/featured/domain/entity/expense.dart';
import 'package:nostra/featured/domain/repository/expense_repository.dart';

/// Implementación concreta del repositorio
/// Conecta la capa de dominio con la capa de datos
/// Convierte Exceptions (técnicas) en Failures (semánticas)
class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource localDataSource;

  ExpenseRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, Expense>> addExpense(
    String expenseOwner,
    String expenseName,
    double amount,
    String category,
    DateTime date,
    TransactionType type,
    int fixedExpense,
  ) async {
    try {
      // Crear el modelo
      final model = ExpenseModel(
        expenseOwner: expenseOwner,
        expenseName: expenseName,
        amount: amount,
        category: category,
        date: date,
        type: type == TransactionType.expense ? 0 : 1,
        fixedExpense: fixedExpense,
      );

      // Guardar en el DataSource y obtener la key
      final key = await localDataSource.addExpense(model);

      // Actualizar el balance: sumar si es ingreso, restar si es gasto
      final currentBalance = await UserConfig.getInitialBalance();
      final newBalance = type == TransactionType.income
          ? currentBalance +
                amount // Añadir ingreso
          : currentBalance - amount; // Restar gasto
      await UserConfig.updateInitialBalance(newBalance);

      // Retornar la entidad creada con ID
      final entity = model.toEntity(id: key);
      return Right(entity);
    } on CacheException catch (e) {
      // Convertir Exception técnica en Failure semántica
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> getExpenses() async {
    try {
      // Obtener modelos del DataSource
      final modelsMap = localDataSource.getAllExpenses();

      // Convertir de Modelos a Entidades manteniendo las keys como IDs
      final entities = modelsMap.entries
          .map((entry) => entry.value.toEntity(id: entry.key))
          .toList();

      return Right(entities);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateExpense(Expense expense) async {
    try {
      // Validar que tenga ID
      if (expense.id == null) {
        return const Left(
          ValidationFailure('El gasto debe tener un ID para actualizarlo'),
        );
      }

      // Convertir ID string a int
      final index = int.tryParse(expense.id!);
      if (index == null) {
        return const Left(ValidationFailure('ID de gasto inválido'));
      }

      // Obtener el gasto anterior para comparar (si es gasto fijo)
      final box = await Hive.openBox<ExpenseModel>(HiveConstants.expenseBox);
      final oldModel = box.get(index);

      // Convertir a modelo y actualizar
      final newModel = ExpenseModel.fromEntity(expense);

      // Si el gasto anterior era fijo, registrar el cambio en el historial
      if (oldModel != null && oldModel.fixedExpense == 1) {
        await ExpenseChangeHistoryHelper.recordEdit(
          expense.id!,
          oldModel,
          newModel,
        );
      } else {
        // Si no era fijo, simplemente actualizar
        await localDataSource.updateExpense(expense.id!, newModel);
      }

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpense(Expense expense) async {
    try {
      // Validar que tenga ID
      if (expense.id == null) {
        return const Left(
          ValidationFailure('El gasto debe tener un ID para eliminarlo'),
        );
      }

      // Convertir ID string a int (no es necesario, ahora usamos String directamente)
      await localDataSource.deleteExpense(expense.id!);

      // Actualizar el balance: restar si es gasto, sumar si es ingreso
      final currentBalance = await UserConfig.getInitialBalance();
      final newBalance = expense.type == TransactionType.expense
          ? currentBalance +
                expense
                    .amount // Devolver el dinero del gasto
          : currentBalance - expense.amount; // Quitar el ingreso
      await UserConfig.updateInitialBalance(newBalance);

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // Método auxiliar - No está en el contrato del Repository
  Future<Either<Failure, double>> getTotalExpenses() async {
    try {
      final total = localDataSource.getTotalExpenses();
      return Right(total);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> getExpensesByMonth(
    DateTime date,
  ) async {
    try {
      final modelsMap = localDataSource.getExpensesByMonth(date);
      final entities = modelsMap.entries
          .map((entry) => entry.value.toEntity(id: entry.key))
          .toList();
      return Right(entities);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
