class Doktor{

  int _doktorID;
  int hastanedekiBolumlerID;
  String ad;
  String soyad;
  String TC;
  String sifre;
  String email;

  int get doktorID => _doktorID;

  Doktor(this.ad, this.soyad, this.TC, this.sifre,
      this.email,this.hastanedekiBolumlerID);

  Doktor.withID(this._doktorID, this.ad, this.soyad,
      this.TC, this.sifre, this.email,this.hastanedekiBolumlerID);

  Doktor.fromMap(Map<String,dynamic> map)
  {
    this._doktorID = int.parse(map['doktorID'].toString());
    this.ad = map['doktorAdi'].toString();
    this.soyad = map['doktorSoyadi'].toString();
    this.TC = map['doktorTc'].toString();
    this.sifre = map['doktorSifre'].toString();
    this.email = map['doktorEmail'].toString();
    this.hastanedekiBolumlerID=int.parse(map['hastanedekiBolumlerID'].toString());
  }

  Map<String,dynamic> toMap()
  {
    var map=Map<String,dynamic>();
    map['doktorAdi'] = ad;
    map['doktorSoyadi'] = soyad;
    map['doktorTc'] = TC;
    map['doktorSifre'] = sifre;
    map['doktorEmail'] = email;
    map['hastanedekiBolumlerID']=hastanedekiBolumlerID;
    return map;
  }
}