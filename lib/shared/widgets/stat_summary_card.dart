import 'package:flutter/material.dart';

import '../../core/theme/clivora_colors.dart';

class StatSummaryCard extends StatelessWidget {
  const StatSummaryCard({
    super.key,
    required this.items,
  });

  final List<StatItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.light
              ? ClivoraColors.borderLight
              : ClivoraColors.darkBorder,
        ),
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0)
              Container(
                width: 1,
                height: 40,
                color: ClivoraColors.borderLight,
              ),
            Expanded(child: _StatColumn(item: items[i])),
          ],
        ],
      ),
    );
  }
}

class StatItem {
  const StatItem({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.item});

  final StatItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          item.value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: item.valueColor,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          item.label.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
