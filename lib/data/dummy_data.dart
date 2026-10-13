import '../core/constants/app_assets.dart';
import '../models/inventory_item.dart';
import '../models/room.dart';

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
