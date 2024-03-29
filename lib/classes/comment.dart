class Comment {
  final int id;
  final int productId;
  final String description;
  final String creationDate;
  final bool isDeleted;
  final String creatorUserId;

  Comment(this.id, this.productId, this.description, this.creationDate,
      this.isDeleted, this.creatorUserId);
}