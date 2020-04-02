class Song {
  String name, email, description, genre, picture, song;
  String json;

  Song(this.name, this.email, this.description, this.genre, this.picture,
      this.song);

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'description': description,
        'genre': genre,
        'picture': picture,
        'song': song,
      };

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
