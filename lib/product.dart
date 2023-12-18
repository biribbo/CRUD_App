class Product {
  int? id;
  String? title;
  String? description;
  DateTime? creationDate;
  int? creatorUserId;
  bool? isDeleted;
  String? imageUrl;

  Product(this.id, this.title, this.description, this.creationDate, this.creatorUserId, this.isDeleted, this.imageUrl);

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    creationDate = json['creationDate'];
    creatorUserId = json['creatorUserId'];
    isDeleted = json['isDeleted'];
    imageUrl = json['imageUrl'];
  }

  factory Product.fromMap(Map<String, dynamic> json) {
    return Product(
      json['id'],
      json['title'],
      json['description'],
      json['creationDate'],
      json['creatorUserId'],
      json['isDeleted'],
      json['imageUrl'],
    );
  }
}