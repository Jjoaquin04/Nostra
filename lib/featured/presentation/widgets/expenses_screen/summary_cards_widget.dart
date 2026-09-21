import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nostra/featured/domain/entity/expense.dart';
import 'package:nostra/featured/presentation/bloc/expense_bloc.dart';
import 'package:nostra/featured/presentation/bloc/expense_state.dart';
import 'package:nostra/l10n/app_localizations.dart';

class SummaryCardsWidget extends StatelessWidget {
  const SummaryCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        double totalExpenses = 0.0;
        double totalIncome = 0.0;

        if (state is ExpenseLoaded && state.expenses.isNotEmpty) {
          totalExpenses = state.expenses
              .where((e) => e.type == TransactionType.expense)
              .fold(0.0, (sum, expense) => sum + expense.amount);

          totalIncome = state.expenses
              .where((e) => e.type == TransactionType.income)
              .fold(0.0, (sum, expense) => sum + expense.amount);
        }

        final l10n = AppLocalizations.of(context)!;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 20.0,
              ),
              child: Text(
                l10n.personalMovementTracking,
                style: const TextStyle(
                  fontFamily: "SEGOE_UI",
                  fontSize: 35,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _SummaryCard(
                    label: l10n.expenses,
                    amount: totalExpenses,
                    icon: Icons.arrow_downward,
                    color: Colors.red,
                    isExpense: true,
                  ),
                  _SummaryCard(
                    label: l10n.income,
                    amount: totalIncome,
                    icon: Icons.arrow_upward,
                    color: Colors.green,
                    isExpense: false,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SummaryCard extends StatefulWidget {
  final String label;
  final double amount;
  final IconData icon;
  final Color color;
  final bool isExpense;

  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
    required this.isExpense,
  });

  @override
  State<_SummaryCard> createState() => _SummaryCardState();
}

class _SummaryCardState extends State<_SummaryCard> {
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: _isPressed ? 98 : 100,
          margin: EdgeInsets.only(
            right: widget.isExpense ? 8.0 : 0,
            left: widget.isExpense ? 0 : 8.0,
          ),
          transform: Matrix4.identity()
            ..scaleByDouble(
              _isPressed ? 0.9 : 1.0,
              _isPressed ? 0.9 : 1.0,
              _isPressed ? 0.9 : 1.0,
              1.0,
            ),
          transformAlignment: AlignmentGeometry.center,
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(widget.icon, color: widget.color, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontFamily: "SEGOE_UI",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: widget.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.amount.toStringAsFixed(2),
                      style: TextStyle(
                        fontFamily: "SEGOE_UI",
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: widget.color,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Icon(
                        Icons.euro_rounded,
                        color: widget.color,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
