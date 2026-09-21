import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nostra/core/themes/app_color.dart';
import 'package:nostra/featured/domain/entity/expense.dart';
import 'package:nostra/featured/presentation/bloc/expense_bloc.dart';
import 'package:nostra/featured/presentation/bloc/expense_event.dart';
import 'package:nostra/l10n/app_localizations.dart';

class ExpenseListItem extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onLongPress;
  final VoidCallback? onTap;
  final bool isSelectionMode;
  final bool isSelected;

  const ExpenseListItem({
    super.key,
    required this.expense,
    this.onLongPress,
    this.onTap,
    this.isSelectionMode = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isSelectionMode) ...[
              Checkbox(
                value: isSelected,
                onChanged: (value) {
                  if (onTap != null) onTap!();
                },
                activeColor: AppColor.primary,
              ),
              const SizedBox(width: 12),
            ],
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _DateRow(date: expense.date),
                const SizedBox(height: 8),
                _CategoryChip(category: expense.category),
              ],
            ),
            const SizedBox(width: 16),
            // Columna derecha: Nombre y Precio
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Tooltip(
                          message: expense.nameExpense,
                          child: Text(
                            expense.nameExpense,
                            style: const TextStyle(
                              fontFamily: "SEGOE_UI",
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      if (expense.fixedExpense == 1) ...[
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onLongPress: () => _showUnpinDialog(context, l10n),
                            onTap: () => _showInfoDialog(context, l10n),
                            child: const Icon(
                              Icons.push_pin,
                              size: 18,
                              color: AppColor.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  _AmountText(amount: expense.amount, type: expense.type),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Muestra el diálogo de información sobre gastos fijos
  void _showInfoDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: const BorderSide(color: AppColor.primary, width: 2.0),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 30,
                color: AppColor.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.fixedTransactionInfo,
                  style: const TextStyle(
                    fontFamily: "SEGOE_UI",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Text(
                l10n.fixedTransactionDescription,
                style: const TextStyle(
                  fontFamily: "SEGOE_UI",
                  fontSize: 18,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontFamily: "SEGOE_UI",
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Muestra el diálogo para convertir un gasto fijo en no fijo
  void _showUnpinDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: const BorderSide(color: AppColor.primary, width: 2.0),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.push_pin_outlined,
                size: 30,
                color: AppColor.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.unpinFixedExpense,
                  style: const TextStyle(
                    fontFamily: "SEGOE_UI",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.unpinFixedExpenseQuestion(expense.nameExpense),
                style: const TextStyle(
                  fontFamily: "SEGOE_UI",
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 01),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.unpinFixedExpenseWarning,
                        style: TextStyle(
                          fontFamily: "SEGOE_UI",
                          fontSize: 13,
                          color: Colors.orange[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                l10n.cancel,
                style: const TextStyle(
                  fontFamily: "SEGOE_UI",
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _unpinExpense(context, l10n);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                l10n.deactivate,
                style: const TextStyle(
                  fontFamily: "SEGOE_UI",
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Convierte el gasto fijo en no fijo
  Future<void> _unpinExpense(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    try {
      // Actualizar el gasto en el Bloc
      final updatedExpense = Expense(
        id: expense.id,
        ownerExpense: expense.ownerExpense,
        nameExpense: expense.nameExpense,
        amount: expense.amount,
        category: expense.category,
        date: expense.date,
        type: expense.type,
        fixedExpense: 0, // No fijo
        changeHistory: expense.changeHistory,
      );

      if (context.mounted) {
        context.read<ExpenseBloc>().add(
          UpdateExpenseEvent(expense: updatedExpense),
        );

        // Mostrar confirmación
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.expenseConvertedToNonFixed,
                    style: const TextStyle(
                      fontFamily: "SEGOE_UI",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${l10n.errorDeactivatingFixedExpense}: $e',
                    style: const TextStyle(fontFamily: "SEGOE_UI"),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }
}

class _DateRow extends StatelessWidget {
  final DateTime date;

  const _DateRow({required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text(
          '${date.day}/${date.month}/${date.year}',
          style: TextStyle(
            fontFamily: 'SEGOE_UI',
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String category;

  const _CategoryChip({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.secondary.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        category,
        style: const TextStyle(
          fontFamily: "SEGOE_UI",
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _AmountText extends StatelessWidget {
  final double amount;
  final TransactionType type;

  const _AmountText({required this.amount, required this.type});

  @override
  Widget build(BuildContext context) {
    final isExpense = type == TransactionType.expense;
    return Row(
      children: [
        Text(
          isExpense
              ? "-${amount.toStringAsFixed(2)}"
              : amount.toStringAsFixed(2),
          style: const TextStyle(
            fontFamily: "SEGOE_UI",
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColor.primary,
          ),
        ),
        Icon(Icons.euro_rounded, color: AppColor.primary, size: 18),
      ],
    );
  }
}
