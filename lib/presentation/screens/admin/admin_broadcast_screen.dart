import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_show_app/core/theme/app_theme.dart';
import 'package:game_show_app/presentation/widgets/common/xo_snackbar.dart';

class AdminBroadcastScreen extends ConsumerWidget {
  const AdminBroadcastScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإرسال الجماعي'),
        backgroundColor: AppColors.red,
      ),
      body: const _BroadcastForm(),
    );
  }
}

class _BroadcastForm extends StatefulWidget {
  const _BroadcastForm();

  @override
  State<_BroadcastForm> createState() => _BroadcastFormState();
}

class _BroadcastFormState extends State<_BroadcastForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _sendNotification() {
    if (!_formKey.currentState!.validate()) return;

    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الإرسال'),
        content: const Text('هل أنت متأكد من إرسال الإشعار لجميع المستخدمين؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('إرسال'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (!mounted) return;
      if (confirmed == true) {
        XoSnackbar.success(context, 'تم إرسال الإشعار بنجاح');
        _titleController.clear();
        _messageController.clear();
        _imageUrlController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'العنوان'),
              validator: (v) => (v == null || v.isEmpty) ? 'الرجاء إدخال العنوان' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _messageController,
              decoration: const InputDecoration(labelText: 'الرسالة'),
              maxLines: 5,
              validator: (v) => (v == null || v.isEmpty) ? 'الرجاء إدخال الرسالة' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'رابط الصورة (اختياري)'),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _sendNotification,
              icon: const Icon(Icons.send),
              label: const Text('إرسال الإشعار للجميع'),
            ),
          ],
        ),
      ),
    );
  }
}
