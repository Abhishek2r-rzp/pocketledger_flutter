import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketledger/core/theme/app_colors.dart';
import 'package:pocketledger/core/theme/app_design_system.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.child,
  });

  final Widget child;

  static const _items = [
    _NavItem(
      path: '/',
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
    ),
    _NavItem(
      path: '/transactions',
      label: 'Activity',
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long_rounded,
    ),
    _NavItem(
      path: '/charts',
      label: 'Insights',
      icon: Icons.auto_graph_outlined,
      selectedIcon: Icons.auto_graph_rounded,
    ),
    _NavItem(
      path: '/budgets',
      label: 'Plans',
      icon: Icons.savings_outlined,
      selectedIcon: Icons.savings_rounded,
    ),
    _NavItem(
      path: '/settings',
      label: 'More',
      icon: Icons.tune_outlined,
      selectedIcon: Icons.tune_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final selectedIndex = _selectedIndex(location);

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: AppColors.surfaceGradient,
        ),
        child: child,
      ),
      bottomNavigationBar: _GlassBottomNavigationBar(
        items: _items,
        selectedIndex: selectedIndex,
        onTap: (index) => context.go(_items[index].path),
      ),
    );
  }

  int _selectedIndex(String location) {
    final index = _items.indexWhere((item) {
      if (item.path == '/') return location == '/';
      return location == item.path || location.startsWith('${item.path}/');
    });
    return index == -1 ? 0 : index;
  }
}

class _GlassBottomNavigationBar extends StatelessWidget {
  const _GlassBottomNavigationBar({
    required this.items,
    required this.selectedIndex,
    required this.onTap,
  });

  final List<_NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.xl),
        child: BackdropFilter(
          filter: AppGlass.backdropFilter,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppGlass.surfaceSoft,
              border: Border.all(color: AppGlass.stroke, width: 0.7),
              boxShadow: AppGlass.liftedShadow,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: AppSpacing.xs,
              ),
              child: Row(
                children: [
                  for (var i = 0; i < items.length; i++)
                    Expanded(
                      child: _NavButton(
                        item: items[i],
                        selected: i == selectedIndex,
                        onTap: () => onTap(i),
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

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primaryDark : AppColors.textTertiary;

    return Semantics(
      selected: selected,
      button: true,
      label: item.label,
      child: InkResponse(
        onTap: onTap,
        radius: 32,
        child: AnimatedContainer(
          duration: AppMotion.quick,
          curve: AppMotion.ease,
          height: 54,
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryLight.withOpacity(0.44) : null,
            borderRadius: BorderRadius.circular(AppRadii.lg),
            border: selected
                ? Border.all(color: Colors.white.withOpacity(0.42), width: 0.6)
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selected ? item.selectedIcon : item.icon,
                color: color,
                size: 22,
              ),
              const SizedBox(height: 3),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 10.5,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.path,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String path;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
