class Track {
  final String title;
  final String audioPath;

  const Track({
    required this.title,
    required this.audioPath,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      title: json['title'] as String,
      audioPath: json['audioPath'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'audioPath': audioPath,
    };
  }

  @override
  String toString() {
    return title;
  }
}