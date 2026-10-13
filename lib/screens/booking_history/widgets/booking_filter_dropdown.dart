import 'package:flutter/material.dart';

enum BookingHistoryFilter {
  all,
  upcoming,
  completed,
}

class BookingFilterDropdown extends StatelessWidget {
  const BookingFilterDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final BookingHistoryFilter value;
  final ValueChanged<BookingHistoryFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFF94A3B8),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<BookingHistoryFilter>(
          value: value,
          isDense: true,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Color(0xFF334155),
            size: 20,
          ),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1E293B),
          ),
          items: const [
            DropdownMenuItem(
              value: BookingHistoryFilter.all,
              child: Text('Pilih Kategori'),
            ),
            DropdownMenuItem(
              value: BookingHistoryFilter.upcoming,
              child: Text('Mendatang'),
            ),
            DropdownMenuItem(
              value: BookingHistoryFilter.completed,
              child: Text('Selesai'),
            ),
          ],
          onChanged: (newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
      ),
    );
  }
}

