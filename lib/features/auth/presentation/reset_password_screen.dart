import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key, required this.email});

  final String email;

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _email;
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();
  var _loading = false;
  var _resending = false;
  var _updated = false;
  String? _error;
  String? _notice;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    _password.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  String get _address => _email.text.trim();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _loading) return;
    setState(() {
      _loading = true;
      _error = null;
      _notice = null;
    });
    try {
      await ref.read(authRepositoryProvider).resetPassword(
            email: _address,
            code: _code.text.trim(),
            password: _password.text,
            passwordConfirmation: _confirmation.text,
          );
      if (!mounted) return;
      setState(() => _updated = true);
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() => _error = _message(error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resend() async {
    if (_resending || _address.isEmpty) return;
    setState(() {
      _resending = true;
      _error = null;
      _notice = null;
    });
    try {
      await ref.read(authRepositoryProvider).forgotPassword(_address);
      if (!mounted) return;
      setState(() => _notice = context.tr('auth.codeResent'));
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() => _error = _message(error));
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  String _message(ApiException error) {
    if (error.message == 'network') return context.tr('common.networkError');
    if (error.statusCode == 429) return context.tr('auth.tooManyAttempts');
    return error.firstFieldError('code') ?? error.firstFieldError('password') ?? error.message;
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: _updated ? _success() : _form(),
    );
  }

  Widget _success() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('auth.resetTitle'),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Text(context.tr('auth.passwordUpdated'), style: const TextStyle(color: AppColors.success)),
        const SizedBox(height: 20),
        AppButton(
          label: context.tr('auth.signIn'),
          onPressed: () => context.go('/login'),
          expanded: true,
          amber: true,
        ),
      ],
    );
  }

  Widget _form() {
    final subtitle = _address.isEmpty
        ? context.tr('auth.forgotSubtitle')
        : context.tr('auth.resetSubtitle', {'email': _address});

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('auth.resetTitle'),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: AppColors.muted)),
          const SizedBox(height: 24),
          if (widget.email.trim().isEmpty) ...[
            AppTextField(
              label: context.tr('auth.email'),
              controller: _email,
              required: true,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => AppValidators.email(value, context.tr('validation.email')),
            ),
            const SizedBox(height: 14),
          ],
          AppTextField(
            label: context.tr('auth.code'),
            controller: _code,
            required: true,
            keyboardType: TextInputType.number,
            textDirection: TextDirection.ltr,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            validator: (value) {
              if ((value ?? '').trim().length != 6) return context.tr('auth.codeInvalid');
              return null;
            },
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: context.tr('auth.password'),
            controller: _password,
            required: true,
            obscureText: true,
            validator: (value) => AppValidators.password(value, context.tr('validation.passwordLength')),
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: context.tr('auth.confirmPassword'),
            controller: _confirmation,
            required: true,
            obscureText: true,
            validator: (value) => AppValidators.match(value, _password.text, context.tr('validation.passwordMatch')),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: AppColors.danger)),
          ],
          if (_notice != null) ...[
            const SizedBox(height: 12),
            Text(_notice!, style: const TextStyle(color: AppColors.success)),
          ],
          const SizedBox(height: 20),
          AppButton(
            label: _loading ? context.tr('auth.savingPassword') : context.tr('auth.savePassword'),
            onPressed: _loading ? null : _submit,
            loading: _loading,
            expanded: true,
            amber: true,
          ),
          const SizedBox(height: 8),
          AppButton(
            label: _resending ? context.tr('auth.sendingCode') : context.tr('auth.resendCode'),
            onPressed: _resending ? null : _resend,
            expanded: true,
            outlined: true,
          ),
          TextButton(
            onPressed: () => context.canPop() ? context.pop() : context.go('/forgot-password'),
            child: Text(context.tr('auth.useDifferentEmail')),
          ),
        ],
      ),
    );
  }
}
