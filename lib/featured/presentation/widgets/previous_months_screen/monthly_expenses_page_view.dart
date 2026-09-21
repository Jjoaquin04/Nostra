import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nostra/core/themes/app_color.dart';
import 'package:nostra/featured/domain/entity/expense.dart';
import 'package:nostra/featured/presentation/bloc/expense_bloc.dart';
import 'package:nostra/featured/presentation/bloc/expense_state.dart';
import 'package:nostra/featured/presentation/widgets/previous_months_screen/month_card.dart';

class MonthlyExpensesPageView extends StatelessWidget {
  final PageController controller;
  final Map<String, Map<String, dynamic>> Function(List<Expense>)
  groupExpensesByMonth;

  const MonthlyExpensesPageView({
    super.key,
    required this.controller,
    required this.groupExpensesByMonth,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        if (state is ExpenseLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.primary),
          );
        }

        if (state is ExpenseError) {
          return Center(
            child: Text(
              'Error: ${state.message}',
              style: const TextStyle(fontFamily: 'SEGOE_UI', color: Colors.red),
            ),
          );
        }

        if (state is! ExpenseLoaded || state.expenses.isEmpty) {
          return const Center(
            child: Text(
              'No hay datos de meses anteriores',
              style: TextStyle(
                fontFamily: 'SEGOE_UI',
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          );
        }

        // Agrupar gastos por mes
        final monthlyData = groupExpensesByMonth(state.expenses);

        // Ordenar meses de más reciente a más antiguo
        final sortedMonthKeys = monthlyData.keys.toList()
          ..sort((a, b) => a.compareTo(b));

        if (sortedMonthKeys.isEmpty) {
          return const Center(
            child: Text(
              'No hay datos de meses anteriores',
              style: TextStyle(
                fontFamily: 'SEGOE_UI',
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: SizedBox(
            height: double.infinity,
            child: PageView.builder(
              itemCount: sortedMonthKeys.length,
              controller: controller,
              itemBuilder: (context, index) {
                final monthKey = sortedMonthKeys[index];
                final data = monthlyData[monthKey]!;

                return ListenableBuilder(
                  listenable: controller,
                  builder: (context, child) {
                    double factor = 1;
                    if (controller.position.hasContentDimensions) {
                      factor = 1 - (controller.page! - index).abs();
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Center(
                        child: SizedBox(
                          height: 700 + (factor * 30),
                          child: MonthCard(
                            month: data['month'],
                            year: data['year'],
                            totalExpenses: data['totalExpenses'],
                            totalIncome: data['totalIncome'],
                            expensesByCategory: data['expensesByCategory'],
                            incomesByCategory: data['incomesByCategory'],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
