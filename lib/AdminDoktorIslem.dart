import 'package:e_randevu/models/Bolum.dart';
import 'package:e_randevu/models/Doktor.dart';
import 'package:e_randevu/models/Hastane.dart';
import 'package:e_randevu/utils/DBHelper.dart';
import 'package:flutter/material.dart';

class AdminDoktorIslem extends StatefulWidget {
  @override
  _AdminDoktorIslemState createState() => _AdminDoktorIslemState();
}

class _AdminDoktorIslemState extends State<AdminDoktorIslem> {
  List<Hastane> hastaneler;
  Hastane _secilenHastane;
  Bolum _secilenBolum;
  Doktor _secilenDoktor;
  List<DropdownMenuItem<Hastane>> _dDMenuItemHastane;
  List<DropdownMenuItem<Bolum>> _dDMenuItemBolum;
  List<DropdownMenuItem<Doktor>> _dDMenuItemDoktor;
  bool _autoVali = false;
  TextEditingController _controllerSifre, _controllerTc;
  String _tc, _ad, _soyad, _email, _sifre, _sifreOnay;
  int _hBID;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _controllerSifre = TextEditingController(text: "");
    _controllerTc = TextEditingController(text: "");
    hastaleriGetir().then((hstneler) {
      setState(() {
        hastaneler = hstneler;
        _dDMenuItemHastane = getDropDownMenuHastane();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Doktor İşlem"),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: ExpansionTile(
              title: Text("Doktor Ekle"),
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Hastane : ",
                            style: TextStyle(
                                fontSize: 18, color: Colors.green.shade700),
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
                                  _secilenBolum = null;
                                  _secilenDoktor = null;
                                  _hBID = null;
                                  if (_dDMenuItemDoktor != null)
                                    _dDMenuItemDoktor.clear();
                                  _dDMenuItemBolum = getDropDownMenuBolum();
                                });
                              },
                              value: _secilenHastane,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Bolum : ",
                            style: TextStyle(
                                fontSize: 18, color: Colors.green.shade700),
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
                                  _secilenDoktor = null;
                                  _dDMenuItemDoktor = getDropDownMenuDoktor();
                                  hastanedekiBolumlerIDGetir(
                                          _secilenHastane.hastaneId,
                                          _secilenBolum.bolumID)
                                      .then((value) {
                                    _hBID = value;
                                    debugPrint(_hBID.toString());
                                  });
                                });
                              },
                              value: _secilenBolum,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          //tc no
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 5),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                hintText: "TC kimlik numarasını giriniz",
                                labelText: "TC",
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                prefixIcon: Icon(Icons.chrome_reader_mode),
                              ),
                              maxLength: 11,
                              keyboardType: TextInputType.number,
                              controller: _controllerTc,
                              autovalidate: _autoVali,
                              validator: (value) => _validateTc(value),
                              onSaved: (value) => _tc = value,
                            ),
                          ),
                          //ad
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 5),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                hintText: "Adınızı giriniz",
                                labelText: "Ad",
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                prefixIcon: Icon(Icons.account_box),
                              ),
                              maxLength: 24,
                              keyboardType: TextInputType.text,
                              autovalidate: _autoVali,
                              validator: (value) => _validateIsim(value),
                              onSaved: (value) => _ad = value,
                            ),
                          ),
                          //soyad
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 5),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                hintText: "Soyadınızı giriniz",
                                labelText: "Soyad",
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                prefixIcon: Icon(Icons.account_box),
                              ),
                              maxLength: 24,
                              keyboardType: TextInputType.text,
                              autovalidate: _autoVali,
                              validator: (value) => _validateIsim(value),
                              onSaved: (value) => _soyad = value,
                            ),
                          ),
                          //email
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 5),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                hintText: "Email adresinizi giriniz",
                                labelText: "Email",
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                prefixIcon: Icon(Icons.email),
                              ),
                              maxLength: 32,
                              keyboardType: TextInputType.emailAddress,
                              autovalidate: _autoVali,
                              validator: (value) => _validateEmail(value),
                              onSaved: (value) => _email = value,
                            ),
                          ),
                          //şifre
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 5),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                hintText: "Şifrenizi giriniz",
                                labelText: "Şifre",
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                prefixIcon: Icon(Icons.lock_open),
                              ),
                              maxLength: 16,
                              obscureText: true,
                              autovalidate: _autoVali,
                              validator: (value) {
                                if (value.length < 6)
                                  return "Şifre 6 karakterde küçük olmaz";
                                else
                                  return null;
                              },
                              onSaved: (value) => _sifre = value,
                              controller: _controllerSifre,
                            ),
                          ),
                          //şifre onay
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 5),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                hintText: "Şifrenizi tekrar giriniz",
                                labelText: "Şifre",
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                prefixIcon: Icon(Icons.lock_open),
                              ),
                              maxLength: 16,
                              obscureText: true,
                              onSaved: (value) => _sifreOnay = value,
                              autovalidate: _autoVali,
                              validator: (value) {
                                if (value != _controllerSifre.text.toString())
                                  return "Şifre aynı olmalı";
                                else
                                  return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 90),
                      child: RaisedButton(
                        child: Text("Doktor Ekle"),
                        color: Colors.blue,
                        onPressed: () {
                          if (_kayitOnayla()) {
                            tcKontrol(_controllerTc.text.toString())
                                .then((kontrol) {
                              if (kontrol) {
                                var doktor = Doktor(
                                    _ad,
                                    _soyad,
                                    _controllerTc.text.toString(),
                                    _sifre,
                                    _email,
                                    _hBID);
                                doktorEkle(doktor).then((doktorID) {
                                  setState(() {
                                    hastaleriGetir().then((value) {
                                      _secilenDoktor = null;
                                      _secilenHastane = null;
                                      _secilenBolum = null;
                                      if (_dDMenuItemDoktor != null)
                                        _dDMenuItemDoktor.clear();
                                      if (_dDMenuItemBolum != null)
                                        _dDMenuItemBolum.clear();
                                      _dDMenuItemHastane = _dDMenuItemHastane;
                                    });
                                  });
                                  scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text("Doktor Eklendi"),
                                    duration: Duration(seconds: 5),
                                  ));
                                });
                              } else {
                                scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                      "Böyle bir TC numaralı hasta bulunmakta"),
                                  duration: Duration(seconds: 5),
                                ));
                              }
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            child: ExpansionTile(
              title: Text("Doktor Sil"),
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Hastane : ",
                            style: TextStyle(
                                fontSize: 18, color: Colors.green.shade700),
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
                                  _secilenBolum = null;
                                  _secilenDoktor = null;
                                  if (_dDMenuItemDoktor != null)
                                    _dDMenuItemDoktor.clear();
                                  _hBID = null;
                                  _dDMenuItemBolum = getDropDownMenuBolum();
                                });
                              },
                              value: _secilenHastane,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Bolum : ",
                            style: TextStyle(
                                fontSize: 18, color: Colors.green.shade700),
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
                                  _dDMenuItemDoktor = getDropDownMenuDoktor();
                                  hastanedekiBolumlerIDGetir(
                                          _secilenHastane.hastaneId,
                                          _secilenBolum.bolumID)
                                      .then((value) {
                                    _hBID = value;
                                    debugPrint(_hBID.toString());
                                  });
                                });
                              },
                              value: _secilenBolum,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Doktor : ",
                            style: TextStyle(
                                fontSize: 18, color: Colors.green.shade700),
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
                                  _secilenDoktor = value;
                                });
                              },
                              value: _secilenDoktor,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 90),
                      child: RaisedButton(
                        child: Text("Doktor Sil"),
                        color: Colors.blue,
                        onPressed: () {
                          if (_secilenDoktor != null) {
                            doktorSil(_secilenDoktor).then((value) {
                              hastaleriGetir().then((hstneler) {
                                setState(() {
                                  hastaneler = hstneler;
                                  _secilenBolum = null;
                                  _secilenDoktor = null;
                                  _secilenHastane = null;
                                  _dDMenuItemHastane = getDropDownMenuHastane();
                                  if (_dDMenuItemBolum != null)
                                    _dDMenuItemBolum.clear();
                                  if (_dDMenuItemDoktor != null)
                                    _dDMenuItemDoktor.clear();
                                });
                              });
                              scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text("Doktor Silindi"),
                                duration: Duration(seconds: 5),
                              ));
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Hastane>> hastaleriGetir() async {
    var db = DBHelper();
    var hastanelerr = await db.getHastaneler();
    return hastanelerr;
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

  String _validateEmail(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(email))
      return 'Doğru email giriniz';
    else
      return null;
  }

  String _validateIsim(String isim) {
    RegExp regex = new RegExp("^[a-zA-Z]");
    if (!regex.hasMatch(isim))
      return "Yanlızca harf kullanınız";
    else
      return null;
  }

  String _validateTc(String tc) {
    RegExp regex = new RegExp("^[0-9]+\$");
    if (!regex.hasMatch(tc) || tc.length != 11)
      return "Doğru TC kimlik no giriniz";
    else
      return null;
  }

  bool _kayitOnayla() {
    if (formKey.currentState.validate() && _hBID != null) {
      formKey.currentState.save();
      return true;
    }
    return false;
  }

  Future<bool> tcKontrol(String tc) async {
    var db = DBHelper();
    var doktor = await db.getDoktorByTc(tc);
    if (doktor == null)
      return true;
    else
      return false;
  }

  Future<int> hastanedekiBolumlerIDGetir(int hastaneID, int bolumID) async {
    var db = DBHelper();
    var id = await db.getHastanedekiBolumler(hastaneID, bolumID);
    return id;
  }

  Future<int> doktorEkle(Doktor doktor) async {
    var db = DBHelper();
    var doktorID = await db.insertDoktor(doktor);
    return doktorID;
  }

  Future<int> doktorSil(Doktor doktor) async {
    var db = DBHelper();
    var doktorID = await db.deleteDoktor(doktor);
    return doktorID;
  }


}
