import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/breakpoints.dart';
import '../../core/theme/page_visuals.dart';
import 'equal_grid.dart';
import 'icon_well.dart';

class InfoField {
  const InfoField({
    required this.label,
    required this.value,
    this.icon,
    this.tone = IconTone.muted,
    this.wide = false,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData? icon;
  final IconTone tone;
  final bool wide;
  final VoidCallback? onTap;
}

class InfoGrid extends StatelessWidget {
  const InfoGrid({super.key, required this.fields});

  final List<InfoField> fields;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    final buffer = <InfoField>[];

    void flush() {
      if (buffer.isEmpty) {
        return;
      }
      if (rows.isNotEmpty) {
        rows.add(const SizedBox(height: 12));
      }
      rows.add(
        EqualGrid(
          minItemWidth: 200,
          gap: 12,
          children: [for (final field in buffer) _InfoCell(field: field)],
        ),
      );
      buffer.clear();
    }

    for (final field in fields) {
      if (field.wide) {
        flush();
        if (rows.isNotEmpty) {
          rows.add(const SizedBox(height: 12));
        }
        rows.add(_InfoCell(field: field));
      } else {
        buffer.add(field);
      }
    }
    flush();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}

class _InfoCell extends StatelessWidget {
  const _InfoCell({required this.field});

  final InfoField field;

  bool _isMostlyLtr(String value) {
    return RegExp(r'^[\x00-\x7F\-_/.:#→\s]+$').hasMatch(value.trim());
  }

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 76),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppColors.radius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (field.icon != null) ...[
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: field.tone.background,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Icon(field.icon, size: 14, color: field.tone.foreground),
                ),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(
                  field.label,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            field.value.isEmpty ? '—' : field.value,
            style: const TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 1.35,
            ),
            textDirection: _isMostlyLtr(field.value) ? TextDirection.ltr : null,
          ),
        ],
      ),
    );

    if (field.onTap == null) {
      return content;
    }
    return InkWell(
      onTap: field.onTap,
      borderRadius: BorderRadius.circular(AppColors.radius),
      child: content,
    );
  }
}

class DetailBackLink extends StatelessWidget {
  const DetailBackLink({super.key, required this.label, required this.path});

  final String label;
  final String path;

  @override
  Widget build(BuildContext context) {
    if (!Breakpoints.isDesktop(context)) {
      return const SizedBox.shrink();
    }
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: TextButton.icon(
        onPressed: () => context.go(path),
        icon: Icon(
          Directionality.of(context) == TextDirection.rtl ? Icons.arrow_forward : Icons.arrow_back,
          size: 18,
        ),
        label: Text(label),
      ),
    );
  }
}

class DetailHero extends StatelessWidget {
  const DetailHero({
    super.key,
    required this.title,
    required this.icon,
    this.tone = IconTone.teal,
    this.subtitle,
    this.chips = const [],
  });

  final String title;
  final IconData icon;
  final IconTone tone;
  final String? subtitle;
  final List<Widget> chips;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconWell(icon: icon, tone: tone, size: IconWellSize.lg),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.teal800,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
              if (chips.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(spacing: 8, runSpacing: 8, children: chips),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class DetailChip extends StatelessWidget {
  const DetailChip({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.tealSoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.teal800),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.teal800,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) {
      return child;
    }
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: child,
    );
  }
}

class ResponsiveSplit extends StatelessWidget {
  const ResponsiveSplit({
    super.key,
    required this.primary,
    required this.secondary,
    this.breakpoint = 960,
  });

  final Widget primary;
  final Widget secondary;
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < breakpoint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              primary,
              const SizedBox(height: 12),
              secondary,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 6, child: primary),
            const SizedBox(width: 12),
            Expanded(flex: 5, child: secondary),
          ],
        );
      },
    );
  }
}
