import 'dart:io';

import 'package:e_randevu/models/Bolum.dart';
import 'package:e_randevu/models/Doktor.dart';
import 'package:e_randevu/models/Hastane.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

class DBHelper {
  static DBHelper _dbHelper;
  static Database _database;

  factory DBHelper() {
    if (_dbHelper == null) {
      _dbHelper = DBHelper._internal();
      return _dbHelper;
    } else
      return _dbHelper;
  }

  DBHelper._internal();

  Future<Database> _getDataBase() async {
    if (_database == null) {
      _database = await _initializeDataBase();
      return _database;
    } else
      return _database;
  }

  _initializeDataBase() async {
    var lock = Lock();
    Database _db;
    if (_db == null) {
      await lock.synchronized(() async {
        if (_db == null) {
          var databasesPath = await getDatabasesPath();
          var path = join(databasesPath, "dbeHastane.db");
          var file = new File(path);
          print("path : " + path.toString());
          // check if file exists
          if (!await file.exists()) {
            // Copy from asset
            print("deneme 11");
            ByteData data =
                await rootBundle.load(join("assets", "dbeHastane.db"));
            print("deneme 22");
            List<int> bytes =
                data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
            await new File(path).writeAsBytes(bytes);
          }
          // open the database
          _db = await openDatabase(path);
        }
      });
    }
    return _db;
  }

  Future<List<Hastane>> getHastaneler() async {
    var db = await _getDataBase();
    var hastaneler = List<Hastane>();
    var hastaneMap = await db.query("tbl_Hastane");
    for (int i = 0; i < hastaneMap.length; i++) {
      Hastane h = Hastane.fromMap(hastaneMap[i]);
      h.bolumler = await getBolumlerByHastaneID(h.hastaneId);
      hastaneler.add(h);
    }
    return hastaneler;
  }

  Future<List<Bolum>> getBolumlerByHastaneID(int hID) async {
    var bolumler = List<Bolum>();
    var db = await _getDataBase();
    var hastanedekiBolumlerMap = await db.query("tbl_HastanedekiBolumler",
        where: 'hastaneID = ?', whereArgs: [hID]);
    for (int i = 0; i < hastanedekiBolumlerMap.length; i++) {

      int bolumID = int.parse(hastanedekiBolumlerMap[i]['bolumID'].toString());

      int hastanedekiBolumlerID = int.parse(
          hastanedekiBolumlerMap[i]['hastanedekiBolumlerID'].toString());
      var bolum = await getBolumByBolumID(bolumID);
      bolum.doktorlar =
          await getDoktorlarByHastanedekiBolumlerID(hastanedekiBolumlerID);
      bolumler.add(bolum);
    }
    return bolumler;
  }

  Future<Bolum> getBolumByBolumID(int id) async {
    Bolum b;
    var db = await _getDataBase();
    var map =
        await db.query("tbl_Bolum", where: "bolumID = ?", whereArgs: [id]);
    b = Bolum.fromMap(map[0]);
    return b;
  }

  Future<List<Doktor>> getDoktorlarByHastanedekiBolumlerID(int id) async {
    var doktorlar = List<Doktor>();
    var db = await _getDataBase();
    var doktorlarMap = await db.query("tbl_Doktor",
        where: 'hastanedekiBolumlerID = ?', whereArgs: [id]);
    for (int i = 0; i < doktorlarMap.length; i++) {
      doktorlar.add(Doktor.fromMap(doktorlarMap[i]));
    }
    return doktorlar;
  }

  Deneme() async {
    var db = await _getDataBase();
    var sonuc = await db.query("tbl_Hastane");
    print("Hastaneler :" + sonuc.toString());

    sonuc = await db.query("tbl_Bolum");
    print("Bolumler :" + sonuc.toString());

    sonuc = await db.query("tbl_HastanedekiBolumler");
    print("h Bolumler :" + sonuc.toString());

    sonuc = await db.query("tbl_doktor");
    print("Doktor :" + sonuc.toString());
  }
}
