import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketledger/core/navigation/app_shell.dart';
import 'package:pocketledger/core/theme/app_colors.dart';
import 'package:pocketledger/core/theme/app_theme.dart';

void main() {
  testWidgets('AppShell renders pastel glass bottom navigation',
      (tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        ShellRoute(
          builder: (context, state, child) => AppShell(child: child),
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const _Screen(label: 'home'),
            ),
            GoRoute(
              path: '/transactions',
              builder: (context, state) => const _Screen(label: 'activity'),
            ),
            GoRoute(
              path: '/charts',
              builder: (context, state) => const _Screen(label: 'insights'),
            ),
            GoRoute(
              path: '/budgets',
              builder: (context, state) => const _Screen(label: 'plans'),
            ),
            GoRoute(
              path: '/settings',
              builder: (context, state) => const _Screen(label: 'more'),
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppTheme.light,
        routerConfig: router,
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Activity'), findsOneWidget);
    expect(find.text('Insights'), findsOneWidget);
    expect(find.text('Plans'), findsOneWidget);
    expect(find.text('More'), findsOneWidget);
    expect(find.text('home'), findsOneWidget);
    expect(
      Theme.of(tester.element(find.text('home'))).scaffoldBackgroundColor,
      AppColors.background,
    );

    await tester.tap(find.text('Activity'));
    await tester.pumpAndSettle();

    expect(find.text('activity'), findsOneWidget);
  });
}

class _Screen extends StatelessWidget {
  const _Screen({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(label)),
    );
  }
}
