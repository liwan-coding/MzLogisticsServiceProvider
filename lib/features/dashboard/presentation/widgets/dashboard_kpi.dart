import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/page_visuals.dart';
import '../../../../shared/widgets/equal_grid.dart';
import '../../../../shared/widgets/icon_well.dart';

enum DashboardKpiTone { neutral, info, warning, success, danger }

class DashboardKpi {
  const DashboardKpi({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
    this.hint,
    this.tone = DashboardKpiTone.neutral,
  });

  final String label;
  final String value;
  final String? hint;
  final IconData icon;
  final VoidCallback onTap;
  final DashboardKpiTone tone;
}

class DashboardAttentionItem {
  const DashboardAttentionItem({
    required this.label,
    required this.count,
    required this.icon,
    required this.tone,
    required this.viewLabel,
    required this.onTap,
  });

  final String label;
  final String count;
  final IconData icon;
  final DashboardKpiTone tone;
  final String viewLabel;
  final VoidCallback onTap;
}

class DashboardQuickLink {
  const DashboardQuickLink({
    required this.title,
    required this.hint,
    required this.icon,
    required this.tone,
    required this.onTap,
  });

  final String title;
  final String hint;
  final IconData icon;
  final IconTone tone;
  final VoidCallback onTap;
}

class DashboardSection extends StatelessWidget {
  const DashboardSection({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: dashboardPanelDecoration,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
                color: AppColors.ink,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class DashboardKpiGrid extends StatelessWidget {
  const DashboardKpiGrid({super.key, required this.metrics});

  final List<DashboardKpi> metrics;

  @override
  Widget build(BuildContext context) {
    return EqualGrid(
      minItemWidth: 220,
      children: [for (final metric in metrics) _KpiTile(metric: metric)],
    );
  }
}

class DashboardAttentionList extends StatelessWidget {
  const DashboardAttentionList({super.key, required this.items});

  final List<DashboardAttentionItem> items;

  @override
  Widget build(BuildContext context) {
    return EqualGrid(
      minItemWidth: 220,
      children: [for (final item in items) _AttentionTile(item: item)],
    );
  }
}

class DashboardQuickLinkGrid extends StatelessWidget {
  const DashboardQuickLinkGrid({super.key, required this.links});

  final List<DashboardQuickLink> links;

  @override
  Widget build(BuildContext context) {
    return EqualGrid(
      minItemWidth: 220,
      children: [for (final link in links) _QuickLinkTile(link: link)],
    );
  }
}

class _KpiTile extends StatelessWidget {
  const _KpiTile({required this.metric});

  final DashboardKpi metric;

  @override
  Widget build(BuildContext context) {
    final colors = _toneColors(metric.tone);
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return _DashboardCard(
      onTap: metric.onTap,
      radius: AppColors.radius,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppColors.radius),
        border: Border.all(color: AppColors.border),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 148),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(18, 16, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconWell(
                        icon: metric.icon,
                        tone: colors.iconTone,
                        size: IconWellSize.md,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          metric.label,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      metric.value,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        height: 1.15,
                        letterSpacing: rtl ? 0 : -0.4,
                        color: AppColors.ink,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    metric.hint ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            PositionedDirectional(
              start: 0,
              top: 0,
              bottom: 0,
              width: 4,
              child: ColoredBox(color: colors.accent),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttentionTile extends StatelessWidget {
  const _AttentionTile({required this.item});

  final DashboardAttentionItem item;

  @override
  Widget build(BuildContext context) {
    final colors = _toneColors(item.tone);
    return _DashboardCard(
      onTap: item.onTap,
      radius: AppColors.radius,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppColors.radius),
        border: Border.all(color: AppColors.border),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 84),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 14, 12),
              child: Row(
                children: [
                  IconWell(
                    icon: item.icon,
                    tone: colors.iconTone,
                    size: IconWellSize.md,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.label,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.viewLabel,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.muted,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.pill,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      item.count,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: colors.icon,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            PositionedDirectional(
              start: 0,
              top: 0,
              bottom: 0,
              width: 4,
              child: ColoredBox(color: colors.accent),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickLinkTile extends StatelessWidget {
  const _QuickLinkTile({required this.link});

  final DashboardQuickLink link;

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      onTap: link.onTap,
      radius: AppColors.radius,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppColors.radius),
        border: Border.all(color: AppColors.border),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 92),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              IconWell(icon: link.icon, tone: link.tone, size: IconWellSize.lg),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      link.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      link.hint,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.muted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatefulWidget {
  const _DashboardCard({
    required this.onTap,
    required this.radius,
    required this.decoration,
    required this.child,
  });

  final VoidCallback onTap;
  final double radius;
  final BoxDecoration decoration;
  final Widget child;

  @override
  State<_DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<_DashboardCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final lifted = _hovered && !reduceMotion;
    final radius = BorderRadius.circular(widget.radius);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: Duration(milliseconds: reduceMotion ? 0 : 180),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, lifted ? -2 : 0, 0),
        transformAlignment: Alignment.center,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: radius,
            hoverColor: Colors.transparent,
            splashColor: AppColors.rowHover,
            child: Ink(
              decoration: widget.decoration.copyWith(
                borderRadius: radius,
                border: Border.all(
                  color: _hovered ? AppColors.hoverBorder : AppColors.border,
                ),
                boxShadow: lifted ? dashboardCardHoverShadow : const [],
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

class _ToneColors {
  const _ToneColors({
    required this.background,
    required this.accent,
    required this.icon,
    required this.pill,
    required this.iconTone,
  });

  final Color background;
  final Color accent;
  final Color icon;
  final Color pill;
  final IconTone iconTone;
}

Color _toneWash(Color soft) {
  return Color.alphaBlend(soft.withValues(alpha: 0.72), AppColors.white);
}

_ToneColors _toneColors(DashboardKpiTone tone) {
  return switch (tone) {
    DashboardKpiTone.neutral => const _ToneColors(
      background: AppColors.surface,
      accent: AppColors.teal,
      icon: AppColors.teal800,
      pill: AppColors.chipBg,
      iconTone: IconTone.teal,
    ),
    DashboardKpiTone.info => _ToneColors(
      background: _toneWash(AppColors.infoSoft),
      accent: AppColors.info,
      icon: AppColors.info,
      pill: AppColors.infoSoft,
      iconTone: IconTone.info,
    ),
    DashboardKpiTone.warning => _ToneColors(
      background: _toneWash(AppColors.warningSoft),
      accent: AppColors.warning,
      icon: AppColors.warning,
      pill: AppColors.warningSoft,
      iconTone: IconTone.warning,
    ),
    DashboardKpiTone.success => _ToneColors(
      background: _toneWash(AppColors.successSoft),
      accent: AppColors.success,
      icon: AppColors.success,
      pill: AppColors.successSoft,
      iconTone: IconTone.success,
    ),
    DashboardKpiTone.danger => _ToneColors(
      background: _toneWash(AppColors.dangerSoft),
      accent: AppColors.danger,
      icon: AppColors.danger,
      pill: AppColors.dangerSoft,
      iconTone: IconTone.danger,
    ),
  };
}

const dashboardCardShadow = [
  BoxShadow(color: Color(0x0F142426), blurRadius: 2, offset: Offset(0, 1)),
  BoxShadow(color: Color(0x0F142426), blurRadius: 24, offset: Offset(0, 8)),
];

const dashboardCardHoverShadow = [
  BoxShadow(color: Color(0x1A142426), blurRadius: 22, offset: Offset(0, 10)),
];

const dashboardPanelDecoration = BoxDecoration(
  color: AppColors.white,
  borderRadius: BorderRadius.all(Radius.circular(AppColors.radius)),
  border: Border.fromBorderSide(BorderSide(color: AppColors.border)),
  boxShadow: dashboardCardShadow,
);

const dashboardSurfaceDecoration = BoxDecoration(
  color: AppColors.white,
  borderRadius: BorderRadius.all(Radius.circular(AppColors.radius)),
  border: Border.fromBorderSide(BorderSide(color: AppColors.border)),
  boxShadow: dashboardCardShadow,
);
