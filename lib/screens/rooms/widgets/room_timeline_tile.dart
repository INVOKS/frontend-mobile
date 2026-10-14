import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/room.dart';

/// Posisi item dalam kelompok lantai, digunakan untuk menggambar segmen
/// garis timeline dengan benar.
enum TimelinePosition { first, middle, last, only }

/// Satu baris dalam daftar ruangan: titik + segmen garis timeline di kiri,
/// kartu ruangan di kanan.
///
/// Garis timeline menyambung antar item dalam satu lantai dan terputus
/// di antara lantai (karena [FloorHeader] memisahkan grup).
class RoomTimelineTile extends StatelessWidget {
  const RoomTimelineTile({
    super.key,
    required this.room,
    required this.position,
    this.onTap,
  });

  final Room room;
  final TimelinePosition position;
  final VoidCallback? onTap;

  // ---- dimensi timeline -----------------------------------------------
  static const _kGutterWidth = 60.0;
  static const _kLineWidth = 2.0;
  static const _kDotSize = 10.0;
  static const _kCardHeight = 84.0;
  static const _kCardSpacing = 16.0; // jarak antar kartu
  static const _kCardTopPad =
      16.0; // ruang di atas kartu pertama (setelah header lantai)
  static const _kLastBottomPad =
      24.0; // ruang di bawah kartu terakhir (sebelum header lantai berikutnya)
  // ---- dimensi thumbnail -----------------------------------------------
  static const _kThumbW = 64.0;
  static const _kThumbH = 58.0;

  @override
  Widget build(BuildContext context) {
    final topPad =
        (position == TimelinePosition.first ||
            position == TimelinePosition.only)
        ? _kCardTopPad
        : 0.0;
    final bottomPad =
        (position == TimelinePosition.last || position == TimelinePosition.only)
        ? _kLastBottomPad
        : _kCardSpacing;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ---- kolom kiri: gutter + timeline ---------------------------
          SizedBox(
            width: _kGutterWidth,
            child: CustomPaint(
              painter: _TimelinePainter(
                position: position,
                topPad: topPad,
                cardHeight: _kCardHeight,
              ),
            ),
          ),

          // ---- kartu ruangan -------------------------------------------
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: topPad,
                bottom: bottomPad,
                right: 26,
              ),
              child: _RoomCard(room: room, onTap: onTap),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Painter timeline
// ---------------------------------------------------------------------------

class _TimelinePainter extends CustomPainter {
  const _TimelinePainter({
    required this.position,
    required this.topPad,
    required this.cardHeight,
  });

  final TimelinePosition position;
  final double topPad;
  final double cardHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppColors.timelineLine
      ..strokeWidth = RoomTimelineTile._kLineWidth
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = AppColors.timelineDot
      ..style = PaintingStyle.fill;

    final cx = size.width / 2; // pusat gutter
    // Titik bulat tepat di tengah vertikal kartu
    final cy = topPad + (cardHeight / 2);
    final dotR = RoomTimelineTile._kDotSize / 2;

    // ---- Garis atas (dari ujung atas tile sampai tepi atas titik) --------
    final drawTop =
        position == TimelinePosition.middle ||
        position == TimelinePosition.last;
    if (drawTop) {
      canvas.drawLine(Offset(cx, 0), Offset(cx, cy - dotR), linePaint);
    }

    // ---- Garis bawah (dari tepi bawah titik sampai ujung bawah tile) -----
    final drawBottom =
        position == TimelinePosition.middle ||
        position == TimelinePosition.first;
    if (drawBottom) {
      canvas.drawLine(
        Offset(cx, cy + dotR),
        Offset(cx, size.height),
        linePaint,
      );
    }

    // ---- Titik bulat sejajar dengan tengah kartu ----
    canvas.drawCircle(Offset(cx, cy), dotR, dotPaint);
  }

  @override
  bool shouldRepaint(_TimelinePainter oldDelegate) =>
      oldDelegate.position != position ||
      oldDelegate.topPad != topPad ||
      oldDelegate.cardHeight != cardHeight;
}

// ---------------------------------------------------------------------------
// Kartu ruangan
// ---------------------------------------------------------------------------

class _RoomCard extends StatelessWidget {
  const _RoomCard({required this.room, this.onTap});

  final Room room;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: RoomTimelineTile._kCardHeight,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.roomCardBorder, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                _RoomThumbnail(
                  imagePath: room.imagePath,
                  semanticLabel: room.name,
                ),
                const SizedBox(width: 12),
                Expanded(child: _RoomInfo(room: room)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoomThumbnail extends StatelessWidget {
  const _RoomThumbnail({required this.imagePath, required this.semanticLabel});

  final String imagePath;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.asset(
        imagePath,
        width: RoomTimelineTile._kThumbW,
        height: RoomTimelineTile._kThumbH,
        fit: BoxFit.cover,
        semanticLabel: semanticLabel,
        errorBuilder: (context, error, stackTrace) => Container(
          width: RoomTimelineTile._kThumbW,
          height: RoomTimelineTile._kThumbH,
          color: AppColors.imagePlaceholder,
          alignment: Alignment.center,
          child: const Icon(
            Icons.meeting_room_outlined,
            color: AppColors.primary,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class _RoomInfo extends StatelessWidget {
  const _RoomInfo({required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          room.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          room.capacityLabel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
        ),
      ],
    );
  }
}
