import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:game_show_app/core/theme/app_theme.dart';
import 'package:game_show_app/core/infrastructure/theme_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingPageData(
      icon: Icons.casino_outlined,
      title: 'مرحباً بك في كازينو الألعاب',
      description: 'استماع بتجربة ألعاب تفاعلية مثيرة مع تحديات ومسابقات تنافسية',
      color: AppColors.yellow,
    ),
    _OnboardingPageData(
      icon: Icons.sports_esports_outlined,
      title: 'اختر وضع لعبك',
      description: 'كلاسيك، سباق، بقاء، مبارزة، أو مواجهة الزعماء - اختر ما يناسب أسلوبك',
      color: AppColors.teal,
    ),
    _OnboardingPageData(
      icon: Icons.people_outline,
      title: 'العب مع أصدقائك',
      description: 'تحدى أصدقاءك في غرف خاصة وتنافس على صدارة المتصدرين',
      color: AppColors.purple,
    ),
    _OnboardingPageData(
      icon: Icons.emoji_events_outlined,
      title: 'هل أنت مستعد؟',
      description: 'انطلق في مغامرة مليئة بالتحديات والمكافآت. ارتقِ بالمستوى واجمع الإنجازات',
      color: AppColors.orange,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    await ref.read(localStorageProvider).setOnboardingDone(true);
    if (mounted) context.go('/home');
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: 500.ms,
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _Header(skipEnabled: _currentPage < _pages.length - 1, onSkip: _completeOnboarding),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _PageContent(
                    icon: page.icon,
                    title: page.title,
                    description: page.description,
                    color: page.color,
                  ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideX(
                    begin: 0.1,
                    end: 0,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  );
                },
              ),
            ),
            _Footer(
              currentPage: _currentPage,
              totalPages: _pages.length,
              isLastPage: _currentPage == _pages.length - 1,
              onNext: _nextPage,
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _OnboardingPageData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

class _Header extends StatelessWidget {
  final bool skipEnabled;
  final VoidCallback onSkip;

  const _Header({required this.skipEnabled, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'كازينو الألعاب',
            style: TextStyle(
              color: AppColors.yellow.withValues(alpha: 0.6),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (skipEnabled)
            TextButton(
              onPressed: onSkip,
              child: const Text(
                'تخطي',
                style: TextStyle(color: AppColors.grey, fontSize: 15),
              ),
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _PageContent extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _PageContent({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
            ),
            child: Icon(icon, size: 64, color: color),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withValues(alpha: 0.7),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final bool isLastPage;
  final VoidCallback onNext;

  const _Footer({
    required this.currentPage,
    required this.totalPages,
    required this.isLastPage,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              totalPages,
              (index) => _Dot(isActive: index == currentPage),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellow,
                foregroundColor: AppColors.outline,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              child: Text(isLastPage ? 'ابدأ' : 'التالي'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool isActive;

  const _Dot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 300.ms,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 10,
      height: 10,
      decoration: BoxDecoration(
        color: isActive ? AppColors.yellow : AppColors.grey.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
