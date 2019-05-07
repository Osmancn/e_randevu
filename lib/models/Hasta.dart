

import 'package:e_randevu/models/Doktor.dart';

class Hasta{
  int _hastaId;
  String ad;
  String soyad;
  String TC;
  String sifre;
  String email;
  List<Doktor> favoriDoktorlar=List<Doktor>();

  int get hastaId => _hastaId;

  Hasta(this.ad, this.soyad, this.TC, this.sifre, this.email);

  Hasta.withID(this._hastaId, this.ad, this.soyad, this.TC, this.sifre,
      this.email);

  Hasta.fromMap(Map<String,dynamic> map)
  {
    this._hastaId=int.parse(map['hastaID'].toString());
    this.ad = map['hastaAdi'].toString();
    this.soyad = map['hastaSoyadi'].toString();
    this.TC = map['hastaTC'].toString();
    this.sifre = map['hastaSifre'].toString();
    this.email = map['hastaEmail'].toString();
  }

  Map<String,dynamic> toMap()
  {
    var map=Map<String,dynamic>();
    map['hastaAdi'] = ad;
    map['hastaSoyadi'] = soyad;
    map['hastaTC'] = TC;
    map['hastaSifre'] = sifre;
    map['hastaEmail'] =email;
    return map;
  }


}