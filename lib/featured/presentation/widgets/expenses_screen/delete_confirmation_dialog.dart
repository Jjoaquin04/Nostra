import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nostra/core/themes/app_color.dart';
import 'package:nostra/featured/presentation/bloc/expense_bloc.dart';
import 'package:nostra/featured/presentation/bloc/expense_event.dart';
import 'package:nostra/l10n/app_localizations.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  const DeleteConfirmationDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const DeleteConfirmationDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: AppColor.primary, width: 2.0),
      ),
      title: Text(
        l10n.confirmDelete,
        style: const TextStyle(
          fontFamily: 'SEGOE_UI',
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        l10n.confirmDeleteMessage,
        style: const TextStyle(fontFamily: 'SEGOE_UI'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            l10n.cancel,
            style: const TextStyle(color: Colors.grey, fontFamily: 'SEGOE_UI'),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            context.read<ExpenseBloc>().add(DeleteSelectedExpensesEvent());
          },
          child: Text(
            l10n.delete,
            style: const TextStyle(color: Colors.red, fontFamily: 'SEGOE_UI'),
          ),
        ),
      ],
    );
  }
}
