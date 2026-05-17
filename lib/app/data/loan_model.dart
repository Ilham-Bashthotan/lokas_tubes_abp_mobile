import 'item_model.dart';

class Loan {
  final int id;
  final Item item;
  final String? note;
  final String status;
  final DateTime loanDate;
  final DateTime dueDate;
  final DateTime? returnDate;

  Loan({
    required this.id,
    required this.item,
    this.note,
    required this.status,
    required this.loanDate,
    required this.dueDate,
    this.returnDate,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: json['id'],
      item: Item.fromJson(json['item']),
      note: json['note'],
      status: json['status'],
      loanDate: DateTime.parse(json['loan_date']),
      dueDate: DateTime.parse(json['due_date']),
      returnDate: json['return_date'] != null
          ? DateTime.parse(json['return_date'])
          : null,
    );
  }
}
