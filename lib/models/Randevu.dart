class Randevu {
  int _randevuID;
  int doktorID;
  int hastaID;
  String randevuGunu;
  bool randevuDurum;
  String randevuSaati;

  int get randevuID => _randevuID;

  Randevu(this.doktorID, this.hastaID, this.randevuGunu, this.randevuDurum,
      this.randevuSaati);

  Randevu.withID(this._randevuID, this.doktorID, this.hastaID, this.randevuGunu,
      this.randevuDurum, this.randevuSaati);

  Randevu.fromMap(Map<String, dynamic> map) {
    _randevuID = int.parse(map['randevuID']);
    doktorID = int.parse(map['doktorID']);
    hastaID = int.parse(map['hastaID']);
    randevuGunu = map['randevuGunu'];
    randevuDurum = map['randevuAktif'] == 1 ? true : false;
    //TODO saat ıd saate çevir
  }

  Map<String,dynamic> toMap()
  {
    var map =new Map<String,dynamic>();
    map['randevuID']=_randevuID;
    map['doktorID']=doktorID;
    map['hastaID']=hastaID;
    map['randevuGunu']=randevuGunu;
    //todo saati saatID ye çevir map['randevuSaati']=randevuSaati;
    map['randevuAktif']=randevuDurum;
    return map;
  }
}
