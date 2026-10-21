import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/providers/session_provider.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import 'auth_scaffold.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  var _loading = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _loading) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final email = _email.text.trim();
      await ref.read(authRepositoryProvider).forgotPassword(email);
      if (!mounted) return;
      context.push('/reset-password?email=${Uri.encodeQueryComponent(email)}');
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() => _error = _message(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _message(ApiException error) {
    if (error.message == 'network') return context.tr('common.networkError');
    if (error.statusCode == 429) return context.tr('auth.tooManyAttempts');
    return error.message;
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('auth.forgotPassword'),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(context.tr('auth.forgotSubtitle'), style: const TextStyle(color: AppColors.muted)),
            const SizedBox(height: 24),
            AppTextField(
              label: context.tr('auth.email'),
              controller: _email,
              required: true,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => AppValidators.email(value, context.tr('validation.email')),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: AppColors.danger)),
            ],
            const SizedBox(height: 20),
            AppButton(
              label: _loading ? context.tr('auth.sendingCode') : context.tr('auth.sendCode'),
              onPressed: _loading ? null : _submit,
              loading: _loading,
              expanded: true,
              amber: true,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go('/login'),
              child: Text(context.tr('auth.loginCta')),
            ),
          ],
        ),
      ),
    );
  }
}
