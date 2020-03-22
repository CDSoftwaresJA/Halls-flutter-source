class Song {
  String name, email, description, genre, picture, song;

  Song(this.name, this.email, this.description, this.genre, this.picture,
      this.song);

  factory Song.fromJson(dynamic json) {
    return Song(
      json['name'] as String,
      json['email'] as String,
      json['description'] as String,
      json['genre'] as String,
      json['picture'] as String,
      json['song'] as String,
    );
  }
}
