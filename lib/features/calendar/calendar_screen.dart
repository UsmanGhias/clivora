import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/clivora_colors.dart';
import '../../data/providers/app_providers.dart';
import '../../shared/widgets/clivora_scaffold.dart';

/// Calendar with month grid, deadlines, invoices, tasks, reminders, and activity.
class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _focusedMonth;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month);
    _selectedDay = DateTime(now.year, now.month, now.day);
  }

  DateTime get _effectiveSelected {
    final day = _selectedDay;
    if (day != null && day.year == _focusedMonth.year && day.month == _focusedMonth.month) {
      return day;
    }
    final now = DateTime.now();
    if (now.year == _focusedMonth.year && now.month == _focusedMonth.month) {
      return DateTime(now.year, now.month, now.day);
    }
    return DateTime(_focusedMonth.year, _focusedMonth.month, 1);
  }

  void _changeMonth(int delta) {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + delta);
      final sel = _selectedDay;
      if (sel == null || sel.year != _focusedMonth.year || sel.month != _focusedMonth.month) {
        _selectedDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(calendarEventsProvider);
    final remindersAsync = ref.watch(calendarRemindersProvider);

    return ClivoraScaffold(
      title: 'Calendar',
      showBackButton: true,
      body: eventsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (events) {
          final reminders = remindersAsync.valueOrNull ?? [];
          final allEvents = [...events, ...reminders];
          final selected = _effectiveSelected;
          final dayEvents = allEvents.where((e) =>
              e.date.year == selected.year && e.date.month == selected.month && e.date.day == selected.day);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _MonthHeader(
                month: _focusedMonth,
                onPrev: () => _changeMonth(-1),
                onNext: () => _changeMonth(1),
                onToday: () {
                  final now = DateTime.now();
                  setState(() {
                    _focusedMonth = DateTime(now.year, now.month);
                    _selectedDay = DateTime(now.year, now.month, now.day);
                  });
                },
              ),
              const SizedBox(height: 12),
              _MonthGrid(
                month: _focusedMonth,
                events: allEvents,
                selected: selected,
                onSelect: (d) => setState(() => _selectedDay = d),
              ),
              const SizedBox(height: 20),
              Text(
                DateFormat('EEEE, MMMM d').format(selected),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              if (dayEvents.isEmpty)
                Text('No events this day', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ClivoraColors.textSecondary))
              else
                ...dayEvents.map((e) => _EventCard(event: e)),
            ],
          );
        },
      ),
    );
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.month,
    required this.onPrev,
    required this.onNext,
    required this.onToday,
  });

  final DateTime month;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: onPrev, icon: const Icon(Icons.chevron_left)),
        Expanded(
          child: Text(
            DateFormat('MMMM yyyy').format(month),
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
          ),
        ),
        TextButton(onPressed: onToday, child: const Text('Today')),
        IconButton(onPressed: onNext, icon: const Icon(Icons.chevron_right)),
      ],
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.month,
    required this.events,
    required this.selected,
    required this.onSelect,
  });

  final DateTime month;
  final List<CalendarEvent> events;
  final DateTime selected;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final first = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final startWeekday = first.weekday % 7;
    final cells = <Widget>[
      for (final label in ['S', 'M', 'T', 'W', 'T', 'F', 'S'])
        Center(child: Text(label, style: Theme.of(context).textTheme.labelSmall)),
    ];
    for (var i = 0; i < startWeekday; i++) {
      cells.add(const SizedBox());
    }
    for (var day = 1; day <= daysInMonth; day++) {
      final date = DateTime(month.year, month.month, day);
      final dayEvents = events.where((e) => e.date.year == date.year && e.date.month == date.month && e.date.day == date.day);
      final hasEvent = dayEvents.isNotEmpty;
      final isSelected = selected.year == date.year && selected.month == date.month && selected.day == date.day;
      final isToday = _isSameDay(date, DateTime.now());
      cells.add(
        InkWell(
          onTap: () => onSelect(date),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? ClivoraColors.primary.withValues(alpha: 0.15) : null,
              border: isToday ? Border.all(color: ClivoraColors.primary, width: 1.5) : null,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$day', style: TextStyle(fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500)),
                if (hasEvent)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: dayEvents.take(3).map((e) => Container(
                          width: 5,
                          height: 5,
                          margin: const EdgeInsets.only(top: 2, left: 1, right: 1),
                          decoration: BoxDecoration(color: e.color, shape: BoxShape.circle),
                        )).toList(),
                  ),
              ],
            ),
          ),
        ),
      );
    }
    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: cells,
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});

  final CalendarEvent event;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: event.color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(_iconFor(event.type), color: event.color, size: 20),
        ),
        title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          '${event.type[0].toUpperCase()}${event.type.substring(1)} · ${DateFormat.jm().format(event.date)}',
        ),
      ),
    );
  }

  IconData _iconFor(String type) => switch (type) {
        'task' => Icons.task_alt_outlined,
        'project' => Icons.work_outline,
        'invoice' => Icons.receipt_long_outlined,
        'activity' => Icons.history,
        _ => Icons.event,
      };
}
