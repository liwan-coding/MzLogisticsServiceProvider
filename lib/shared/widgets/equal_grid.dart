import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Lays tiles in equal columns. Tiles in the same row share a height, and a
/// short last row keeps the same tile width instead of stretching leftovers.
class EqualGrid extends StatelessWidget {
  const EqualGrid({
    super.key,
    required this.children,
    this.minItemWidth = 220,
    this.gap = 16,
    this.maxColumns,
  });

  final List<Widget> children;
  final double minItemWidth;
  final double gap;
  final int? maxColumns;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (!width.isFinite || width <= 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var index = 0; index < children.length; index++) ...[
                if (index > 0) SizedBox(height: gap),
                children[index],
              ],
            ],
          );
        }
        var columns = math.max(1, (width / minItemWidth).floor());
        if (maxColumns != null) {
          columns = math.min(columns, maxColumns!);
        }
        columns = math.min(columns, children.length);
        final rows = <Widget>[];
        for (var index = 0; index < children.length; index += columns) {
          final end = math.min(index + columns, children.length);
          if (rows.isNotEmpty) {
            rows.add(SizedBox(height: gap));
          }
          final rowStart = index;
          rows.add(
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var slot = 0; slot < columns; slot++) ...[
                    if (slot > 0) SizedBox(width: gap),
                    Expanded(
                      child: rowStart + slot < end
                          ? children[rowStart + slot]
                          : const SizedBox.shrink(),
                    ),
                  ],
                ],
              ),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: rows,
        );
      },
    );
  }
}
