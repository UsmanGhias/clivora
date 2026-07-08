import 'package:flutter/material.dart';

import '../../core/theme/clivora_colors.dart';

class StepProgressCard extends StatelessWidget {
  const StepProgressCard({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.title,
    required this.nextLabel,
  });

  final int currentStep;
  final int totalSteps;
  final String title;
  final String nextLabel;

  @override
  Widget build(BuildContext context) {
    final progress = currentStep / totalSteps;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ClivoraColors.borderLight),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 52,
                height: 52,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 4,
                      backgroundColor: ClivoraColors.chipBackground,
                      color: ClivoraColors.successGreen,
                    ),
                    Text(
                      '$currentStep of $totalSteps',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      'Next: $nextLabel',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: ClivoraColors.chipBackground,
              color: ClivoraColors.successGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class ClivoraFieldLabel extends StatelessWidget {
  const ClivoraFieldLabel({
    super.key,
    required this.label,
    this.required = false,
    this.trailing,
  });

  final String label;
  final bool required;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall,
          ),
          if (required)
            const Text(' *', style: TextStyle(color: ClivoraColors.errorRed)),
          if (trailing != null) ...[
            const Spacer(),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class ClivoraTextField extends StatelessWidget {
  const ClivoraTextField({
    super.key,
    required this.controller,
    this.hint,
    this.label,
    this.required = false,
    this.maxLines = 1,
    this.keyboardType,
    this.trailing,
  });

  final TextEditingController controller;
  final String? hint;
  final String? label;
  final bool required;
  final int maxLines;
  final TextInputType? keyboardType;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          ClivoraFieldLabel(
            label: label!,
            required: required,
            trailing: trailing,
          ),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}
