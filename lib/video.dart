class Video {
  String description;
  String sources;
  String subtitle;
  String thumb;
  String title;

  Video(
      {required this.description,
      required this.sources,
      required this.subtitle,
      required this.thumb,
      required this.title});

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      description: json['description'],
      sources: json['sources'],
      subtitle: json['subtitle'],
      thumb: json['thumb'],
      title: json['title'],
    );
  }
}
