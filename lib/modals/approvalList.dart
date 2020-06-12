class Approval {
  final int id;
  final String title;
  final String thumbnailUrl;

  Approval({this.id, this.title, this.thumbnailUrl});

  factory Approval.fromJson(Map<String, dynamic> json) {
    return Approval(
      id: json['id'] as int,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}
