import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: ComicColors.white,
        border: Border(top: BorderSide(color: ComicColors.black, width: 3)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(icon: Icons.home_rounded, label: 'HOME', isSelected: currentIndex == 0, onTap: () => onTap(0)),
            _NavItem(icon: Icons.leaderboard_rounded, label: 'RANKS', isSelected: currentIndex == 1, onTap: () => onTap(1)),
            _NavItem(icon: Icons.map_rounded, label: 'MAP', isSelected: currentIndex == 2, onTap: () => onTap(2)),
            _NavItem(icon: Icons.people_alt_rounded, label: 'SOCIAL', isSelected: currentIndex == 3, onTap: () => onTap(3)),
            _NavItem(icon: Icons.person_rounded, label: 'PROFILE', isSelected: currentIndex == 4, onTap: () => onTap(4)),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
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
        curve: Curves.easeOutBack,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? ComicColors.yellow : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: ComicColors.black, width: 2.5) : Border.all(color: Colors.transparent, width: 2.5),
          boxShadow: isSelected ? const [BoxShadow(color: ComicColors.black, offset: Offset(3, 3), blurRadius: 0)] : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? ComicColors.black : Colors.black45, size: isSelected ? 28 : 24),
            if (isSelected) ...[
              const SizedBox(height: 2),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10, color: ComicColors.black)),
            ]
          ],
        ),
      ),
    );
  }
}
