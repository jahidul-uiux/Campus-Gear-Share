class ItemModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final String sellerId;
  final String sellerName;
  final String status;
  final DateTime createdAt;

  ItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.sellerId,
    required this.sellerName,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      category: map['category'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      sellerId: map['sellerId'] ?? '',
      sellerName: map['sellerName'] ?? '',
      status: map['status'] ?? 'Available',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}