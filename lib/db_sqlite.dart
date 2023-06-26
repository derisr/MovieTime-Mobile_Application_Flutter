import 'package:movie_time/models/film_model.dart';
import 'package:movie_time/models/theaters_model.dart';
import 'package:movie_time/models/berita_model.dart';

import 'package:sqflite/sqflite.dart' as sql; //import package database
import 'package:path/path.dart'; 
import 'dart:async'; //import proses compile asyncronus

import 'package:flutter/widgets.dart'; 

// membuat databse
class DatabaseHelper {
  static Future<sql.Database> db() async {
    return sql.openDatabase(join(await sql.getDatabasesPath(), 'movie_time.db'),
        version: 1, onCreate: (database, version) async {
      
      // membuat tabel
      await database.execute("""
        CREATE TABLE film (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          judul_film TEXT,
          genre TEXT,
          tanggal_tayang TEXT,
          sinopsis TEXT,
          poster TEXT
        )
      """);

      await database.execute("""
        CREATE TABLE theaters (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          nama_theaters TEXT,
          lokasi TEXT,
          jam_buka TEXT,
          jam_tutup TEXT,
          foto TEXT
        )
      """);

      await database.execute("""
        CREATE TABLE berita (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          judul_berita text,
          isi_berita text,
          gambar text
        )
      """);
    });
  }

// mendeklarasi method untuk crud

  static Future<int> tambahFilm(FilmModel film) async { // mengembalikan jumlah item yang dimasukkan sebagai bilangan bulat
    final db = await DatabaseHelper.db(); //membuka database
    final data = film.toList();
    return db.insert('film', data);
  }

  static Future<int> tambahTheaters(TheatersModel theaters) async {
    final db = await DatabaseHelper.db();
    final data =theaters.toList();
    return db.insert('theaters', data);
  }

  static Future<int> tambahBerita(BeritaModel berita) async {
    final db = await DatabaseHelper.db();
    final data =berita.toList();
    return db.insert('berita', data);
  }


  static Future<List<Map<String, dynamic>>> getFilm() async {
    final db = await DatabaseHelper.db();
    return db.query("film");
  }

  static Future<List<Map<String, dynamic>>> getTheaters() async {
    final db = await DatabaseHelper.db();
    return db.query("theaters");
  }

  static Future<List<Map<String, dynamic>>> getBerita() async {
    final db = await DatabaseHelper.db();
    return db.query("berita");
  }


  static Future<int> updateFilm(
      FilmModel film) async {
    final db = await DatabaseHelper.db();
    final data = film.toList();
    return db.update('film', data, where: "id=?", whereArgs: [film.id]);
  }

  static Future<int> updateTheaters(
      TheatersModel theaters) async {
    final db = await DatabaseHelper.db();
    final data = theaters.toList();
    return db.update('theaters', data, where: "id=?", whereArgs: [theaters.id]);
  }

  static Future<int> updateBerita(
      BeritaModel berita) async {
    final db = await DatabaseHelper.db();
    final data = berita.toList();
    return db.update('berita', data, where: "id=?", whereArgs: [berita.id]);
  }


  static Future<int> deleteFilm(int id) async {
    final db = await DatabaseHelper.db();
    return db.delete('film', where: 'id=$id');
  }

  static Future<int> deleteTheaters(int id) async {
    final db = await DatabaseHelper.db();
    return db.delete('theaters', where: 'id=$id');
  }

  static Future<int> deleteBerita(int id) async {
    final db = await DatabaseHelper.db();
    return db.delete('berita', where: 'id=$id');
  }
}
