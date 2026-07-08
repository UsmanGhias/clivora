import 'package:flutter/material.dart';

import '../../core/theme/clivora_colors.dart';

class FilterChipRow extends StatelessWidget {
  const FilterChipRow({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = option == selected;
          return GestureDetector(
            onTap: () => onSelected(option),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? ClivoraColors.primaryPurple.withValues(alpha: 0.08)
                    : ClivoraColors.chipBackground,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected
                      ? ClivoraColors.primaryPurple
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Text(
                _label(option),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? ClivoraColors.primaryPurple
                      : ClivoraColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _label(String key) {
    switch (key) {
      case 'all':
        return 'All';
      case 'not_started':
        return 'Not Started';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'draft':
        return 'Draft';
      case 'sent':
        return 'Sent';
      case 'paid':
        return 'Paid';
      case 'overdue':
        return 'Overdue';
      case 'outstanding':
        return 'Outstanding';
      case 'pending':
        return 'Pending';
      default:
        return key[0].toUpperCase() + key.substring(1);
    }
  }
}
