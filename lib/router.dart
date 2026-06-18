import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketledger/features/onboarding/onboarding_screen.dart';
import 'package:pocketledger/features/lock/lock_screen.dart';
import 'package:pocketledger/features/dashboard/dashboard_screen.dart';
import 'package:pocketledger/features/import/import_screen.dart';
import 'package:pocketledger/features/review_queue/review_queue_screen.dart';
import 'package:pocketledger/features/transactions/transactions_screen.dart';
import 'package:pocketledger/features/transactions/transaction_detail_screen.dart';
import 'package:pocketledger/features/charts/charts_screen.dart';
import 'package:pocketledger/features/budgets/budgets_screen.dart';
import 'package:pocketledger/features/recurring_payments/recurring_payments_screen.dart';
import 'package:pocketledger/features/import_history/import_history_screen.dart';
import 'package:pocketledger/features/settings/settings_screen.dart';
import 'package:pocketledger/features/agent_logs/agent_logs_screen.dart';
import 'package:pocketledger/features/accounts/accounts_screen.dart';
import 'package:pocketledger/features/search/search_screen.dart';
import 'package:pocketledger/features/labels/labels_screen.dart';
import 'package:pocketledger/core/theme/app_colors.dart';

final GlobalKey<NavigatorState> _rootNavigator = GlobalKey<NavigatorState>();

GoRoute _route({
  required String path,
  required Widget child,
  String? name,
}) {
  return GoRoute(
    path: path,
    name: name,
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.06),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 250),
    ),
  );
}

final router = GoRouter(
  navigatorKey: _rootNavigator,
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const OnboardingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    ),
    _route(path: '/lock', child: const LockScreen(), name: 'lock'),
    _route(path: '/', child: const DashboardScreen(), name: 'dashboard'),
    _route(path: '/import', child: const ImportScreen(), name: 'import'),
    _route(path: '/review', child: const ReviewQueueScreen(), name: 'review'),
    _route(path: '/transactions', child: const TransactionsScreen(), name: 'transactions'),
    GoRoute(
      path: '/transactions/:id',
      name: 'transaction-detail',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: TransactionDetailScreen(
          transactionId: state.pathParameters['id'],
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.08),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    ),
    _route(path: '/charts', child: const ChartsScreen(), name: 'charts'),
    _route(path: '/budgets', child: const BudgetsScreen(), name: 'budgets'),
    _route(path: '/recurring', child: const RecurringPaymentsScreen(), name: 'recurring'),
    _route(path: '/import-history', child: const ImportHistoryScreen(), name: 'import-history'),
    _route(path: '/settings', child: const SettingsScreen(), name: 'settings'),
    _route(path: '/agent-logs', child: const AgentLogsScreen(), name: 'agent-logs'),
    _route(path: '/accounts', child: const AccountsScreen(), name: 'accounts'),
    _route(path: '/search', child: const SearchScreen(), name: 'search'),
    _route(path: '/labels', child: const LabelsScreen(), name: 'labels'),
  ],
);
