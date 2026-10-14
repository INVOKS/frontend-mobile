import 'package:flutter/foundation.dart';

import '../core/constants/app_assets.dart';
import '../models/inventory_item.dart';
import '../models/room.dart';
import '../models/user_profile.dart';

const topFavoriteRooms = <Room>[
  Room(
    id: 'room-304',
    name: 'Ruang 304',
    capacityMin: 80,
    capacityMax: 100,
    imagePath: AppAssets.room304,
  ),
  Room(
    id: 'room-502',
    name: 'Ruang 502',
    capacityMin: 60,
    capacityMax: 80,
    imagePath: AppAssets.room502,
  ),
  Room(
    id: 'room-501',
    name: 'Ruang 501',
    capacityMin: 50,
    capacityMax: 150,
    imagePath: AppAssets.room501,
  ),
];

const topFavoriteItems = <InventoryItem>[
  InventoryItem(id: 'item-hdmi', name: 'Kabel HDMI', imagePath: AppAssets.hdmi),
  InventoryItem(
    id: 'item-sound-system',
    name: 'Sound system',
    imagePath: AppAssets.soundSystem,
  ),
  InventoryItem(
    id: 'item-wireless-mic',
    name: 'Mic wireless',
    imagePath: AppAssets.wirelessMic,
  ),
];

// Single Source of Truth profil pengguna aktif
final userProfileNotifier = ValueNotifier<UserProfile>(
  UserProfile(
    name: 'Muhammad Syafiq',
    email: 'syafiq@student.ub.ac.id',
    gender: 'Laki Laki',
    birthDate: DateTime(2003, 5, 20),
    major: 'Teknologi Informasi',
    batch: '2022',
    phone: '081234567890',
  ),
);

// Daftar gedung dan data ruangan per lantai
const buildingNames = <String>['BNI', 'Dieng', 'KP'];

final Map<String, Map<String, List<Room>>> _buildingRooms = {
  'BNI': {
    'Basement': [
      const Room(
        id: 'room-b02',
        name: 'Ruang B02',
        capacityMin: 20,
        capacityMax: 30,
        imagePath: AppAssets.room304,
      ),
    ],
    'Lantai 1': [
      const Room(
        id: 'room-101',
        name: 'Ruang 101',
        capacityMin: 40,
        capacityMax: 60,
        imagePath: AppAssets.room304,
      ),
      const Room(
        id: 'room-102',
        name: 'Ruang 102',
        capacityMin: 30,
        capacityMax: 50,
        imagePath: AppAssets.room502,
      ),
    ],
    'Lantai 2': [
      const Room(
        id: 'room-201',
        name: 'Ruang 201',
        capacityMin: 40,
        capacityMax: 60,
        imagePath: AppAssets.room501,
      ),
      const Room(
        id: 'room-204',
        name: 'Ruang 204',
        capacityMin: 50,
        capacityMax: 80,
        imagePath: AppAssets.room502,
      ),
    ],
    'Lantai 3': [
      const Room(
        id: 'room-301',
        name: 'Ruang 301',
        capacityMin: 40,
        capacityMax: 60,
        imagePath: AppAssets.room501,
      ),
      const Room(
        id: 'room-304',
        name: 'Ruang 304',
        capacityMin: 80,
        capacityMax: 100,
        imagePath: AppAssets.room304,
      ),
    ],
    'Lantai 4': [
      const Room(
        id: 'room-401',
        name: 'Ruang 401',
        capacityMin: 40,
        capacityMax: 60,
        imagePath: AppAssets.room501,
      ),
      const Room(
        id: 'room-402',
        name: 'Lab Komputer 402',
        capacityMin: 30,
        capacityMax: 45,
        imagePath: AppAssets.room304,
      ),
    ],
  },
  'Dieng': {
    'Lantai 1': [
      const Room(
        id: 'room-dieng-101',
        name: 'Ruang Seminar 101',
        capacityMin: 60,
        capacityMax: 100,
        imagePath: AppAssets.room304,
      ),
    ],
    'Lantai 5': [
      const Room(
        id: 'room-501',
        name: 'Ruang 501',
        capacityMin: 50,
        capacityMax: 150,
        imagePath: AppAssets.room501,
      ),
      const Room(
        id: 'room-502',
        name: 'Ruang 502',
        capacityMin: 60,
        capacityMax: 80,
        imagePath: AppAssets.room502,
      ),
    ],
  },
  'KP': {
    'Lantai 1': [
      const Room(
        id: 'room-kp-101',
        name: 'Ruang Sidang KP',
        capacityMin: 20,
        capacityMax: 40,
        imagePath: AppAssets.room304,
      ),
    ],
    'Lantai 2': [
      const Room(
        id: 'room-kp-201',
        name: 'Ruang Kelas 201',
        capacityMin: 30,
        capacityMax: 50,
        imagePath: AppAssets.room502,
      ),
    ],
    'Lantai 3': [
      const Room(
        id: 'room-kp-304',
        name: 'Ruang 304',
        capacityMin: 40,
        capacityMax: 60,
        imagePath: AppAssets.room501,
      ),
    ],
  },
};

Map<String, List<Room>> roomsByFloor(String buildingName) {
  final match = _buildingRooms.entries.firstWhere(
    (e) => e.key.toLowerCase() == buildingName.toLowerCase(),
    orElse: () => MapEntry(buildingName, const <String, List<Room>>{}),
  );
  return match.value;
}

List<String> floorNamesOf(String buildingName) {
  return roomsByFloor(buildingName).keys.toList();
}

