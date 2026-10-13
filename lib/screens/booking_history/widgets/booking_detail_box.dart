import 'package:flutter/material.dart';

import '../../../models/booking_history.dart';

class BookingDetailBox extends StatelessWidget {
  const BookingDetailBox({
    super.key,
    required this.booking,
  });

  final BookingHistory booking;

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 95,
            child: Text(
              label,
              style: const TextStyle(
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
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Gedung', booking.building),
        _buildDetailRow('Ruang', booking.room),
        _buildDetailRow('Lantai', booking.floor),
        _buildDetailRow('Kapasitas', '${booking.capacity} orang'),
        _buildDetailRow('Nama kegiatan', booking.activityName),
      ],
    );
  }
}

