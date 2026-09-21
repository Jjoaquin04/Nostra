import 'package:flutter/material.dart';
import 'package:nostra/core/themes/app_color.dart';
import 'package:nostra/featured/presentation/pages/previous_months_screen.dart';

class ExpenseFloatingActionButtons extends StatelessWidget {
  final VoidCallback onAddExpense;

  const ExpenseFloatingActionButtons({super.key, required this.onAddExpense});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FloatingActionButton(
            heroTag: 'previousMonthsButton',
            backgroundColor: AppColor.background,
            hoverElevation: 2.0,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: AppColor.primary, width: 2.5),
              borderRadius: BorderRadius.circular(12.0),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PreviousMonthsScreen(),
                ),
              );
            },
            child: const Icon(
              Icons.calendar_month_rounded,
              color: AppColor.primary,
              size: 25,
            ),
          ),
          FloatingActionButton(
            heroTag: 'addExpenseButton',
            backgroundColor: AppColor.background,
            hoverElevation: 2.0,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: AppColor.primary, width: 2.5),
              borderRadius: BorderRadius.circular(12.0),
            ),
            onPressed: onAddExpense,
            child: const Icon(
              Icons.add_rounded,
              color: AppColor.primary,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}
