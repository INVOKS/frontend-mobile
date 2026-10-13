import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/booking_history.dart';
import 'booking_detail_box.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({
    super.key,
    required this.booking,
  });

  final BookingHistory booking;

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    final isUpcoming = booking.status == BookingStatus.upcoming;
    final headerColor = isUpcoming
        ? AppColors.badge
        : const Color(0xFFCBD5E1);

    final isSameDate = booking.startDate.year == booking.endDate.year &&
        booking.startDate.month == booking.endDate.month &&
        booking.startDate.day == booking.endDate.day;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            color: headerColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              booking.bookingId,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tanggal Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 95,
                      child: Text(
                        'Tanggal',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF334155),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const Text(
                      ': ',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF334155),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _formatDate(booking.startDate),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF0F172A),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (!isSameDate)
                            Text(
                              _formatDate(booking.endDate),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF0F172A),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Waktu Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 95,
                      child: Text(
                        'Waktu',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF334155),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const Text(
                      ': ',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF334155),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${booking.startTime} - ${booking.endTime}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF0F172A),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Detail Ruangan
                const Text(
                  'Detail Ruangan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                BookingDetailBox(booking: booking),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

