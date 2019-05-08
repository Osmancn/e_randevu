import 'package:e_randevu/models/Doktor.dart';

class Bolum{

  int _bolumID;
  String bolumAdi;

  List<Doktor> doktorlar=new List<Doktor>();

  int get bolumID => _bolumID;

  Bolum(this.bolumAdi);

  Bolum.withID(this._bolumID, this.bolumAdi);

  Bolum.fromMap(Map<String,dynamic> map)
  {
    _bolumID=int.parse(map['bolumID'].toString());
    bolumAdi=map['bolumAdi'];
  }

  Map<String,dynamic> toMap()
  {
    var map=Map<String,dynamic>();
    map['bolumAdi']=bolumAdi;
    return map;
  }
}