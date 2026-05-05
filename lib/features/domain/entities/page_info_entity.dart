class PageInfoEntity {
  final int count;
  final int pages;
  final String? next;
  final String? prev;

  PageInfoEntity({required this.count, required this.pages, required this.next, required this.prev});

  bool get hasNextPage => next != null;
}
