import 'package:e_randevu/models/Bolum.dart';
import 'package:e_randevu/models/Hastane.dart';
import 'package:e_randevu/utils/DBHelper.dart';
import 'package:flutter/material.dart';

class AdminBolumIslem extends StatefulWidget {
  @override
  _AdminBolumIslemState createState() => _AdminBolumIslemState();
}

class _AdminBolumIslemState extends State<AdminBolumIslem> {
  String yeniBolumAdi;
  Hastane _secilenHastane;
  Bolum _secilenBolum;
  Bolum _secilenBolumm;
  List<DropdownMenuItem<Hastane>> _dDMenuItemHastane;
  List<DropdownMenuItem<Bolum>> _dDMenuItemBolum;
  List<DropdownMenuItem<Bolum>> _dDMenuItemHBBolum;
  List<DropdownMenuItem<Bolum>> _dDMenuItemBolumler;
  List<Hastane> hastaneler;
  List<Bolum> bolumler;
  final yeniBolumFormKey = GlobalKey<FormState>();
  final guncelleBolumlerFormKey = GlobalKey<FormState>();
  final guncelleFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    hastaleriGetir().then((hstneler) {
      setState(() {
        hastaneler = hstneler;
        _dDMenuItemHastane = getDropDownMenuHastane();
      });
    });
    bolumleriGetir().then((value) {
      setState(() {
        bolumler = value;
        _dDMenuItemBolumler = getDropDownMenuBolumler();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Bölüm İşlem"),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: ExpansionTile(
              title: Text("Bölüm Ekle"),
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Form(
                      key: yeniBolumFormKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 5),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                hintText: "Yeni Bölüm Adını Giriniz",
                                labelText: "Bölüm",
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                prefixIcon: Icon(Icons.local_hospital),
                              ),
                              maxLength: 20,
                              keyboardType: TextInputType.text,
                              autovalidate: false,
                              validator: (value) {
                                if (value.length < 4)
                                  return "4 ten karakterden fazla olması gerekmekte";
                              },
                              onSaved: (value) => yeniBolumAdi = value,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 90),
                      child: RaisedButton(
                        child: Text("Bölümü Kaydet"),
                        color: Colors.green.shade300,
                        onPressed: () {
                          if (yeniBolumFormKey.currentState.validate()) {
                            yeniBolumFormKey.currentState.save();
                            bolumEkle(Bolum(yeniBolumAdi)).then((value) {
                              debugPrint("yeni bolum ID : " + value.toString());
                              hastaleriGetir().then((hstneler) {
                                setState(() {
                                  hastaneler = hstneler;
                                  _secilenHastane = null;
                                  _dDMenuItemHastane = getDropDownMenuHastane();
                                });
                              });
                              bolumleriGetir().then((value) {
                                setState(() {
                                  bolumler = value;
                                  _secilenBolum = null;
                                  _dDMenuItemBolumler =
                                      getDropDownMenuBolumler();
                                  _dDMenuItemBolum.clear();
                                });
                              });
                              scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text("Yeni Bolum Ekledi"),
                                duration: Duration(seconds: 5),
                              ));
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ],
            ),
          ),
          Container(
            child: ExpansionTile(
              title: Text("Bölüm güncelle veya sil"),
              children: <Widget>[
                Column(
                  children: <Widget>[
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
                              items: _dDMenuItemBolumler,
                              onChanged: (value) {
                                setState(() {
                                  _secilenBolumm = value;
                                });
                              },
                              value: _secilenBolumm,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Form(
                      key: guncelleBolumlerFormKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 5),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                hintText: "Yeni Bölüm Adını Giriniz",
                                labelText: "Bölüm",
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                prefixIcon: Icon(Icons.local_hospital),
                              ),
                              maxLength: 20,
                              keyboardType: TextInputType.text,
                              autovalidate: false,
                              validator: (value) {
                                if (value.length < 4)
                                  return "4 ten karakterden fazla olması gerekmekte";
                              },
                              onSaved: (value) => yeniBolumAdi = value,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: RaisedButton(
                            child: Text("Bölümü Kaydet"),
                            color: Colors.green.shade300,
                            onPressed: () {
                              if (guncelleBolumlerFormKey.currentState
                                      .validate() &&
                                  _secilenBolumm != null) {
                                guncelleBolumlerFormKey.currentState.save();
                                Bolum b = _secilenBolumm;
                                b.bolumAdi=yeniBolumAdi;
                                bolumGuncelle(b)
                                    .then((value) {
                                  debugPrint(
                                      "yeni bolum ID : " + value.toString());
                                  hastaleriGetir().then((hstneler) {
                                    setState(() {
                                      hastaneler = hstneler;
                                      _dDMenuItemHastane =
                                          getDropDownMenuHastane();
                                    });
                                  });
                                  bolumleriGetir().then((value) {
                                    setState(() {
                                      bolumler = value;
                                      _secilenBolumm=null;
                                      _dDMenuItemBolumler = getDropDownMenuBolumler();
                                    });
                                  });
                                  scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content:
                                        Text("Bolum Güncellendi"),
                                    duration: Duration(seconds: 5),
                                  ));
                                });
                              }
                            },
                          ),
                        ),
                        Container(
                          child: RaisedButton(
                            child: Text("Bölümü Sil"),
                            color: Colors.red.shade300,
                            onPressed: () {
                              if (_secilenBolumm != null) {
                                bolumSil(_secilenBolumm)
                                    .then((value) {
                                  debugPrint(
                                      "silinin bolum ID : " + value.toString());
                                  hastaleriGetir().then((hstneler) {
                                    setState(() {
                                      hastaneler = hstneler;
                                      _dDMenuItemHastane =
                                          getDropDownMenuHastane();
                                    });
                                  });
                                  bolumleriGetir().then((value) {
                                    setState(() {
                                      bolumler = value;
                                      _secilenBolumm=null;
                                      _dDMenuItemBolumler = getDropDownMenuBolumler();
                                    });
                                  });
                                  scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content:
                                        Text("Bolum Silindi"),
                                    duration: Duration(seconds: 5),
                                  ));
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ],
            ),
          ),
          Container(
            child: ExpansionTile(
              title: Text("Hastaneye Bölüm Ekle"),
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
                      margin: EdgeInsets.symmetric(horizontal: 90),
                      child: RaisedButton(
                        child: Text("Bölümü Kaydet"),
                        color: Colors.green.shade300,
                        onPressed: () {
                          if (_secilenHastane != null &&
                              _secilenBolum != null) {
                            hastaneyeBolumEkle(_secilenHastane.hastaneId,
                                    _secilenBolum.bolumID)
                                .then((value) {
                              debugPrint("yeni hb ID : " + value.toString());
                              hastaleriGetir().then((hstneler) {
                                setState(() {
                                  hastaneler = hstneler;
                                  _secilenHastane=null;
                                  _dDMenuItemHastane = getDropDownMenuHastane();
                                });
                              });
                              bolumleriGetir().then((value) {
                                setState(() {
                                  bolumler = value;
                                  _secilenBolum=null;
                                });
                              });
                              scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text("Hastaneye Yeni Bolum Ekledi"),
                                duration: Duration(seconds: 5),
                              ));
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ],
            ),
          ),
          Container(
            child: ExpansionTile(
              title: Text("Hastanedeki Bölüm Sil"),
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
                                  _dDMenuItemHBBolum = getDropDownMenuHBBolum();
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
                              items: _dDMenuItemHBBolum,
                              onChanged: (value) {
                                setState(() {
                                  _secilenBolum = value;
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
                      margin: EdgeInsets.symmetric(horizontal: 90),
                      child: RaisedButton(
                        child: Text("Bölümü Sil"),
                        color: Colors.green.shade300,
                        onPressed: () {
                          if (_secilenHastane != null &&
                              _secilenBolum != null) {
                            hastanedenBolumCikar(_secilenHastane.hastaneId,
                                _secilenBolum.bolumID)
                                .then((value) {
                              debugPrint("yeni hb ID : " + value.toString());
                              hastaleriGetir().then((hstneler) {
                                setState(() {
                                  hastaneler = hstneler;
                                  _secilenHastane=null;
                                  _dDMenuItemHastane = getDropDownMenuHastane();
                                });
                              });
                              bolumleriGetir().then((value) {
                                setState(() {
                                  bolumler = value;
                                  _secilenBolum=null;
                                });
                              });
                              scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text("Bölüm Silindi"),
                                duration: Duration(seconds: 5),
                              ));
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<int> bolumEkle(Bolum bolum) async {
    var db = DBHelper();
    var bolumID = await db.insertBolum(bolum);
    return bolumID;
  }

  Future<int> bolumGuncelle(Bolum bolum) async {
    var db = DBHelper();
    var bolumID = await db.updateBolum(bolum);
    return bolumID;
  }

  Future<int> bolumSil(Bolum bolum) async {
    var db = DBHelper();
    var bolumID = await db.deleteBolum(bolum);
    return bolumID;
  }

  hastaneyeBolumEkle(int hastaneID, int bolumID) async {
    var db = DBHelper();
    var hbID = await db.insertHastanedekiBolumler(hastaneID, bolumID);
    return hbID;
  }

  hastanedenBolumCikar(int hastaneID, int bolumID)async {
    var db = DBHelper();
    var hbID = await db.deleteHastanedekiBolumler(hastaneID, bolumID);
    return hbID;
  }

  Future<List<Hastane>> hastaleriGetir() async {
    var db = DBHelper();
    var hastanelerr = await db.getHastaneler();
    return hastanelerr;
  }

  Future<List<Bolum>> bolumleriGetir() async {
    var db = DBHelper();
    List<Bolum> bolum = await db.getBolumler();
    return bolum;
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

    for (int i = 0; i < bolumler.length; i++) {
      bool kontrol = false;
      for (int j = 0; j < _secilenHastane.bolumler.length; j++) {
        if (_secilenHastane.bolumler[j].bolumID == bolumler[i].bolumID) {
          kontrol = true;
          break;
        }
      }
      if (kontrol) continue;
      ddMenuBolum.add(new DropdownMenuItem<Bolum>(
        child: Text(bolumler[i].bolumAdi),
        value: bolumler[i],
      ));
    }
    return ddMenuBolum;
  }

  List<DropdownMenuItem<Bolum>> getDropDownMenuBolumler() {
    List<DropdownMenuItem<Bolum>> ddMenuBolum = new List();
    for (int i = 0; i < bolumler.length; i++) {
      ddMenuBolum.add(new DropdownMenuItem<Bolum>(
        child: Text(bolumler[i].bolumAdi),
        value: bolumler[i],
      ));
    }
    return ddMenuBolum;
  }

  List<DropdownMenuItem<Bolum>> getDropDownMenuHBBolum() {
    List<DropdownMenuItem<Bolum>> ddMenuBolum = new List();
    for (int i = 0; i < _secilenHastane.bolumler.length; i++) {
      ddMenuBolum.add(new DropdownMenuItem<Bolum>(
        child: Text(_secilenHastane.bolumler[i].bolumAdi),
        value: _secilenHastane.bolumler[i],
      ));
    }
    return ddMenuBolum;
  }
}
