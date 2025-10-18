class ArticleDataIsEmpty implements Exception {
  final String message;

  const ArticleDataIsEmpty(this.message);

  @override
  String toString() {
    return message;
  }
}
