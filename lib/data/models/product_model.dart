class ProductResponse {
  final bool? status;
  final String? message;
  final List<Product>? data;

  ProductResponse({this.status, this.message, this.data});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      status: json['Status'],
      message: json['Message'],
      data: json['Data'] != null
          ? (json['Data'] as List).map((i) => Product.fromJson(i)).toList()
          : null,
    );
  }
}

class Product {
  final int? id;
  final String? description;
  final String? longDescription;
  final String? rate;
  final int? tax;
  final String? unit;
  final String? rateCurrency1;
  final String? origin;
  final int? active;
  final String? longDescriptions;
  final int? taxId;
  final String? taxName;

  Product({
    this.id,
    this.description,
    this.longDescription,
    this.rate,
    this.tax,
    this.unit,
    this.rateCurrency1,
    this.origin,
    this.active,
    this.longDescriptions,
    this.taxId,
    this.taxName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      description: json['description'],
      longDescription: json['long_description'],
      rate: json['rate'],
      tax: json['tax'],
      unit: json['unit'],
      rateCurrency1: json['rate_currency_1'],
      origin: json['origin'],
      active: json['active'],
      longDescriptions: json['long_descriptions'],
      taxId: json['tax_id'],
      taxName: json['tax_name'],
    );
  }
}
