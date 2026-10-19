import '../../core/utils/json_utils.dart';

class AppNotification {
  const AppNotification({
    required this.id,
    this.type,
    this.title,
    this.body,
    this.titleAr,
    this.titleEn,
    this.bodyAr,
    this.bodyEn,
    this.targetType,
    this.targetId,
    this.readAt,
    this.createdAt,
  });

  final String id;
  final String? type;
  final String? title;
  final String? body;
  final String? titleAr;
  final String? titleEn;
  final String? bodyAr;
  final String? bodyEn;
  final String? targetType;
  final String? targetId;
  final String? readAt;
  final String? createdAt;

  bool get isUnread => readAt == null || readAt!.isEmpty;

  String textTitle(String languageCode) {
    if (languageCode == 'en') {
      return titleEn ?? title ?? '';
    }
    return titleAr ?? title ?? '';
  }

  String textBody(String languageCode) {
    if (languageCode == 'en') {
      return bodyEn ?? body ?? '';
    }
    return bodyAr ?? body ?? '';
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final data = asMap(json['data']);
    return AppNotification(
      id: asString(json['id']) ?? '',
      type: asString(json['type']),
      title: asString(data['title']) ?? asString(json['title']) ?? asString(json['type']),
      body: asString(data['body']) ?? asString(data['message']) ?? asString(json['message']),
      titleAr: asString(data['title_ar']),
      titleEn: asString(data['title_en']),
      bodyAr: asString(data['body_ar']),
      bodyEn: asString(data['body_en']),
      targetType: asString(data['target_type']),
      targetId: asString(data['target_id']),
      readAt: asString(json['read_at']),
      createdAt: asString(json['created_at']),
    );
  }
}
