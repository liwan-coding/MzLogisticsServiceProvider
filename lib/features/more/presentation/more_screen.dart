import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/session_provider.dart';
import '../../../shared/widgets/app_page.dart';
import '../../../shared/widgets/app_shell.dart';
import '../../../shared/widgets/confirm_dialog.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final items = visibleDestinations(session);
    final sections = NavSection.values
        .map((section) => (section: section, items: items.where((item) => item.section == section).toList()))
        .where((group) => group.items.isNotEmpty)
        .toList();
    final organization = session.user?.organization?.name?.trim() ?? '';
    final rtl = Directionality.of(context) == TextDirection.rtl;

    return AppPage(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppColors.radius),
              border: Border.all(color: AppColors.border),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppColors.radius - 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var index = 0; index < sections.length; index++) ...[
                    if (index > 0) const Divider(height: 1, color: AppColors.border),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
                      child: Text(
                        rtl
                            ? context.tr(navSectionLabel(sections[index].section))
                            : context.tr(navSectionLabel(sections[index].section)).toUpperCase(),
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: rtl ? 0 : 0.6,
                          height: 1.3,
                        ),
                      ),
                    ),
                    for (final item in sections[index].items)
                      _MoreRow(
                        icon: item.icon,
                        label: context.tr(item.labelKey),
                        onTap: () => context.go(item.path),
                      ),
                    const SizedBox(height: 6),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: () async {
                final confirmed = await showConfirmDialog(
                  context,
                  message: context.tr('common.logoutConfirm'),
                  confirmLabel: context.tr('nav.logout'),
                );
                if (confirmed && context.mounted) {
                  await ref.read(sessionProvider.notifier).logout();
                }
              },
              icon: const Icon(Icons.logout, size: 18),
              label: Text(context.tr('nav.logout')),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.muted,
                minimumSize: const Size(44, 44),
              ),
            ),
          ),
          if (organization.isNotEmpty)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 16, end: 16, bottom: 8),
              child: Text(
                organization,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.muted, fontSize: 12, height: 1.3),
              ),
            ),
        ],
      ),
    );
  }
}

class _MoreRow extends StatelessWidget {
  const _MoreRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.teal800),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
