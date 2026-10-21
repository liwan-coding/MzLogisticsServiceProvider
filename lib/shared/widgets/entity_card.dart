import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/page_visuals.dart';
import 'icon_well.dart';

class EntityFact {
  const EntityFact({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

class EntityCard extends StatelessWidget {
  const EntityCard({
    super.key,
    required this.title,
    this.subtitle,
    this.meta = const [],
    this.facts = const [],
    this.icon,
    this.tone = IconTone.teal,
    this.trailing,
    this.footer,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final List<String> meta;
  final List<EntityFact> facts;
  final IconData? icon;
  final IconTone tone;
  final Widget? trailing;
  final Widget? footer;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final lines = [
      if (subtitle != null && subtitle!.trim().isNotEmpty) subtitle!.trim(),
      ...meta.map((line) => line.trim()).where(_hasText),
    ];
    final visibleFacts = [
      for (final fact in facts)
        if (_hasText(fact.value)) fact,
    ];

    final body = Padding(
      padding: EdgeInsets.fromLTRB(14, 14, 14, footer == null && visibleFacts.isEmpty ? 14 : 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                IconWell(icon: icon!, tone: tone, size: IconWellSize.sm),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 8), trailing!],
            ],
          ),
          if (lines.isNotEmpty) ...[
            const SizedBox(height: 8),
            for (final line in lines)
              Padding(
                padding: EdgeInsetsDirectional.only(start: icon == null ? 0 : 42, bottom: 2),
                child: Text(
                  line,
                  style: const TextStyle(
                    color: AppColors.muted,
                    height: 1.4,
                    fontSize: 13,
                  ),
                ),
              ),
          ],
          if (visibleFacts.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 6),
            for (final fact in visibleFacts) _FactRow(fact: fact),
          ],
        ],
      ),
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(onTap: onTap, child: body),
          if (footer != null) ...[
            const Divider(height: 1, color: AppColors.border),
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 2, 6, 4),
              child: footer,
            ),
          ],
        ],
      ),
    );
  }
}

class _FactRow extends StatelessWidget {
  const _FactRow({required this.fact});

  final EntityFact fact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.tealSoft,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(fact.icon, size: 14, color: AppColors.teal800),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: Text(
              fact.label,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 13,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 7,
            child: Text(
              fact.value.trim(),
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 13,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

bool _hasText(String value) {
  final text = value.trim();
  return text.isNotEmpty && text != '—' && text != '-';
}
