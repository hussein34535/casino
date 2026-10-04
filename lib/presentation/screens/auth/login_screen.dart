import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:game_show_app/core/design/xo_icon.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';
import 'package:game_show_app/presentation/providers/auth_provider.dart';
import 'package:game_show_app/presentation/screens/auth/widgets/xo_auth_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    ref.read(authLoadingProvider.notifier).state = true;
    try {
      await ref.read(authRepositoryProvider).signInWithEmail(
            _emailController.text.trim(),
            _passwordController.text,
          );
      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) showComicSnack(context, 'خطأ في تسجيل الدخول: $e', error: true);
    }
    ref.read(authLoadingProvider.notifier).state = false;
  }

  Future<void> _signInWithGoogle() async {
    ref.read(authLoadingProvider.notifier).state = true;
    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
      if (mounted) context.go('/home');
    } catch (e) {
      debugPrint('Google sign-in error: $e');
      if (mounted) {
        showComicSnack(context, 'فشل تسجيل الدخول عبر Google', error: true);
      }
    }
    ref.read(authLoadingProvider.notifier).state = false;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authLoadingProvider);

    return Scaffold(
      backgroundColor: ComicColors.cream,
      body: ComicBackground(
        bgColor: ComicColors.cream,
        dotColor: ComicColors.blue,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: ComicCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: ComicColors.yellow,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(color: ComicColors.black, width: 3),
                            boxShadow: const [
                              BoxShadow(
                                  color: ComicColors.black,
                                  offset: Offset(4, 4),
                                  blurRadius: 0),
                            ],
                          ),
                          child: const XoIcon('gamepad2', size: 44, color: ComicColors.black),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('مرحباً بعودتك!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: ComicColors.black)),
                      const SizedBox(height: 4),
                      Text('سجل الدخول للعب مع أصدقائك أونلاين',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: ComicColors.grey)),
                      const SizedBox(height: 28),
                      XoAuthField(
                        controller: _emailController,
                        label: 'البريد الإلكتروني',
                        prefix: Icons.email_rounded,
                        keyboard: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'يرجى إدخال البريد الإلكتروني';
                          if (!v.contains('@')) return 'بريد إلكتروني غير صالح';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      XoAuthField(
                        controller: _passwordController,
                        label: 'كلمة المرور',
                        prefix: Icons.lock_rounded,
                        obscure: _obscurePassword,
                        suffix: IconButton(
                          icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: ComicColors.grey),
                          onPressed: () =>
                              setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'أدخل كلمة المرور';
                          if (v.length < 6) return 'كلمة المرور قصيرة جداً';
                          return null;
                        },
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () => _showForgotPasswordDialog(context),
                          child: const Text('نسيت كلمة المرور؟',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: ComicColors.red)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ComicButton(
                        label: isLoading ? 'جارٍ الدخول...' : 'دخول',
                        onTap: isLoading ? () {} : _signIn,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          const Expanded(
                              child: Divider(color: ComicColors.black)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text('أو',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: ComicColors.grey)),
                          ),
                          const Expanded(
                              child: Divider(color: ComicColors.black)),
                        ],
                      ),
                      const SizedBox(height: 18),
                      ComicButton(
                        label: 'دخول باستخدام Google',
                        color: ComicColors.white,
                        leading:
                            SvgPicture.asset('assets/icons/google.svg', width: 24, height: 24),
                        onTap: isLoading ? () {} : _signInWithGoogle,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('ليس لديك حساب؟',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: ComicColors.grey)),
                          TextButton(
                            onPressed: () => context.push('/signup'),
                            child: const Text('إنشاء حساب',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: ComicColors.blue)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.05, end: 0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: ComicColors.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: ComicColors.black, width: 4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('إعادة تعيين كلمة المرور',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 19)),
              const SizedBox(height: 8),
              Text('أدخل بريدك الإلكتروني وسنرسل لك رابطاً لإعادة التعيين',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: ComicColors.grey)),
              const SizedBox(height: 18),
              XoAuthField(
                controller: emailController,
                label: 'البريد الإلكتروني',
                prefix: Icons.email_rounded,
                keyboard: TextInputType.emailAddress,
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('إلغاء',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: ComicColors.grey)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ComicButton(
                      label: 'إرسال',
                      color: ComicColors.blue,
                      textColor: Colors.white,
                      onTap: () async {
                        final email = emailController.text.trim();
                        if (email.isEmpty || !email.contains('@')) return;
                        try {
                          await ref
                              .read(authRepositoryProvider)
                              .sendPasswordResetEmail(email);
                          if (ctx.mounted) {
                            Navigator.pop(ctx);
                            showComicSnack(
                                context, 'تم إرسال رابط إعادة التعيين لبريدك');
                          }
                        } catch (e) {
                          if (ctx.mounted) {
                            showComicSnack(context, 'فشل الإرسال: $e', error: true);
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
