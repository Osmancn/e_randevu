import 'dart:io';
import 'package:e_randevu/models/Bolum.dart';
import 'package:e_randevu/models/Doktor.dart';
import 'package:e_randevu/models/Hasta.dart';
import 'package:e_randevu/models/Hastane.dart';
import 'package:e_randevu/models/Randevu.dart';
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

  Future<List<Hasta>> getHastalar() async {
    var hastalar = List<Hasta>();
    var db = await _getDataBase();
    var hastalarMap = await db.query("tbl_Hasta");
    for (int i = 0; i < hastalarMap.length; i++) {
      hastalar.add(Hasta.fromMap(hastalarMap[i]));
    }
    return hastalar;
  }

  Future<int> insertHasta(Map<String, dynamic> map) async {
    var db = await _getDataBase();
    var hastaID = await db.insert("tbl_Hasta", map);
    return hastaID;
  }

  Future<Hasta> getHastaByTc(String tc) async {
    var db = await _getDataBase();
    var hastaMap = await db.query("tbl_Hasta");
    for (int i = 0; i < hastaMap.length; i++) {
      if (tc == hastaMap[i]['hastaTC']) return Hasta.fromMap(hastaMap[i]);
    }
    return null;
  }

  Future<Hasta> getHastaByID(int id) async {
    var db = await _getDataBase();
    var hastaMap =
        await db.query("tbl_Hasta", where: 'hastaID = ?', whereArgs: [id]);
    return Hasta.fromMap(hastaMap[0]);
  }

  Future<List<String>> getSaatAraligi() async {
    var db = await _getDataBase();
    var saatMap = await db.query("tbl_RandevuSaat");
    var list = List<String>();
    for (int i = 0; i < saatMap.length; i++)
      list.add(saatMap[i]['saatAraligi'].toString());
    return list;
  }

  Future<List<bool>> getSaatAktif(int doktorID, String gun) async {
    var db = await _getDataBase();
    var randevuMap = await db.query("tbl_Randevu",
        where: 'doktorID = ? AND randevuGunu = ?', whereArgs: [doktorID, gun]);
    var list=List<bool>(14);
    for(int i=0;i<randevuMap.length;i++)
      {
        int index=int.parse(randevuMap[i]['saatID'].toString())-1;
        list[index]=false;
      }
    return list;
  }
  Future<int> insertRandevu(Map<String,dynamic> randevu)
  async {
    var db=await _getDataBase();
    int randevuID=await db.insert("tbl_Randevu", randevu);
    return randevuID;
  }
}
