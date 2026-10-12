import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/providers/session_provider.dart';
import '../../../core/theme/page_visuals.dart';
import '../../../shared/widgets/app_page.dart';
import '../../../shared/widgets/entity_card.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/async_body.dart';
import '../../../shared/widgets/filter_bar.dart';
import '../../../shared/widgets/page_header.dart';

final notificationStatusProvider = StateProvider<String?>((ref) => null);
final notificationsProvider = FutureProvider.autoDispose((ref) {
  return ref
      .watch(notificationRepositoryProvider)
      .list(status: ref.watch(notificationStatusProvider));
});

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;
    return AppPage(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageHeader(
            title: context.tr('notifications.title'),
            actions: [
              AppButton(
                label: context.tr('common.markAllRead'),
                outlined: true,
                onPressed: () async {
                  await ref.read(notificationRepositoryProvider).markAllRead();
                  ref.invalidate(notificationsProvider);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          FilterBar(
            children: [
              FilterSelect(
                options: const ['unread', 'read'],
                value: ref.watch(notificationStatusProvider),
                onChanged: (value) =>
                    ref.read(notificationStatusProvider.notifier).state = value,
                labelOf: (value) => context.tr('notifications.$value'),
              ),
            ],
          ),
          AsyncBody(
            value: ref.watch(notificationsProvider),
            onRetry: () => ref.invalidate(notificationsProvider),
            isEmpty: (data) => data.isEmpty,
            empty: EmptyState(
              message: context.tr('notifications.empty'),
              icon: Icons.notifications_outlined,
            ),
            builder: (data) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var index = 0; index < data.items.length; index++) ...[
                    if (index > 0) const SizedBox(height: 10),
                    EntityCard(
                      title: data.items[index].title ?? context.tr('notifications.title'),
                      subtitle: data.items[index].body,
                      icon: data.items[index].isUnread
                          ? Icons.notifications_active_rounded
                          : Icons.notifications_outlined,
                      tone: data.items[index].isUnread ? IconTone.coral : IconTone.muted,
                      facts: [
                        EntityFact(
                          icon: Icons.schedule_outlined,
                          label: context.tr('common.createdAt'),
                          value: Formatters.dateTime(data.items[index].createdAt, locale: locale),
                        ),
                      ],
                      onTap: data.items[index].isUnread
                          ? () async {
                              await ref.read(notificationRepositoryProvider).markRead(data.items[index].id);
                              ref.invalidate(notificationsProvider);
                            }
                          : null,
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
