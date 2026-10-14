import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'account_text_field.dart';

/// Field pemilih tanggal lahir dengan popup date picker dan format dd/MM/yyyy.
class DatePickerField extends StatefulWidget {
  const DatePickerField({
    super.key,
    this.initialDate,
    required this.onDateSelected,
    this.validator,
  });

  final DateTime? initialDate;
  final ValueChanged<DateTime?> onDateSelected;
  final FormFieldValidator<String>? validator;

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late final TextEditingController _controller;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _controller = TextEditingController(text: _formatDate(_selectedDate));
  }

  @override
  void didUpdateWidget(DatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialDate != widget.initialDate) {
      _selectedDate = widget.initialDate;
      _controller.text = _formatDate(_selectedDate);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static String _formatDate(DateTime? date) {
    if (date == null) return '';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial =
        _selectedDate ?? DateTime(now.year - 20, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isAfter(now) ? now : initial,
      firstDate: DateTime(1950),
      lastDate: now,
      helpText: 'PILIH TANGGAL LAHIR',
      confirmText: 'PILIH',
      cancelText: 'BATAL',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _controller.text = _formatDate(picked);
      });
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AccountTextField(
      controller: _controller,
      hintText: 'Tanggal lahir',
      readOnly: true,
      onTap: _pickDate,
      validator: widget.validator,
      suffixIcon: const Icon(
        Icons.calendar_today_outlined,
        size: 18,
        color: AppColors.tabInactive,
      ),
    );
  }
}
