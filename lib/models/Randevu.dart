class Randevu {
  int _randevuID;
  int doktorID;
  int hastaID;
  String randevuGunu;
  bool randevuDurum;
  int saatID;

  int get randevuID => _randevuID;

  Randevu(this.doktorID, this.hastaID, this.randevuGunu, this.randevuDurum,
      this.saatID);

  Randevu.withID(this._randevuID, this.doktorID, this.hastaID, this.randevuGunu,
      this.randevuDurum, this.saatID);

  Randevu.fromMap(Map<String, dynamic> map) {
    _randevuID = int.parse(map['randevuID']);
    doktorID = int.parse(map['doktorID']);
    hastaID = int.parse(map['hastaID']);
    randevuGunu = map['randevuGunu'];
    randevuDurum = map['randevuAktif'] == 1 ? true : false;
    saatID=int.parse(map['saatID'].toString());
  }

  Map<String,dynamic> toMap()
  {
    var map =new Map<String,dynamic>();
    map['randevuID']=_randevuID;
    map['doktorID']=doktorID;
    map['hastaID']=hastaID;
    map['randevuGunu']=randevuGunu;
    map['saatID']=saatID;
    map['randevuAktif']=randevuDurum;
    return map;
  }
}
