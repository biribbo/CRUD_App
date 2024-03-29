class Product {
  final int id;
  final String title;
  final String description;
  final String creationDate;
  final String creatorUserId;
  final bool isDeleted;
  final String imageUrl;

  Product(this.id, this.title, this.description, this.creationDate,
      this.creatorUserId, this.isDeleted, this.imageUrl);
}