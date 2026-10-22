import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:game_show_app/core/design/xo_icon.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';

class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ComicColors.cream,
      body: navigationShell,
      bottomNavigationBar: _ComicBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            // Support navigating to the initial location when tapping the active tab.
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}

class _ComicBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _ComicBottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xB80A0728),
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.12), width: 1.5)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(icon: 'home', label: 'HOME', isSelected: currentIndex == 0, onTap: () => onTap(0)),
            _NavItem(icon: 'trophy', label: 'RANKS', isSelected: currentIndex == 1, onTap: () => onTap(1)),
            _NavItem(icon: 'map', label: 'MAP', isSelected: currentIndex == 2, onTap: () => onTap(2)),
            _NavItem(icon: 'users', label: 'SOCIAL', isSelected: currentIndex == 3, onTap: () => onTap(3)),
            _NavItem(icon: 'user', label: 'PROFILE', isSelected: currentIndex == 4, onTap: () => onTap(4)),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? ComicColors.yellow.withValues(alpha: 0.14) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            XoIcon(
              icon,
              color: isSelected ? ComicColors.yellow : ComicColors.navMuted,
              size: 23,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 10,
                color: isSelected ? ComicColors.yellow : ComicColors.navMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
