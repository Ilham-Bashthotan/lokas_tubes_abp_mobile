import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import 'api_client.dart';
import 'loan_model.dart';

class PagedLoans {
  final List<Loan> loans;
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  PagedLoans({
    required this.loans,
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });
}

class LoansService {
  LoansService._();

  static Future<PagedLoans> fetchMyLoans({
    String? status,
    String sortBy = 'created_at',
    String sortDir = 'desc',
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await ApiClient.dio.get(
      'loans/my',
      queryParameters: {
        if (status != null && status != 'all') 'status': status,
        'sort_by': sortBy,
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

    return PagedLoans(
      loans: itemsJson
          .map((itemJson) => Loan.fromJson(Map<String, dynamic>.from(itemJson as Map)))
          .toList(),
      currentPage: meta['current_page'] as int,
      perPage: meta['per_page'] as int,
      total: meta['total'] as int,
      lastPage: meta['last_page'] as int,
    );
  }

  static Future<Loan> createLoan({
    required int itemId,
    required DateTime loanDate,
    required DateTime dueDate,
    String? note,
    String? photoPath,
  }) async {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final formData = FormData.fromMap({
      'item_id': itemId,
      'loan_date': dateFormat.format(loanDate),
      'due_date': dateFormat.format(dueDate),
      if (note != null && note.isNotEmpty) 'note': note,
      if (photoPath != null)
        'photo_before': await MultipartFile.fromFile(photoPath),
    });

    final response = await ApiClient.dio.post('loans', data: formData);

    if (response.statusCode != 201) {
      throw DioException(requestOptions: response.requestOptions, response: response);
    }

    final data = response.data as Map<String, dynamic>;
    final loanJson = Map<String, dynamic>.from(data['data'] as Map);
    return Loan.fromJson(loanJson);
  }

  static Future<Loan> returnItem({
    required int loanId,
    required String conditionAfter,
    String? note,
    String? photoPath,
  }) async {
    final formData = FormData.fromMap({
      '_method': 'PATCH',
      'condition_after': conditionAfter,
      if (note != null && note.isNotEmpty) 'note': note,
      if (photoPath != null)
        'photo_after': await MultipartFile.fromFile(photoPath),
    });

    final response = await ApiClient.dio.post('loans/$loanId/return', data: formData);

    if (response.statusCode != 200) {
      throw DioException(requestOptions: response.requestOptions, response: response);
    }

    final data = response.data as Map<String, dynamic>;
    final loanJson = Map<String, dynamic>.from(data['data'] as Map);
    return Loan.fromJson(loanJson);
  }
}
