import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:game_show_app/core/widgets/premium_widgets.dart';
import 'package:game_show_app/presentation/providers/auth_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authLoadingProvider);

    return Scaffold(
      backgroundColor: ComicColors.cream,
      appBar: AppBar(
        backgroundColor: ComicColors.blue,
        elevation: 0,
        title: const Text('🔑 تسجيل الدخول', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 20)),
        shape: const Border(bottom: BorderSide(color: ComicColors.black, width: 2)),
      ),
      body: ComicBackground(
        bgColor: ComicColors.cream,
        dotColor: ComicColors.blue,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: ComicCard(
                color: Colors.white,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🎮', style: TextStyle(fontSize: 64)),
                    const SizedBox(height: 12),
                    const Text('مرحباً بعودتك!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: ComicColors.black)),
                    const SizedBox(height: 4),
                    const Text('سجل الدخول للعب مع أصدقائك أونلاين', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black54)),
                    const SizedBox(height: 32),
                    _buildTextField(
                      controller: _emailController,
                      label: 'البريد الإلكتروني',
                      icon: Icons.email_rounded,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'يرجى إدخال البريد الإلكتروني';
                        if (!v.contains('@')) return 'بريد إلكتروني غير صالح';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _passwordController,
                      label: 'كلمة المرور',
                      icon: Icons.lock_rounded,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: ComicColors.black),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'أدخل كلمة المرور';
                        if (v.length < 6) return 'كلمة المرور قصيرة جداً';
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () => _showForgotPasswordDialog(context),
                        child: const Text('نسيت كلمة المرور؟', style: TextStyle(fontWeight: FontWeight.w900, color: ComicColors.red)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (isLoading)
                      const Center(child: CircularProgressIndicator(color: ComicColors.blue))
                    else
                      ComicButton(
                        label: '🚀 دخول',
                        color: ComicColors.yellow,
                        onTap: _signIn,
                      ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(child: Divider(color: ComicColors.black, thickness: 1.5)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('أو', style: TextStyle(fontWeight: FontWeight.w900, color: ComicColors.grey)),
                        ),
                        const Expanded(child: Divider(color: ComicColors.black, thickness: 1.5)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ComicButton(
                      label: 'دخول باستخدام Google',
                      leading: SvgPicture.asset(
                        'assets/icons/google.svg',
                        width: 24,
                        height: 24,
                      ),
                      color: Colors.white,
                      textColor: ComicColors.black,
                      onTap: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        final router = GoRouter.of(context);
                        ref.read(authLoadingProvider.notifier).state = true;
                        try {
                          await ref.read(authRepositoryProvider).signInWithGoogle();
                          if (mounted) router.go('/home');
                        } catch (e) {
                          if (mounted) {
                            messenger.showSnackBar(
                              const SnackBar(content: Text('فشل تسجيل الدخول عبر Google'), backgroundColor: ComicColors.red),
                            );
                          }
                        }
                        ref.read(authLoadingProvider.notifier).state = false;
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('ليس لديك حساب؟', style: TextStyle(fontWeight: FontWeight.w700)),
                        TextButton(
                          onPressed: () => context.push('/signup'),
                          child: const Text('إنشاء حساب', style: TextStyle(fontWeight: FontWeight.w900, color: ComicColors.blue)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(fontWeight: FontWeight.w900, color: ComicColors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontWeight: FontWeight.w900, color: Colors.black54),
        prefixIcon: Icon(icon, color: ComicColors.black),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: ComicColors.cream,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ComicColors.black, width: 2)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ComicColors.black, width: 2)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ComicColors.blue, width: 2.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ComicColors.red, width: 2)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: ComicColors.red, width: 2.5)),
      ),
      validator: validator,
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ComicColors.cream,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: ComicColors.black, width: 2)),
        title: const Text('🔐 إعادة تعيين كلمة المرور', style: TextStyle(fontWeight: FontWeight.w900, color: ComicColors.black)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('أدخل بريدك الإلكتروني وسنرسل لك رابط لإعادة التعيين', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            _buildTextField(
              controller: emailController,
              label: 'البريد الإلكتروني',
              icon: Icons.email_rounded,
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ComicColors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: ComicColors.black, width: 2))
            ),
            onPressed: () async {
              final email = emailController.text.trim();
              if (email.isEmpty || !email.contains('@')) return;
              try {
                await ref.read(authRepositoryProvider).sendPasswordResetEmail(email);
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✅ تم إرسال رابط إعادة التعيين لبريدك'), backgroundColor: ComicColors.green),
                  );
                }
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('فشل الإرسال: $e'), backgroundColor: ComicColors.red),
                  );
                }
              }
            },
            child: const Text('إرسال', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
          ),
        ],
      ),
    );
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في تسجيل الدخول: $e'), backgroundColor: ComicColors.red),
        );
      }
    }
    ref.read(authLoadingProvider.notifier).state = false;
  }
}
