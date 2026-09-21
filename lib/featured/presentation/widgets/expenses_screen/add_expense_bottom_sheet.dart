import 'package:flutter/material.dart';
import 'package:nostra/core/constant/expenses_category.dart';
import 'package:nostra/core/themes/app_color.dart';
import 'package:nostra/featured/domain/entity/expense.dart';
import 'package:nostra/l10n/app_localizations.dart';

class AddExpenseBottomSheet extends StatefulWidget {
  final Future<void> Function({
    required String name,
    required String category,
    required String amount,
    required DateTime date,
    required TransactionType type,
    required int fixedExpense,
  })
  onSave;

  const AddExpenseBottomSheet({super.key, required this.onSave});

  @override
  State<AddExpenseBottomSheet> createState() => AddExpenseBottomSheetState();
}

class AddExpenseBottomSheetState extends State<AddExpenseBottomSheet> {
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  bool isFixed = false;
  String category = "";
  DateTime? picked;
  TransactionType type = TransactionType.expense;

  @override
  void initState() {
    super.initState();
    category = ExpensesCategory.expenseCategory[0];
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selected != null) {
      picked = selected;
      dateController.text = picked.toString().split(" ")[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: AppColor.background,
        border: Border.all(color: AppColor.primary, width: 3),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          top: 24.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Título del bottom sheet
              Center(
                child: Container(
                  width: 50,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColor.secondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.newTransaction,
                style: const TextStyle(
                  fontFamily: "SEGOE_UI",
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          l10n.type,
                          style: const TextStyle(
                            fontFamily: "SEGOE_UI",
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColor.secondary,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 8),
                        DropdownMenu<TransactionType>(
                          onSelected: (TransactionType? value) {
                            setState(() {
                              type = value ?? TransactionType.expense;
                              // Resetear categoría al cambiar de tipo
                              category = type == TransactionType.expense
                                  ? ExpensesCategory.expenseCategory[0]
                                  : ExpensesCategory.incomeCategory[0];
                            });
                          },
                          width: MediaQuery.of(context).size.width - 48,
                          initialSelection: TransactionType.expense,
                          textStyle: const TextStyle(
                            fontFamily: "SEGOE_UI",
                            fontSize: 16,
                          ),
                          inputDecorationTheme: InputDecorationTheme(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColor.secondary.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColor.secondary.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColor.primary,
                                width: 2,
                              ),
                            ),
                          ),
                          dropdownMenuEntries: [
                            DropdownMenuEntry(
                              value: TransactionType.expense,
                              label: l10n.expense,
                              leadingIcon: const Icon(
                                Icons.arrow_downward,
                                color: Colors.red,
                              ),
                            ),
                            DropdownMenuEntry(
                              value: TransactionType.income,
                              label: l10n.income,
                              leadingIcon: const Icon(
                                Icons.arrow_upward,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        l10n.fixed,
                        style: const TextStyle(
                          fontFamily: "SEGOE_UI",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColor.secondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Checkbox(
                        value: isFixed,
                        onChanged: (_) => setState(() {
                          isFixed = !isFixed;
                        }),
                        activeColor: AppColor.primary,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Nombre del gasto/ingreso
              Text(
                l10n.name,
                style: const TextStyle(
                  fontFamily: "SEGOE_UI",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColor.secondary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: l10n.nameHint,
                  hintStyle: TextStyle(
                    color: AppColor.secondary.withValues(alpha: 0.5),
                    fontFamily: "SEGOE_UI",
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColor.secondary.withValues(alpha: 0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColor.secondary.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColor.primary,
                      width: 2,
                    ),
                  ),
                ),
                style: const TextStyle(fontFamily: "SEGOE_UI", fontSize: 16),
              ),
              const SizedBox(height: 20),

              // Categoría
              Text(
                l10n.category,
                style: const TextStyle(
                  fontFamily: "SEGOE_UI",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColor.secondary,
                ),
              ),
              const SizedBox(height: 8),
              DropdownMenu<String>(
                onSelected: (String? value) {
                  setState(() {
                    category = value!;
                  });
                },
                initialSelection: category,
                width: MediaQuery.of(context).size.width - 48,
                textStyle: const TextStyle(
                  fontFamily: "SEGOE_UI",
                  fontSize: 16,
                ),
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColor.secondary.withValues(alpha: 0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColor.secondary.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColor.primary,
                      width: 2,
                    ),
                  ),
                ),
                dropdownMenuEntries:
                    (type == TransactionType.expense
                            ? ExpensesCategory.expenseCategory
                            : ExpensesCategory.incomeCategory)
                        .map(
                          (category) => DropdownMenuEntry(
                            value: category,
                            label: category,
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Column(
                        children: [
                          Text(
                            l10n.amount,
                            style: const TextStyle(
                              fontFamily: "SEGOE_UI",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColor.secondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: amountController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              hintText: l10n.amountHint,
                              prefixIcon: Icon(
                                Icons.euro_rounded,
                                color: AppColor.primary,
                              ),
                              prefixStyle: const TextStyle(
                                color: AppColor.primary,
                                fontFamily: "SEGOE_UI",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              hintStyle: TextStyle(
                                color: AppColor.secondary.withValues(
                                  alpha: 0.5,
                                ),
                                fontFamily: "SEGOE_UI",
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColor.secondary.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColor.secondary.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColor.primary,
                                  width: 2,
                                ),
                              ),
                            ),
                            style: const TextStyle(
                              fontFamily: "SEGOE_UI",
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          l10n.date,
                          style: const TextStyle(
                            fontFamily: "SEGOE_UI",
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColor.secondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: dateController,
                          decoration: InputDecoration(
                            hintText: l10n.dateHint,
                            prefixIcon: Icon(
                              Icons.calendar_month_rounded,
                              color: AppColor.primary,
                            ),
                            prefixStyle: const TextStyle(
                              color: AppColor.primary,
                              fontFamily: "SEGOE_UI",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            hintStyle: TextStyle(
                              color: AppColor.secondary.withValues(alpha: 0.5),
                              fontFamily: "SEGOE_UI",
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColor.secondary.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColor.secondary.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColor.primary,
                                width: 2,
                              ),
                            ),
                          ),
                          readOnly: true,
                          onTap: () {
                            _selectDate();
                          },
                          style: const TextStyle(
                            fontFamily: "SEGOE_UI",
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Botón de guardar
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    final dateToUse = picked ?? DateTime.now();
                    widget.onSave(
                      name: nameController.text,
                      category: category,
                      amount: amountController.text,
                      date: dateToUse,
                      type: type,
                      fixedExpense: isFixed ? 1 : 0,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    l10n.saveButton,
                    style: const TextStyle(
                      fontFamily: "SEGOE_UI",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
