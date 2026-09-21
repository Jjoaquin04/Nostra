import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nostra/core/themes/app_color.dart';
import 'package:nostra/featured/presentation/bloc/expense_bloc.dart';
import 'package:nostra/featured/presentation/bloc/expense_event.dart';
import 'package:nostra/l10n/app_localizations.dart';

class SelectionBottomBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onDelete;

  const SelectionBottomBar({
    super.key,
    required this.selectedCount,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: AppColor.background,
        border: Border(
          top: BorderSide(color: AppColor.secondary.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        children: [
          // Botón cancelar
          TextButton.icon(
            onPressed: () {
              context.read<ExpenseBloc>().add(DisableSelectionModeEvent());
            },
            icon: const Icon(Icons.close, color: Colors.grey),
            label: Text(
              l10n.cancel,
              style: const TextStyle(
                color: Colors.grey,
                fontFamily: 'SEGOE_UI',
              ),
            ),
          ),
          const Spacer(),
          // Contador de seleccionados
          Text(
            l10n.itemsSelected(selectedCount),
            style: const TextStyle(
              fontFamily: 'SEGOE_UI',
              fontWeight: FontWeight.bold,
              color: AppColor.primary,
            ),
          ),
          const Spacer(),
          // Botón eliminar
          if (selectedCount > 0)
            TextButton.icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete, color: Colors.red),
              label: Text(
                l10n.delete,
                style: const TextStyle(
                  color: Colors.red,
                  fontFamily: 'SEGOE_UI',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
