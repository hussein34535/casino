import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:game_show_app/core/design/xo_design.dart';
import 'package:game_show_app/core/design/xo_icon.dart';
import 'package:game_show_app/core/design/xo_widgets.dart';
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
      if (mounted) showXoSnack(context, 'خطأ في تسجيل الدخول: $e', error: true);
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
      if (mounted) showXoSnack(context, 'فشل تسجيل الدخول عبر Google ($e)', error: true);
    }
    ref.read(authLoadingProvider.notifier).state = false;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authLoadingProvider);

    return XoScaffold(
      title: 'تسجيل الدخول',
      titleIcon: 'logIn',
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: XoCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: XoDesign.indigoGradient,
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: XoDesign.glowShadow(
                            XoDesign.indigo.withValues(alpha: 0.4)),
                      ),
                      child: const XoIcon('gamepad2', size: 44, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('مرحباً بعودتك!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w900, color: XoDesign.ink)),
                  const SizedBox(height: 4),
                  Text('سجل الدخول للعب مع أصدقائك أونلاين',
                      textAlign: TextAlign.center,
                      style: XoDesign.caption.copyWith(color: XoDesign.muted)),
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
                          color: XoDesign.muted),
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
                              fontWeight: FontWeight.w800, color: XoDesign.rose)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  XoButton(
                    label: 'دخول',
                    icon: 'zap',
                    loading: isLoading,
                    onTap: _signIn,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      const Expanded(child: Divider(color: Color(0xFFE2E4EF))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text('أو',
                            style: XoDesign.caption.copyWith(color: XoDesign.muted)),
                      ),
                      const Expanded(child: Divider(color: Color(0xFFE2E4EF))),
                    ],
                  ),
                  const SizedBox(height: 18),
                  XoCard(
                    onTap: isLoading ? null : _signInWithGoogle,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/google.svg', width: 24, height: 24),
                        const SizedBox(width: 10),
                        const Text('دخول باستخدام Google',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: XoDesign.ink)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ليس لديك حساب؟',
                          style: XoDesign.caption.copyWith(color: XoDesign.muted)),
                      TextButton(
                        onPressed: () => context.push('/signup'),
                        child: const Text('إنشاء حساب',
                            style: TextStyle(
                                fontWeight: FontWeight.w900, color: XoDesign.indigo)),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.05, end: 0),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
                  style: XoDesign.caption.copyWith(color: XoDesign.muted)),
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
                            fontWeight: FontWeight.w800, color: XoDesign.muted)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: XoButton.indigo(
                      label: 'إرسال',
                      icon: 'logIn',
                      onTap: () async {
                        final email = emailController.text.trim();
                        if (email.isEmpty || !email.contains('@')) return;
                        try {
                          await ref
                              .read(authRepositoryProvider)
                              .sendPasswordResetEmail(email);
                          if (ctx.mounted) {
                            Navigator.pop(ctx);
                            showXoSnack(
                                context, 'تم إرسال رابط إعادة التعيين لبريدك');
                          }
                        } catch (e) {
                          if (ctx.mounted) {
                            showXoSnack(context, 'فشل الإرسال: $e', error: true);
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
