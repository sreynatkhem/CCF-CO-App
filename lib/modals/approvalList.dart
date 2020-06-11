class Album {
  final dynamic albumId;
  final dynamic id;
  final dynamic title;
  final dynamic url;
  final dynamic thumbnailUrl;

  Album({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});

  // static Album fromJson(dynamic json) {
  //   return Album(
  //     albumId: json['albumId'],
  //     id: json['id'],
  //     title: json['title'],
  //     url: json['url'],
  //     thumbnailUrl: json['thumbnailUrl'],
  //   );
  // }
  // static Album fromJson(List<dynamic> parsedJson) {
  //   return Album(
  //   []);
  // }
}
