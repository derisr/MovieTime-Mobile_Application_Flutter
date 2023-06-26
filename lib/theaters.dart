import 'package:flutter/material.dart';
import 'package:movie_time/db_sqlite.dart';

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'models/theaters_model.dart';

void main() {
  runApp(const Theaters());
}

class Theaters extends StatelessWidget {
  const Theaters({super.key});

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
  TextEditingController namatheatersfilmController = TextEditingController();
  TextEditingController lokasiController = TextEditingController();
  TextEditingController jambukaController = TextEditingController();
  TextEditingController jamtutupController = TextEditingController();

  List<Map<String, dynamic>> movie_time = [];

  void refreshData() async {
    final data = await DatabaseHelper.getTheaters();

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
                leading: movie_time[index]['nama_theaters'] != ''
                    ? Image.file(File(movie_time[index]['foto']),
                        // fit: BoxFit.cover)
                        width: 60)
                    : FlutterLogo(),
                title: Text(movie_time[index]['nama_theaters']),
                subtitle: Row(
                  children: [
                    Icon(Icons.schedule),
                    Text(movie_time[index]['jam_buka'] +
                        " - " +
                        movie_time[index]['jam_tutup']),
                    Padding(padding: EdgeInsets.only(right: 1)),
                    Icon(Icons.location_on),
                    Text(movie_time[index]['lokasi']),
                  ],
                ),
                onTap: () {
                  Form(movie_time[index]['id']);
                },
                trailing: IconButton(
                    onPressed: () {
                      hapusTheaters(movie_time[index]['id']);
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
      namatheatersfilmController.text = dataupdate['nama_theaters'];
      lokasiController.text = dataupdate['lokasi'];
      jambukaController.text = dataupdate['jam_buka'];
      jamtutupController.text = dataupdate['jam_tutup'];
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
                    controller: namatheatersfilmController,
                    decoration:
                        const InputDecoration(hintText: "Nama Theaters"),
                  ),
                  TextField(
                    controller: lokasiController,
                    decoration: const InputDecoration(hintText: "Lokasi"),
                  ),
                  TextField(
                    controller: jambukaController,
                    decoration: const InputDecoration(hintText: "Jam Buka"),
                  ),
                  TextField(
                    controller: jamtutupController,
                    decoration: const InputDecoration(hintText: "Jam Tutup"),
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
                          String? foto = photo;
                          final data = TheatersModel(
                              id: id,
                              nama_theaters: namatheatersfilmController.text,
                              lokasi: lokasiController.text,
                              jam_buka: jambukaController.text,
                              jam_tutup: jamtutupController.text,
                              foto: foto.toString());
                          updateTheaters(data);
                          namatheatersfilmController.text = '';
                          lokasiController.text = '';
                          jambukaController.text = '';
                          jamtutupController.text = '';
                          Navigator.pop(context);
                        } else {
                          String? foto = photo;
                          final data = TheatersModel(
                              nama_theaters: namatheatersfilmController.text,
                              lokasi: lokasiController.text,
                              jam_buka: jambukaController.text,
                              jam_tutup: jamtutupController.text,
                              foto: foto.toString());
                          tambahTheaters(data);
                          namatheatersfilmController.text = '';
                          lokasiController.text = '';
                          jambukaController.text = '';
                          jamtutupController.text = '';
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

  Future<void> tambahTheaters(TheatersModel TheatersModel) async {
    await DatabaseHelper.tambahTheaters(TheatersModel);
    return refreshData();
  }

  Future<void> updateTheaters(TheatersModel TheatersModel) async {
    await DatabaseHelper.updateTheaters(TheatersModel);
    return refreshData();
  }

  Future<void> hapusTheaters(int id) async {
    await DatabaseHelper.deleteTheaters(id);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Berhasil Dihapus")));
    return refreshData();
  }
}
