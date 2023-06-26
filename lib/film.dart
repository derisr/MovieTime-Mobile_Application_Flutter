import 'package:flutter/material.dart';
import 'package:movie_time/db_sqlite.dart';

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'models/film_model.dart';

void main() {
  runApp(const Film());
}

class Film extends StatelessWidget {
  const Film({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(title: 'Movie Time'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController judulfilmController = TextEditingController();
  TextEditingController genreController = TextEditingController();
  TextEditingController tanggaltayangController = TextEditingController();
  TextEditingController sinopsisController = TextEditingController();

  List<Map<String, dynamic>> movie_time = [];

  void refreshData() async {
    final data = await DatabaseHelper.getFilm();

    setState(() {
      movie_time = data;
    });
  }

  @override
  void initState() {
    refreshData();
    super.initState();
  }

  String? photo;
  Future<String> getFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'png',
        'webm',
      ],
    );

    if (result != null) {
      PlatformFile sourceFile = result.files.first;
      final destination = await getExternalStorageDirectory();
      File? destinationFile =
          File('${destination!.path}/${sourceFile.name.hashCode}');
      final newFile =
          File(sourceFile.path!).copy(destinationFile.path.toString());
      setState(() {
        photo = destinationFile.path;
      });
      File(sourceFile.path!.toString()).delete();
      return destinationFile.path;
    } else {
      return "Dokumen belum diupload";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: movie_time.length,
        itemBuilder: (context, index) {
          return Card(
              elevation: 5,
              child: ListTile(
                leading: movie_time[index]['judul_film'] != ''
                    ? Image.file(File(movie_time[index]['poster']),
                        fit: BoxFit.cover)
                    : FlutterLogo(),
                title: Text(movie_time[index]['judul_film'],
                    style: TextStyle(fontSize: 17)),
                subtitle: Text(movie_time[index]['genre'] +
                    "  -  " +
                    movie_time[index]['tanggal_tayang'] +
                    "  -  " +
                    movie_time[index]['sinopsis']),
                onTap: () {
                  Form(movie_time[index]['id']);
                },
                trailing: IconButton(
                    onPressed: () {
                      hapusFilm(movie_time[index]['id']);
                    },
                    icon: const Icon(Icons.delete)),
              ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Form(null);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // Koma tambahan ini membuat pemformatan otomatis lebih baik untuk metode build.
    );
  }

  void Form(id) async {
    if (id != null) {
      final dataupdate =
          movie_time.firstWhere((element) => element['id'] == id);
      judulfilmController.text = dataupdate['judul_film'];
      genreController.text = dataupdate['genre'];
      tanggaltayangController.text = dataupdate['tanggal_tayang'];
      sinopsisController.text = dataupdate['sinopsis'];
    }
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            height: 800,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: judulfilmController,
                    decoration: const InputDecoration(hintText: "Judul Film"),
                  ),
                  TextField(
                    controller: genreController,
                    decoration: const InputDecoration(hintText: "Genre"),
                  ),
                  TextField(
                    controller: tanggaltayangController,
                    decoration:
                        const InputDecoration(hintText: "Tanggal Tayang"),
                  ),
                  TextField(
                    controller: sinopsisController,
                    decoration: const InputDecoration(hintText: "Sinopsis"),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        getFilePicker();
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.camera),
                          Text("Pilih Gambar")
                        ],
                      )),
                  ElevatedButton(
                      onPressed: () async {
                        if (id != null) {
                          String? poster = photo;
                          final data = FilmModel(
                              id: id,
                              judul_film: judulfilmController.text,
                              genre: genreController.text,
                              tanggal_tayang: tanggaltayangController.text,
                              sinopsis: sinopsisController.text,
                              poster: poster.toString());
                          updateFilm(data);
                          judulfilmController.text = '';
                          genreController.text = '';
                          tanggaltayangController.text = '';
                          sinopsisController.text = '';
                          Navigator.pop(context);
                        } else {
                          String? poster = photo;
                          final data = FilmModel(
                              judul_film: judulfilmController.text,
                              genre: genreController.text,
                              tanggal_tayang: tanggaltayangController.text,
                              sinopsis: sinopsisController.text,
                              poster: poster.toString());
                          tambahFilm(data);
                          judulfilmController.text = '';
                          genreController.text = '';
                          tanggaltayangController.text = '';
                          sinopsisController.text = '';
                          Navigator.pop(context);
                        }
                      },
                      child: Text(id == null ? "Tambah" : 'update'))
                ],
              ),
            ),
          );
        });
  }

  Future<void> tambahFilm(FilmModel FilmModel) async {
    await DatabaseHelper.tambahFilm(FilmModel);
    return refreshData();
  }

  Future<void> updateFilm(FilmModel FilmModel) async {
    await DatabaseHelper.updateFilm(FilmModel);
    return refreshData();
  }

  Future<void> hapusFilm(int id) async {
    await DatabaseHelper.deleteFilm(id);
    ScaffoldMessenger.of(context) 
        .showSnackBar(SnackBar(content: Text("Berhasil Dihapus")));
    return refreshData();
  }
}
