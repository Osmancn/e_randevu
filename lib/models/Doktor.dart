class Doktor{

  int _doktorID;
  String ad;
  String soyad;
  String TC;
  String sifre;
  String email;

  int get doktorID => _doktorID;

  Doktor(this.ad, this.soyad, this.TC, this.sifre,
      this.email);

  Doktor.withID(this._doktorID, this.ad, this.soyad,
      this.TC, this.sifre, this.email);

  Doktor.fromMap(Map<String,dynamic> map)
  {
    this._doktorID = int.parse(map['doktorID'].toString());
    this.ad = map['doktorAdi'].toString();
    this.soyad = map['doktorSoyadi'].toString();
    this.TC = map['doktorTC'].toString();
    this.sifre = map['doktorSifre'].toString();
    this.email = map['doktorEmail'].toString();
  }

  Map<String,dynamic> toMap()
  {
    var map=Map<String,dynamic>();
    map['doktorAdi'] = ad;
    map['doktorSoyadi'] = soyad;
    map['doktorTC'] = TC;
    map['doktorSifre'] = sifre;
    map['doktorEmail'] = email;
    //todo hastanedeki bolumleri ekle
    return map;
  }
}