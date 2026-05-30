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
    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      if (value is double) return value.toInt();
      return 0;
    }

    return Item(
      id: parseInt(json['id']),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      qrCode: json['qr_code']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
      condition: json['condition']?.toString() ?? 'good',
      status: json['status']?.toString() ?? 'available',
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
      id: (json['id'] is int) ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
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
      id: (json['id'] is int) ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
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
      id: (json['id'] is int) ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      borrower: json['borrower']?.toString() ?? '',
      loanDate: json['loan_date']?.toString() ?? '',
      dueDate: json['due_date']?.toString() ?? '',
    );
  }
}
