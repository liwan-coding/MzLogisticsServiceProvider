import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/notifications/presentation/notifications_screen.dart';
import '../../shared/providers/session_provider.dart';
import '../l10n/locale_controller.dart';
import '../router/app_router.dart';
import 'push_notifications.dart';

final pushCoordinatorProvider = Provider<void>((ref) {
  PushNotifications.bindRouter(ref.watch(routerProvider));
  PushNotifications.onForeground = () {
    try {
      ref.invalidate(notificationsProvider);
    } catch (_) {}
  };
  ref.onDispose(() => PushNotifications.onForeground = null);

  String locale() => ref.read(localeControllerProvider).languageCode;

  void sync(bool authenticated) {
    PushNotifications.setNavigationEnabled(authenticated);
    if (authenticated) {
      unawaited(PushNotifications.register(ref.read(apiClientProvider), locale()));
    }
  }

  ref.listen(sessionProvider, (previous, next) {
    sync(next.isAuthenticated);
  });
  ref.listen(localeControllerProvider, (previous, next) {
    if (!ref.read(sessionProvider).isAuthenticated) return;
    if (previous?.languageCode == next.languageCode) return;
    unawaited(
      PushNotifications.register(ref.read(apiClientProvider), next.languageCode),
    );
  });

  if (ref.read(sessionProvider).isAuthenticated) {
    unawaited(Future<void>.microtask(() => sync(true)));
  }
});
