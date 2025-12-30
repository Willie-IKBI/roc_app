import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/design_tokens.dart';
import '../../../../core/widgets/glass_input.dart';

class AppointmentPicker extends StatefulWidget {
  const AppointmentPicker({
    super.key,
    this.selectedDate,
    this.selectedTime,
    this.onDateSelected,
    this.onTimeSelected,
  });

  final DateTime? selectedDate;
  final String? selectedTime;
  final ValueChanged<DateTime?>? onDateSelected;
  final ValueChanged<String?>? onTimeSelected;

  @override
  State<AppointmentPicker> createState() => _AppointmentPickerState();
}

class _AppointmentPickerState extends State<AppointmentPicker> {
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(
      text: widget.selectedDate != null
          ? DateFormat('yyyy-MM-dd').format(widget.selectedDate!)
          : '',
    );
    _timeController = TextEditingController(
      text: widget.selectedTime ?? '',
    );
  }

  @override
  void didUpdateWidget(AppointmentPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      _dateController.text = widget.selectedDate != null
          ? DateFormat('yyyy-MM-dd').format(widget.selectedDate!)
          : '';
    }
    if (widget.selectedTime != oldWidget.selectedTime) {
      _timeController.text = widget.selectedTime ?? '';
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final initialDate = widget.selectedDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      widget.onDateSelected?.call(picked);
      _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? initialTime;
    if (widget.selectedTime != null) {
      final parts = widget.selectedTime!.split(':');
      if (parts.length >= 2) {
        initialTime = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    }
    initialTime ??= TimeOfDay.now();

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      final timeStr = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00';
      widget.onTimeSelected?.call(timeStr);
      _timeController.text = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Appointment',
          style: theme.textTheme.labelLarge,
        ),
        const SizedBox(height: DesignTokens.spaceM),
        Row(
          children: [
            Expanded(
              child: GlassInput.text(
                context: context,
                controller: _dateController,
                label: 'Date',
                readOnly: true,
                onTap: () => _selectDate(context),
                suffixIcon: const Icon(Icons.calendar_today_outlined),
              ),
            ),
            const SizedBox(width: DesignTokens.spaceM),
            Expanded(
              child: GlassInput.text(
                context: context,
                controller: _timeController,
                label: 'Time',
                readOnly: true,
                onTap: () => _selectTime(context),
                suffixIcon: const Icon(Icons.access_time_outlined),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

