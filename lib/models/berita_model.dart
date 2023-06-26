// struktur data dalam tabel berita yang ingin kita manipulasi di dalam database. 
class BeritaModel {
  final int? id;
  final String judul_berita;
  final String isi_berita;
  final String gambar;

  const BeritaModel({this.id, required this.judul_berita, required this.isi_berita, required this.gambar});
  Map<String, dynamic> toList() {
    return {'id': id, 'judul_berita': judul_berita, 'isi_berita': isi_berita, 'gambar': gambar};
  }

  @override
  String toString() {
    return "{id: $id, judul_berita: $judul_berita, isi_berita: $isi_berita, gambar: $gambar}";
  }
}
