import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:game_show_app/core/design/xo_icon.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';
import 'package:game_show_app/presentation/providers/auth_provider.dart';
import 'package:game_show_app/presentation/screens/auth/widgets/xo_auth_field.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    ref.read(authLoadingProvider.notifier).state = true;
    try {
      await ref.read(authRepositoryProvider).signUpWithEmail(
            _emailController.text.trim(),
            _passwordController.text,
            _nameController.text.trim(),
          );
      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) showComicSnack(context, 'خطأ: $e', error: true);
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
        dotColor: ComicColors.orange,
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
                            color: ComicColors.green,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(color: ComicColors.black, width: 3),
                            boxShadow: const [
                              BoxShadow(
                                  color: ComicColors.black,
                                  offset: Offset(4, 4),
                                  blurRadius: 0),
                            ],
                          ),
                          child: const XoIcon('sparkles', size: 44, color: ComicColors.black),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('انضم إلينا!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: ComicColors.black)),
                      const SizedBox(height: 4),
                      Text('أنشئ حساباً وابدأ اللعب أونلاين',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: ComicColors.grey)),
                      const SizedBox(height: 28),
                      XoAuthField(
                        controller: _nameController,
                        label: 'الاسم',
                        prefix: Icons.person_rounded,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'أدخل اسمك';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      XoAuthField(
                        controller: _emailController,
                        label: 'البريد الإلكتروني',
                        prefix: Icons.email_rounded,
                        keyboard: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'أدخل البريد الإلكتروني';
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
                          if (v.length < 6) return 'كلمة المرور قصيرة (6 أحرف على الأقل)';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      XoAuthField(
                        controller: _confirmPasswordController,
                        label: 'تأكيد كلمة المرور',
                        prefix: Icons.lock_outline_rounded,
                        obscure: true,
                        validator: (v) {
                          if (v != _passwordController.text) {
                            return 'كلمة المرور غير متطابقة';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 26),
                      ComicButton(
                        label: isLoading ? 'جارٍ الإنشاء...' : 'إنشاء حساب',
                        icon: Icons.auto_awesome,
                        onTap: isLoading ? () {} : _signUp,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('لديك حساب بالفعل؟',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: ComicColors.grey)),
                          TextButton(
                            onPressed: () => context.pop(),
                            child: const Text('تسجيل الدخول',
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
}
