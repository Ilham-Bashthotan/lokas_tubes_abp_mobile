class Item {
  final int id;
  final String name;
  final String? description;
  final String qrCode;
  final String? imageUrl;
  final String condition;
  final String status;
  final Category? category;
  final Warehouse? warehouse;
  final ActiveLoan? activeLoan;

  Item({
    required this.id,
    required this.name,
    this.description,
    required this.qrCode,
    this.imageUrl,
    required this.condition,
    required this.status,
    this.category,
    this.warehouse,
    this.activeLoan,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      qrCode: json['qr_code'] as String,
      imageUrl: json['image_url'] as String?,
      condition: json['condition'] as String,
      status: json['status'] as String,
      category: json['category'] != null
          ? Category.fromJson(Map<String, dynamic>.from(json['category'] as Map))
          : null,
      warehouse: json['warehouse'] != null
          ? Warehouse.fromJson(Map<String, dynamic>.from(json['warehouse'] as Map))
          : null,
      activeLoan: json['active_loan'] != null
          ? ActiveLoan.fromJson(Map<String, dynamic>.from(json['active_loan'] as Map))
          : null,
    );
  }
}

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class Warehouse {
  final int id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  Warehouse({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0;
      return 0;
    }

    return Warehouse(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: parseDouble(json['latitude']),
      longitude: parseDouble(json['longitude']),
    );
  }
}

class ActiveLoan {
  final int id;
  final String borrower;
  final String loanDate;
  final String dueDate;

  ActiveLoan({
    required this.id,
    required this.borrower,
    required this.loanDate,
    required this.dueDate,
  });

  factory ActiveLoan.fromJson(Map<String, dynamic> json) {
    return ActiveLoan(
      id: json['id'] as int,
      borrower: json['borrower'] as String,
      loanDate: json['loan_date'] as String,
      dueDate: json['due_date'] as String,
    );
  }
}
