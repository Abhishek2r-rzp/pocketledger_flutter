import 'package:flutter/material.dart';
import 'app_colors.dart';

class StyledAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBack;

  const StyledAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.textPrimary,
      leading: leading ??
          (showBack
              ? IconButton(
                  icon: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.cardGlass,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.cardGlassBorder,
                        width: 0.5,
                      ),
                    ),
                    child: const Icon(Icons.arrow_back_rounded, size: 20),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : null),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
