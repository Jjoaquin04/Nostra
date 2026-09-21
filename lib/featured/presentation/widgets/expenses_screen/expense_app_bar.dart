import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nostra/core/themes/app_color.dart';
import 'package:nostra/core/utils/user_config.dart';
import 'package:nostra/featured/presentation/bloc/expense_bloc.dart';
import 'package:nostra/featured/presentation/bloc/expense_state.dart';
import 'package:nostra/featured/presentation/bloc/notifications_bloc.dart';
import 'package:nostra/featured/presentation/bloc/notifications_event.dart';
import 'package:nostra/featured/presentation/pages/settings_screen.dart';
import 'package:nostra/l10n/app_localizations.dart';

class ExpenseAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ExpenseAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<ExpenseAppBar> createState() => _ExpenseAppBarState();
}

class _ExpenseAppBarState extends State<ExpenseAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _waveAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.3), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 0.3, end: -0.3), weight: 1),
          TweenSequenceItem(tween: Tween(begin: -0.3, end: 0.3), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 0.3, end: -0.3), weight: 1),
          TweenSequenceItem(tween: Tween(begin: -0.3, end: 0.0), weight: 1),
        ]).animate(
          CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _playWaveAnimation() {
    _waveController.reset();
    _waveController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppBar(
      backgroundColor: AppColor.background,
      surfaceTintColor: Colors.transparent, // Evita el tinte grisáceo
      elevation: 8.0, // Añade sombreado
      shadowColor: AppColor.primary.withValues(
        alpha: 0.8,
      ), // Color de la sombra
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: FutureBuilder<String>(
        future: UserConfig.getUserName(),
        builder: (context, snapshot) {
          final userName = snapshot.data ?? 'Usuario';
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${l10n.hello} $userName',
                style: const TextStyle(
                  color: AppColor.primary,
                  fontFamily: 'SEGOE_UI',
                  fontWeight: FontWeight.w100,
                  fontSize: 22,
                ),
              ),
              const SizedBox(width: 12.0),
              GestureDetector(
                onTap: _playWaveAnimation,
                child: AnimatedBuilder(
                  animation: _waveAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _waveAnimation.value,
                      child: child,
                    );
                  },
                  child: const Icon(
                    Icons.waving_hand_outlined,
                    color: AppColor.primary,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        const _TotalBalanceWidget(),
        IconButton(
          icon: const Icon(Icons.settings_rounded, color: AppColor.primary),
          tooltip: 'Ajustes / Settings',
          onPressed: () {
            context.read<NotificationsBloc>().add(CheckNotificationsEvent());
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          },
        ),
      ],
    );
  }
}

class _TotalBalanceWidget extends StatelessWidget {
  const _TotalBalanceWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        return FutureBuilder<double>(
          future: UserConfig.getInitialBalance(),
          builder: (context, balanceSnapshot) {
            final initialBalance = balanceSnapshot.data ?? 0.0;

            final l10n = AppLocalizations.of(context)!;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.total,
                  style: const TextStyle(
                    fontFamily: "SEGOE_UI",
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColor.secondary,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      initialBalance.toStringAsFixed(2),
                      style: const TextStyle(
                        fontFamily: "SEGOE_UI",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                    ),
                    Icon(Icons.euro_rounded, color: AppColor.primary, size: 18),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
