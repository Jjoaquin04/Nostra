import 'package:flutter/material.dart';
import 'package:nostra/core/themes/app_color.dart';
import 'package:nostra/core/utils/user_config.dart';
import 'package:nostra/featured/presentation/pages/expenses_screen.dart';
import 'package:nostra/l10n/app_localizations.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _initialBalanceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _initialBalanceController.dispose();
    super.dispose();
  }

  void _handleContinue() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final initialBalance =
          double.tryParse(_initialBalanceController.text) ?? 0.0;

      // Guardar configuración
      await UserConfig.saveUserConfig(
        name: name,
        initialBalance: initialBalance,
      );

      // Navegar a la pantalla principal
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ExpensesScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColor.background,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 60,
              left: 24,
              right: 24,
              bottom: 24,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Icono/Logo
                  Icon(
                    Icons.account_balance_wallet,
                    size: 100,
                    color: AppColor.primary,
                  ),
                  const SizedBox(height: 40),

                  // Título
                  Text(
                    l10n.welcomeTitle,
                    style: const TextStyle(
                      fontFamily: 'SEGOE_UI',
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Subtítulo
                  Text(
                    l10n.welcomeSubtitle,
                    style: TextStyle(
                      fontFamily: 'SEGOE_UI',
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Campo: Nombre
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: l10n.yourName,
                      hintText: l10n.yourNameHint,
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.pleaseEnterName;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Campo: Balance inicial
                  TextFormField(
                    controller: _initialBalanceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: l10n.initialBalance,
                      hintText: l10n.initialBalanceHint,
                      prefixIcon: const Icon(Icons.euro),
                      suffixText: '€',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      helperText: l10n.initialBalanceHelper,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.pleaseEnterBalance;
                      }
                      final number = double.tryParse(value);
                      if (number == null) {
                        return l10n.enterValidNumber;
                      }
                      if (number < 0) {
                        return l10n.balanceCannotBeNegative;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),

                  // Botón continuar
                  ElevatedButton(
                    onPressed: _handleContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      l10n.continueButton,
                      style: const TextStyle(
                        fontFamily: 'SEGOE_UI',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
