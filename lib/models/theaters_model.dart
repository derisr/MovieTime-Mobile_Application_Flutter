class TheatersModel {
  final int? id;
  final String nama_theaters;
  final String lokasi;
  final String jam_buka;
  final String jam_tutup;
  final String foto;

  const TheatersModel(
      {this.id,
      required this.nama_theaters,
      required this.lokasi,
      required this.jam_buka,
      required this.jam_tutup,
      required this.foto});
  Map<String, dynamic> toList() {
    return {
      'id': id,
      'nama_theaters': nama_theaters,
      'lokasi': lokasi,
      'jam_buka': jam_buka,
      'jam_tutup': jam_tutup,
      'foto': foto
    };
  }

  @override
  String toString() {
    return "{'id': $id, 'nama_theaters': $nama_theaters, 'lokasi': $lokasi, 'jam_buka': $jam_buka, 'jam_tutup': $jam_tutup, 'foto': $foto }";
  }
}
