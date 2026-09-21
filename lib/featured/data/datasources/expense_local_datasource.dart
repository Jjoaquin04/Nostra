import 'package:nostra/featured/data/expense_model.dart';

abstract class ExpenseLocalDataSource {
  Future<String> addExpense(ExpenseModel expense);
  Map<String, ExpenseModel> getAllExpenses();
  Future<void> updateExpense(String key, ExpenseModel expense);
  Future<void> deleteExpense(String key);
  Map<String, ExpenseModel> getExpensesByMonth(DateTime time);
  double getTotalExpenses();
}
