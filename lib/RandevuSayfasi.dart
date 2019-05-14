import 'package:e_randevu/HastaAnaSayfa.dart';
import 'package:e_randevu/models/Bolum.dart';
import 'package:e_randevu/models/Doktor.dart';
import 'package:e_randevu/models/Hastane.dart';
import 'package:e_randevu/models/Randevu.dart';
import 'package:e_randevu/utils/DBHelper.dart';
import 'package:flutter/material.dart';

class RandevuSayfasi extends StatefulWidget {
  @override
  _RandevuSayfasiState createState() => _RandevuSayfasiState();
}

class _RandevuSayfasiState extends State<RandevuSayfasi> {
  List<Hastane> hastaneler;
  Hastane _secilenHastane;
  Bolum _secilenBolum;
  Doktor _secilenDoktor;
  DateTime _secilenTarih = DateTime.now();
  String _secilenTarihString = "";
  int _secilenSaatId;
  List<DropdownMenuItem<Hastane>> _dDMenuItemHastane;
  List<DropdownMenuItem<Bolum>> _dDMenuItemBolum;
  List<DropdownMenuItem<Doktor>> _dDMenuItemDoktor;
  List<String> saatAraligi;
  List<bool> saatAktif;

  String _validator = "";

  @override
  void initState() {
    // TODO: implement initState
    HastaleriGetir().then((hstneler) {
      setState(() {
        hastaneler = hstneler;
        _dDMenuItemHastane = getDropDownMenuHastane();
      });
    });
    saatAraligi = List<String>(14);
    saatAraligiGetir().then((value) {
      setState(() {
        saatAraligi = value;
      });
    });
    setState(() {
      _secilenTarihString = "" +
          _secilenTarih.day.toString() +
          "." +
          _secilenTarih.month.toString() +
          "." +
          _secilenTarih.year.toString();
    });
    saatAktif = List<bool>(14);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Randevu")),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 40),
          //Başlık
          Center(
            child: Text(
              "Randevu",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
          ),
          //cbbox Hastane
          Container(
            margin: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
            child: Row(
              children: <Widget>[
                Text(
                  "Hastane : ",
                  style: TextStyle(fontSize: 18, color: Colors.green.shade700),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: DropdownButton<Hastane>(
                    isExpanded: true,
                    items: _dDMenuItemHastane,
                    onChanged: (value) {
                      setState(() {
                        _secilenHastane = value;
                        if (_dDMenuItemBolum != null) _dDMenuItemBolum.clear();
                        _secilenBolum = null;
                        if (_dDMenuItemDoktor != null)
                          _dDMenuItemDoktor.clear();
                        _secilenDoktor = null;
                        _dDMenuItemBolum = getDropDownMenuBolum();
                        _secilenSaatId = null;
                      });
                    },
                    value: _secilenHastane,
                  ),
                )
              ],
            ),
          ),
          //cbbox Bolum
          Container(
            margin: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
            child: Row(
              children: <Widget>[
                Text(
                  "Bolum : ",
                  style: TextStyle(fontSize: 18, color: Colors.green.shade700),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: DropdownButton<Bolum>(
                    isExpanded: true,
                    items: _dDMenuItemBolum,
                    onChanged: (value) {
                      setState(() {
                        _secilenBolum = value;
                        if (_dDMenuItemDoktor != null)
                          _dDMenuItemDoktor.clear();
                        _secilenDoktor = null;
                        _dDMenuItemDoktor = getDropDownMenuDoktor();
                        _secilenSaatId = null;
                      });
                    },
                    value: _secilenBolum,
                  ),
                )
              ],
            ),
          ),
          //cbbox doktor
          Container(
            margin: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
            child: Row(
              children: <Widget>[
                Text(
                  "Doktor : ",
                  style: TextStyle(fontSize: 18, color: Colors.green.shade700),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: DropdownButton<Doktor>(
                    isExpanded: true,
                    items: _dDMenuItemDoktor,
                    onChanged: (value) {
                      setState(() {
                        _secilenSaatId = null;
                        _secilenDoktor = value;
                        saatAktifGetir(value.doktorID, _secilenTarihString)
                            .then((value) {
                          setState(() {
                            saatAktif = value;
                          });
                        });
                      });
                    },
                    value: _secilenDoktor,
                  ),
                )
              ],
            ),
          ),
          //Tarih
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "Tarih : ",
                style: TextStyle(fontSize: 18, color: Colors.green.shade700),
              ),
              Text(
                _secilenTarihString,
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              GestureDetector(
                child: Icon(
                  Icons.date_range,
                  color: Colors.cyan.shade600,
                ),
                onTap: () {
                  showDatePicker(
                          context: context,
                          firstDate: DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day),
                          initialDate: _secilenTarih,
                          lastDate: DateTime(DateTime.now().year,
                              DateTime.now().month + 3, DateTime.now().day))
                      .then((secilenTrh) {
                    setState(() {
                      if (secilenTrh != null) {
                        _secilenTarih = secilenTrh;
                        _secilenSaatId = null;
                      }
                      _secilenTarihString = "" +
                          _secilenTarih.day.toString() +
                          "." +
                          _secilenTarih.month.toString() +
                          "." +
                          _secilenTarih.year.toString();
                      if (_secilenDoktor != null)
                        saatAktifGetir(
                                _secilenDoktor.doktorID, _secilenTarihString)
                            .then((value) {
                          setState(() {
                            saatAktif = value;
                          });
                        });
                    });
                  });
                },
              )
            ],
          ),
          SizedBox(height: 20),
          //randevu saati
          Container(
            child: ExpansionTile(
                title: Center(
                  child: Text(
                    "Randevu Saati",
                    style:
                        TextStyle(fontSize: 18, color: Colors.green.shade700),
                  ),
                ),
                children: <Widget>[
                  saatler(),
                ]),
          ),
          SizedBox(
            height: 20,
          ),
          //validator
          Center(
            child: Text(
              _validator,
              style: TextStyle(
                fontSize: 14,
                color: Colors.red,
              ),
            ),
          ),
          //randevu buton
          Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 80),
            child: RaisedButton.icon(
              icon: Icon(Icons.navigate_next),
              label: Text(
                "Devam",
                style: TextStyle(fontSize: 18),
              ),
              color: Colors.cyan,
              onPressed: () {
                if (_secilenDoktor != null &&
                    _secilenBolum != null &&
                    _secilenDoktor != null &&
                    _secilenSaatId != null) {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        elevation: 10,
                        backgroundColor: Colors.white,
                        title: Text("Randevu Onayla"),
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text("Hastane : ${_secilenHastane.hastaneAdi}\n" +
                                  "Hastane Adresi : ${_secilenHastane.hastaneAdresi}\n" +
                                  "Bölüm : ${_secilenBolum.bolumAdi}\n" +
                                  "Doktor : ${_secilenDoktor.ad} ${_secilenDoktor.soyad}\n" +
                                  "Tarih : ${_secilenTarihString}\n" +
                                  "Saat : ${saatAraligi[_secilenSaatId - 1]}"),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  RaisedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    color: Colors.red.shade500,
                                    child: Text("Vazgeç"),
                                    elevation: 10,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  RaisedButton(
                                    onPressed: () {
                                      RandevuAl(Randevu(
                                              _secilenDoktor.doktorID,
                                              HastaAnaSayfa.hastaID,
                                              _secilenTarihString,
                                              true,
                                              _secilenSaatId))
                                          .then(
                                        (value) {
                                          Navigator.pushNamed(context,
                                              "/HastaAnaSayfa/${HastaAnaSayfa.hastaID}");
                                        },
                                      );
                                    },
                                    color: Colors.green.shade500,
                                    child: Text("Randevu Al"),
                                    elevation: 10,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      );
                    },
                  );
                } else {
                  setState(() {
                    _validator = "Lütfen bütün alanları doldurunuz";
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Hastane>> HastaleriGetir() async {
    var db = await DBHelper();
    var hastanelerr = await db.getHastaneler();
    return hastanelerr;
  }

  Future<List<String>> saatAraligiGetir() async {
    var db = await DBHelper();
    var s = await db.getSaatAraligi();
    return s;
  }

  Future<List<bool>> saatAktifGetir(int doktorID, String gun) async {
    var db = await DBHelper();
    var s = await db.getSaatAktif(doktorID, gun);
    return s;
  }

  List<DropdownMenuItem<Hastane>> getDropDownMenuHastane() {
    List<DropdownMenuItem<Hastane>> ddMenuHastane = new List();
    for (int i = 0; i < hastaneler.length; i++) {
      ddMenuHastane.add(new DropdownMenuItem<Hastane>(
        child: Text(hastaneler[i].hastaneAdi),
        value: hastaneler[i],
      ));
    }
    return ddMenuHastane;
  }

  List<DropdownMenuItem<Bolum>> getDropDownMenuBolum() {
    List<DropdownMenuItem<Bolum>> ddMenuBolum = new List();

    for (int i = 0; i < _secilenHastane.bolumler.length; i++) {
      ddMenuBolum.add(new DropdownMenuItem<Bolum>(
        child: Text(_secilenHastane.bolumler[i].bolumAdi),
        value: _secilenHastane.bolumler[i],
      ));
    }
    return ddMenuBolum;
  }

  List<DropdownMenuItem<Doktor>> getDropDownMenuDoktor() {
    List<DropdownMenuItem<Doktor>> ddMenuDoktor = new List();
    for (int i = 0; i < _secilenBolum.doktorlar.length; i++) {
      ddMenuDoktor.add(new DropdownMenuItem<Doktor>(
        child: Text(_secilenBolum.doktorlar[i].ad +
            " " +
            _secilenBolum.doktorlar[i].soyad),
        value: _secilenBolum.doktorlar[i],
      ));
    }
    return ddMenuDoktor;
  }

  Color saatAraligiRenk(int index) {
    if (saatAktif[index] == false) return Colors.red.shade300;
    if (_secilenSaatId == index + 1) return Colors.green.shade300;
    return Colors.white;
  }

  bool doktorSecildimi() {
    if (_secilenDoktor != null)
      return true;
    else
      return false;
  }

  Widget saatler() {
    if (!doktorSecildimi())
      return Center(
          child: Text(
        "ilk önce doktor seçiniz",
        style: TextStyle(
          fontSize: 17,
          color: Colors.red,
        ),
      ));

    return GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 3,
      padding: const EdgeInsets.all(20.0),
      crossAxisSpacing: 10.0,
      childAspectRatio: MediaQuery.of(context).size.width /
          (MediaQuery.of(context).size.height / 4),
      children: List.generate(
        14,
        (index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                if (saatAktif[index] != false)
                  setState(() {
                    _secilenSaatId = index + 1;
                  });
              },
              child: Material(
                color: saatAraligiRenk(index),
                elevation: 10,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(
                  child: Center(
                    child: Text("" + saatAraligi[index]),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<int> RandevuAl(Randevu randevu) async {
    var dbhelper = await DBHelper();
    int randevuID = await dbhelper.insertRandevu(randevu.toMap());
    return randevuID;
  }
}
