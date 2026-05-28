class NotificationModel {
  final int id;
  final int loanId;
  final String type;
  final String message;
  final bool isResolved;
  final bool isRead;
  final DateTime alertedAt;
  final NestedLoan? loan;

  NotificationModel({
    required this.id,
    required this.loanId,
    required this.type,
    required this.message,
    required this.isResolved,
    required this.isRead,
    required this.alertedAt,
    this.loan,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      loanId: json['loan_id'] ?? 0,
      type: json['type'] ?? 'unknown',
      message: json['message'] ?? '',
      isResolved: (json['is_resolved'] == 1 || json['is_resolved'] == true),
      isRead: (json['is_read'] == 1 || json['is_read'] == true),
      alertedAt: json['alerted_at'] != null 
          ? DateTime.parse(json['alerted_at']) 
          : DateTime.now(),
      loan: json['loan'] != null ? NestedLoan.fromJson(json['loan']) : null,
    );
  }
}

class NestedLoan {
  final int id;
  final String status;
  final NestedItem? item;

  NestedLoan({
    required this.id,
    required this.status,
    this.item,
  });

  factory NestedLoan.fromJson(Map<String, dynamic> json) {
    return NestedLoan(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      item: json['item'] != null ? NestedItem.fromJson(json['item']) : null,
    );
  }
}

class NestedItem {
  final int id;
  final String name;

  NestedItem({
    required this.id,
    required this.name,
  });

  factory NestedItem.fromJson(Map<String, dynamic> json) {
    return NestedItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
