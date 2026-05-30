import 'package:latlong2/latlong.dart';

class WarehouseLocation {
  final int id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  WarehouseLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  LatLng get position => LatLng(latitude, longitude);

  String get markerLabel {
    final idText = id.toString().padLeft(2, '0');
    return 'WH-$idText';
  }

  factory WarehouseLocation.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0;
      return 0;
    }

    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      if (value is double) return value.toInt();
      return 0;
    }

    return WarehouseLocation(
      id: parseInt(json['id']),
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      latitude: parseDouble(json['latitude']),
      longitude: parseDouble(json['longitude']),
    );
  }
}
