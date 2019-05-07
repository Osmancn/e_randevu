import 'package:e_randevu/models/Bolum.dart';

class Hastane{

  int _hastaneId;
  String hastaneAdi;
  String hastaneAdresi;
  List<Bolum> bolumler=new List<Bolum>();

  int get hastaneId => _hastaneId;

  Hastane(this.hastaneAdi, this.hastaneAdresi);

  Hastane.withID(this._hastaneId, this.hastaneAdi, this.hastaneAdresi);

  Hastane.fromMap(Map<String,dynamic> map)
  {
    _hastaneId=int.parse(map['hastaneID'].toString());
    hastaneAdi=map['hastaneAdi'];
    hastaneAdresi=map['hastaneAdresi'];
  }

  Map<String,dynamic>toMap()
  {
    var map=Map<String,dynamic>();
    map['hastaneAdi']=hastaneAdi;
    map['hastaneAdresi']=hastaneAdresi;
    return map;
  }
}