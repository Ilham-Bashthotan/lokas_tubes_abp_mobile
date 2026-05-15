import 'package:dio/dio.dart';

import 'api_client.dart';
import 'item_model.dart';

class PagedItems {
  final List<Item> items;
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  PagedItems({
    required this.items,
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });
}

class ItemsService {
  ItemsService._();

  static Future<PagedItems> fetchItems({
    String? status,
    String? condition,
    String? search,
    String? sortBy,
    String sortDir = 'desc',
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await ApiClient.dio.get(
      'items',
      queryParameters: {
        if (status != null) 'status': status,
        if (condition != null) 'condition': condition,
        if (search != null && search.isNotEmpty) 'search': search,
        if (sortBy != null) 'sort_by': sortBy,
        'sort_dir': sortDir,
        'page': page,
        'per_page': perPage,
      },
    );

    if (response.statusCode != 200) {
      throw DioException(requestOptions: response.requestOptions, response: response);
    }

    final data = response.data as Map<String, dynamic>;
    final itemsJson = data['data'] as List<dynamic>;
    final meta = data['meta'] as Map<String, dynamic>;

    return PagedItems(
      items: itemsJson
          .map((itemJson) => Item.fromJson(Map<String, dynamic>.from(itemJson as Map)))
          .toList(),
      currentPage: meta['current_page'] as int,
      perPage: meta['per_page'] as int,
      total: meta['total'] as int,
      lastPage: meta['last_page'] as int,
    );
  }

  static Future<Item> fetchItem(int id) async {
    final response = await ApiClient.dio.get('items/$id');

    if (response.statusCode != 200) {
      throw DioException(requestOptions: response.requestOptions, response: response);
    }

    final data = response.data as Map<String, dynamic>;
    final itemJson = Map<String, dynamic>.from(data['data'] as Map);
    return Item.fromJson(itemJson);
  }

  static Future<int> fetchItemsTotal({
    String? status,
    String? condition,
  }) async {
    final page = await fetchItems(
      status: status,
      condition: condition,
      page: 1,
      perPage: 1,
    );
    return page.total;
  }
}
