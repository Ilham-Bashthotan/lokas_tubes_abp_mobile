import 'package:dio/dio.dart';

import 'api_client.dart';
import 'warehouse_model.dart';

class WarehouseService {
  WarehouseService._();

  static Future<List<WarehouseLocation>> fetchWarehouses({
    String? search,
    String? sortBy,
    String sortDir = 'desc',
    int page = 1,
    int perPage = 50,
  }) async {
    final response = await ApiClient.dio.get(
      'warehouses',
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (sortBy != null) 'sort_by': sortBy,
        'sort_dir': sortDir,
        'page': page,
        'per_page': perPage,
      },
    );

    if (response.statusCode != 200) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
      );
    }

    final data = response.data as Map<String, dynamic>;
    final warehousesJson = (data['data'] as List? ?? []);

    return warehousesJson
        .map(
          (warehouseJson) => WarehouseLocation.fromJson(
            Map<String, dynamic>.from(warehouseJson as Map),
          ),
        )
        .toList();
  }
}
