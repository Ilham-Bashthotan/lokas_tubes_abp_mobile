import 'item_model.dart';

class DummyItems {
  DummyItems._();

  static final List<Item> items = [
    Item(
      id: 1,
      name: 'Laptop Dell XPS 13',
      description: 'Laptop ultrabook untuk meeting, presentasi, dan pekerjaan harian.',
      qrCode: 'INV-2026-001',
      imageUrl: null,
      condition: 'good',
      status: 'available',
      category: Category(id: 1, name: 'Elektronik'),
      warehouse: Warehouse(
        id: 1,
        name: 'Gudang Utama A',
        address: 'Jl. Industri No. 10, Jakarta',
        latitude: -6.2088,
        longitude: 106.8456,
      ),
    ),
    Item(
      id: 2,
      name: 'Proyektor Epson EB',
      description: 'Proyektor untuk presentasi dan pelatihan di ruang meeting.',
      qrCode: 'INV-2026-002',
      imageUrl: null,
      condition: 'good',
      status: 'borrowed',
      category: Category(id: 1, name: 'Elektronik'),
      warehouse: Warehouse(
        id: 2,
        name: 'Gudang B – Selatan',
        address: 'Jl. Raya Bogor KM 20',
        latitude: -6.4975,
        longitude: 106.8272,
      ),
    ),
    Item(
      id: 3,
      name: 'Kamera Canon EOS',
      description: 'Kamera DSLR untuk dokumentasi kegiatan lapangan dan event.',
      qrCode: 'INV-2026-003',
      imageUrl: null,
      condition: 'good',
      status: 'available',
      category: Category(id: 2, name: 'Kamera'),
      warehouse: Warehouse(
        id: 1,
        name: 'Gudang Utama A',
        address: 'Jl. Industri No. 10, Jakarta',
        latitude: -6.2088,
        longitude: 106.8456,
      ),
    ),
    Item(
      id: 4,
      name: 'Mic Wireless Shure',
      description: 'Microphone nirkabel untuk presentasi serta acara internal.',
      qrCode: 'INV-2026-004',
      imageUrl: null,
      condition: 'good',
      status: 'maintenance',
      category: Category(id: 3, name: 'Audio'),
      warehouse: Warehouse(
        id: 1,
        name: 'Gudang Utama A',
        address: 'Jl. Industri No. 10, Jakarta',
        latitude: -6.2088,
        longitude: 106.8456,
      ),
    ),
  ];

  static List<Item> getItems({String? status, String? search}) {
    final searchLower = search?.trim().toLowerCase() ?? '';

    return items.where((item) {
      final statusMatches = status == null || status == 'all' || item.status == status;
      final searchMatches = searchLower.isEmpty ||
          item.name.toLowerCase().contains(searchLower) ||
          item.qrCode.toLowerCase().contains(searchLower);
      return statusMatches && searchMatches;
    }).toList();
  }

  static Item? findById(int id) {
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }
}
