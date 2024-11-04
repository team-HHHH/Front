class TagNode {
  final String title;
  final String content;
  final DateTime timeDetail;
  final int tag; //tag number 1:blue, 2:yellow, 3:green, 4:black, 5:red
  final int sid; //scheulder 고유id

  TagNode({
    required this.title,
    required this.content,
    required this.timeDetail,
    required this.tag,
    required this.sid,
  });
}
