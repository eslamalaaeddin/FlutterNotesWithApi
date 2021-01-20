class Note{
  String id;
  String title;
  String content;
  DateTime creationDateTime;
  DateTime latestEditDateTime;

  Note({this.id, this.title, this.content, this.creationDateTime, this.latestEditDateTime});

  @override
  String toString() {
    return '($id $title $creationDateTime $latestEditDateTime)';
  }

  factory Note.fromJson(Map<String, dynamic> item) {
    return Note(
      id: item['noteID'],
      title: item['noteTitle'],
      content: item['noteContent'],
      creationDateTime: DateTime.parse(item['createDateTime']),
      latestEditDateTime: item['latestEditDateTime'] != null ? DateTime.parse(item['latestEditDateTime']) : null,
    );
  }
}