import 'package:flutter/material.dart';
import 'package:movie_time/db_sqlite.dart';

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'models/berita_model.dart';

void main() {
  runApp(const Berita());
}

class Berita extends StatelessWidget {
  const Berita({super.key});

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
  TextEditingController judulberitaController = TextEditingController();
  TextEditingController isiberitaController = TextEditingController();

  List<Map<String, dynamic>> movie_time = [];

  void refreshData() async {
    final data = await DatabaseHelper.getBerita();

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
                leading: movie_time[index]['gambar'] != ''
                    ? Image.file(File(movie_time[index]['gambar']),
                        fit: BoxFit.cover)
                    : FlutterLogo(),
                title: Text(movie_time[index]['judul_berita']),
                subtitle: Text(movie_time[index]['isi_berita']),
                onTap: () {
                  Form(movie_time[index]['id']);
                },
                trailing: IconButton(
                    onPressed: () {
                      hapusBerita(movie_time[index]['id']);
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void Form(id) async {
    if (id != null) {
      final dataupdate =
          movie_time.firstWhere((element) => element['id'] == id);
      judulberitaController.text = dataupdate['judul_berita'];
      isiberitaController.text = dataupdate['isi_berita'];
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
                    controller: judulberitaController,
                    decoration: const InputDecoration(hintText: "Judul Berita"),
                  ),
                  TextField(
                    controller: isiberitaController,
                    decoration: const InputDecoration(hintText: "Isi Berita"),
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
                          String? gambar = photo;
                          final data = BeritaModel(
                              id: id,
                              judul_berita: judulberitaController.text,
                              isi_berita: isiberitaController.text,
                              gambar: gambar.toString());
                          updateBerita(data);
                          judulberitaController.text = '';
                          isiberitaController.text = '';
                          Navigator.pop(context);
                        } else {
                          String? gambar = photo;
                          final data = BeritaModel(
                              judul_berita: judulberitaController.text,
                              isi_berita: isiberitaController.text,
                              gambar: gambar.toString());
                          tambahBerita(data);
                          judulberitaController.text = '';
                          isiberitaController.text = '';
                          Navigator.pop(context);
                        }
                      },
                      child: Text(id == null ? "Tambah" : 'Update'))
                ],
              ),
            ),
          );
        });
  }

  Future<void> tambahBerita(BeritaModel BeritaModel) async {
    await DatabaseHelper.tambahBerita(BeritaModel);
    return refreshData();
  }

  Future<void> updateBerita(BeritaModel BeritaModel) async {
    await DatabaseHelper.updateBerita(BeritaModel);
    return refreshData();
  }

  Future<void> hapusBerita(int id) async {
    await DatabaseHelper.deleteBerita(id);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Berhasil Dihapus")));
    return refreshData();
  }
}
