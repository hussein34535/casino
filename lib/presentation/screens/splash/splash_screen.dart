import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:game_show_app/core/infrastructure/theme_service.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';
import 'package:game_show_app/presentation/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Start both the animation delay and auth fetch simultaneously
    final minDelay = Future.delayed(const Duration(milliseconds: 3500));
    final userFuture = ref.read(authStateProvider.future);
    
    // Wait for the minimum splash screen duration
    await minDelay;
    if (!mounted) return;
    
    // Check onboarding
    final localStorage = ref.read(localStorageProvider);
    final isOnboardingDone = await localStorage.isOnboardingDone();
    if (!mounted) return;
    
    if (!isOnboardingDone) {
      context.go('/onboarding');
      return;
    }
    
    try {
      // Await the actual user value, this ensures we don't accidentally get 'null' 
      // just because the stream was still in an AsyncLoading state.
      final user = await userFuture;
      if (!mounted) return;
      
      if (user == null) {
        context.go('/login');
      } else {
        context.go('/home');
      }
    } catch (e) {
      if (!mounted) return;
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ComicColors.yellow,
      body: ComicBackground(
        bgColor: ComicColors.yellow,
        dotColor: ComicColors.orange,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Epic rotating starburst
              Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.star_rounded, size: 280, color: Colors.white.withValues(alpha: 0.3))
                      .animate(onPlay: (controller) => controller.repeat())
                      .rotate(duration: 5.seconds, curve: Curves.linear),
                  
                  // Epic Pure Flutter Comic Logo
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.rotate(
                        angle: -0.15,
                        child: _buildComicLetter('إكس', ComicColors.red),
                      ),
                      const SizedBox(width: 8),
                      Transform.rotate(
                        angle: 0.15,
                        child: _buildComicLetter('أوه', ComicColors.blue),
                      ),
                    ],
                  )
                  .animate()
                  .scale(begin: const Offset(4, 4), end: const Offset(1, 1), duration: 600.ms, curve: Curves.easeInBack) // Slam down
                  .then()
                  .shake(hz: 8, duration: 300.ms) // Impact shake
                  .shimmer(delay: 500.ms, duration: 1.seconds, color: Colors.white54), // Shine
                ],
              ),
              const SizedBox(height: 24),
              // "XO" Text sliding up
              const Text(
                'إكس أو',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: ComicColors.black,
                  letterSpacing: 2,
                ),
              )
              .animate()
              .fade(delay: 800.ms, duration: 400.ms)
              .slideY(begin: 1, end: 0, duration: 400.ms, curve: Curves.easeOutBack),

              const SizedBox(height: 48),
              
              // Loading indicator
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: ComicColors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: ComicColors.black, width: 2),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    color: ComicColors.red,
                    strokeWidth: 4,
                  ),
                ),
              )
              .animate()
              .fade(delay: 1500.ms)
              .scale(duration: 300.ms, curve: Curves.easeOutBack),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComicLetter(String letter, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ComicColors.black, width: 4),
        boxShadow: const [
          BoxShadow(color: ComicColors.black, offset: Offset(6, 6), blurRadius: 0),
        ],
      ),
      child: Text(
        letter,
        style: const TextStyle(
          fontSize: 60,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          height: 1.1,
        ),
      ),
    );
  }
}

