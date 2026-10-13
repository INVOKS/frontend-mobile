enum BookingStatus {
  upcoming,
  completed,
}

class BookingHistory {
  final String bookingId;
  final DateTime startDate;
  final DateTime endDate;
  final String startTime;
  final String endTime;
  final String building;
  final String room;
  final String floor;
  final int capacity;
  final String activityName;
  final BookingStatus status;

  const BookingHistory({
    required this.bookingId,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.building,
    required this.room,
    required this.floor,
    required this.capacity,
    required this.activityName,
    required this.status,
  });
}

