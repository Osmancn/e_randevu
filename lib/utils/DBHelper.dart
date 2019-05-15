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
        where: 'doktorID = ? AND randevuGunu = ? AND randevuAktif = ?',
        whereArgs: [doktorID, gun, 1]);
    var list = List<bool>(14);
    for (int i = 0; i < randevuMap.length; i++) {
      int index = int.parse(randevuMap[i]['saatID'].toString()) - 1;
      list[index] = false;
    }
    return list;
  }

  Future<int> insertRandevu(Map<String, dynamic> randevu) async {
    var db = await _getDataBase();
    int randevuID = await db.insert("tbl_Randevu", randevu);
    return randevuID;
  }

  Future<List<Randevu>> getHastaRandevular(int hastaID) async {
    var db = await _getDataBase();
    var randevularMap = await db
        .query("tbl_Randevu", where: 'hastaID = ?', whereArgs: [hastaID]);
    var randevuList = List<Randevu>();
    for (int i = 0; i < randevularMap.length; i++) {
      randevuList.add(Randevu.fromMap(randevularMap[i]));
    }
    return randevuList;
  }

  Future<Hastane> getHastaneByID(int hastaneID) async {
    var db = await _getDataBase();
    var hastaneMap = await db
        .query("tbl_Hastane", where: 'hastaneID = ?', whereArgs: [hastaneID]);
    return Hastane.fromMap(hastaneMap[0]);
  }

  Future<Doktor> getDoktorByID(int doktorID) async {
    var db = await _getDataBase();
    var doktorMap = await db
        .query("tbl_Doktor", where: 'doktorID = ?', whereArgs: [doktorID]);
    return Doktor.fromMap(doktorMap[0]);
  }

  Future<String> getSaatByID(int saatID) async {
    var db = await _getDataBase();
    var saatMap = await db
        .query("tbl_RandevuSaat", where: 'saatID = ?', whereArgs: [saatID]);
    return saatMap[0]['saatAraligi'].toString();
  }

  randevuIptal(int randevuID) async {
    var db = await _getDataBase();
    var randevuMap = await db
        .query("tbl_Randevu", where: 'randevuID = ?', whereArgs: [randevuID]);
    var randevu = Randevu.fromMap(randevuMap[0]);
    randevu.randevuDurum = false;
    int id = await db.update('tbl_Randevu', randevu.toMap(),
        where: 'randevuID = ?', whereArgs: [randevuID]);
    return id;
  }

  Future<List<Map<String, dynamic>>> getFavoriDoktor(
      int doktorID, int hastaID) async {
    var db = await _getDataBase();
    var map = await db.query("tbl_FavoriDoktorlar",
        where: 'doktorID = ? AND hastaID = ?', whereArgs: [doktorID, hastaID]);
    return map;
  }

  Future<int> insertFavoriDoktor(int doktorID, int hastaID) async {
    var db = await _getDataBase();
    var map = Map<String, dynamic>();
    map['hastaID'] = hastaID;
    map['doktorID'] = doktorID;
    var id = await db.insert("tbl_FavoriDoktorlar", map);
    return id;
  }

  deleteFavoriDoktor(int doktorID, int hastaID) async {
    var db = await _getDataBase();
    var map = Map<String, dynamic>();
    map['hastaID'] = hastaID;
    map['doktorID'] = doktorID;
    var id = await db.delete("tbl_FavoriDoktorlar",
        where: 'doktorID = ? AND hastaID = ?', whereArgs: [doktorID, hastaID]);
    return id;
  }

  Future<List<Map<String, dynamic>>> getFavoriDoktorlarByHastaID(
      int hastaID) async {
    var db = await _getDataBase();
    var favoriDoktorlarMap = await db.query("tbl_favoriDoktorlar",
        where: 'hastaID = ?', whereArgs: [hastaID]);
    return favoriDoktorlarMap;
  }

  Future<Map<String, String>> getHastaneAndBolumByDoktorID(int doktorID) async {
    Doktor d = await getDoktorByID(doktorID);
    var db = await _getDataBase();
    var hbMap = await db.query("tbl_HastanedekiBolumler",
        where: 'hastanedekiBolumlerID = ?',
        whereArgs: [d.hastanedekiBolumlerID]);
    var map = Map<String, String>();
    await getHastaneByID(int.parse(hbMap[0]['hastaneID'].toString()))
        .then((hastane) {
      map['hastane'] = hastane.hastaneAdi;
    });
    await getBolumByBolumID(int.parse(hbMap[0]['bolumID'].toString()))
        .then((bolum) {
      map['bolum'] = bolum.bolumAdi;
    });
    return map;
  }

  Future<int> updateHasta(Hasta hasta) async {
    var db = await _getDataBase();
    int id = await db.update("tbl_Hasta", hasta.toMap(),
        where: 'hastaID = ?', whereArgs: [hasta.hastaId]);
    return id;
  }
}
