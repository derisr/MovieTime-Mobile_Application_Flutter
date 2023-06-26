class FilmModel {
  final int? id;
  final String judul_film;
  final String genre;
  final String tanggal_tayang;
  final String sinopsis;
  final String poster;

  const FilmModel(
      {this.id,
      required this.judul_film,
      required this.genre,
      required this.tanggal_tayang,
      required this.sinopsis,
      required this.poster});
  Map<String, dynamic> toList() {
    return {
      'id': id,
      'judul_film': judul_film,
      'genre': genre,
      'tanggal_tayang': tanggal_tayang,
      'sinopsis': sinopsis,
      'poster': poster
    };
  }

  @override
  String toString() {
    return "{id: $id, judul_film: $judul_film, genre: $genre, tanggal_tayang: $tanggal_tayang, sinopsis: $sinopsis, poster: $poster}";
  }
}
