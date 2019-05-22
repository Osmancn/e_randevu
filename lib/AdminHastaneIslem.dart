import 'package:e_randevu/AdminAnaSayfa.dart';
import 'package:e_randevu/models/Admin.dart';
import 'package:e_randevu/models/Hastane.dart';
import 'package:e_randevu/utils/DBHelper.dart';
import 'package:flutter/material.dart';

class AdminHastaneIslem extends StatefulWidget {
  @override
  _AdminHastaneIslemState createState() => _AdminHastaneIslemState();
}

class _AdminHastaneIslemState extends State<AdminHastaneIslem> {
  String yeniHastaneAdi;
  String yeniHastaneAdres;
  Hastane _secilenHastane;
  List<DropdownMenuItem<Hastane>> _dDMenuItemHastane;
  List<Hastane> hastaneler;
  final yeniHastaneFormKey = GlobalKey<FormState>();
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Hastane İşlem"),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: ExpansionTile(
              title: Text("Hastane Ekle"),
              children: <Widget>[
                Form(
                  key: yeniHastaneFormKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: "Yeni Hastane Adını Giriniz",
                            labelText: "Hastane",
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            prefixIcon: Icon(Icons.local_hospital),
                          ),
                          maxLength: 20,
                          keyboardType: TextInputType.text,
                          autovalidate: false,
                          validator: (value) {
                            if (value.length < 4)
                              return "4 ten karakterden fazla olması gerekmekte";
                          },
                          onSaved: (value) => yeniHastaneAdi = value,
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: "Yeni Hastanenin Adresini Giriniz",
                            labelText: "Adres",
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            prefixIcon: Icon(Icons.chrome_reader_mode),
                          ),
                          maxLength: 20,
                          keyboardType: TextInputType.text,
                          autovalidate: false,
                          validator: (value) {
                            if (value.length < 4)
                              return "4 ten karakterden fazla olması gerekmekte";
                          },
                          onSaved: (value) => yeniHastaneAdres = value,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 90),
                  child: RaisedButton(
                    child: Text("HastaneKaydet"),
                    color: Colors.green.shade300,
                    onPressed: () {
                      if (yeniHastaneFormKey.currentState.validate()) {
                        yeniHastaneFormKey.currentState.save();
                        hastaneEkle(Hastane(yeniHastaneAdi, yeniHastaneAdres))
                            .then((value) {
                          debugPrint("yeni hastane ID : " + value.toString());
                          hastaleriGetir().then((hstneler) {
                            setState(() {
                              hastaneler = hstneler;
                              _dDMenuItemHastane = getDropDownMenuHastane();
                            });
                          });
                          scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("Yeni Hastane Ekledi"),
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
          ),
          Container(
            child: ExpansionTile(
              title: Text("Hastane Güncelle veya Sil"),
              children: <Widget>[
                Column(
                  children: <Widget>[
                    //DropDown Hastane
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
                                });
                              },
                              value: _secilenHastane,
                            ),
                          )
                        ],
                      ),
                    ),
                    //textfield güncelleme
                    Form(
                      key: guncelleFormKey,
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
                                hintText: "Yeni Hastane Adını Giriniz",
                                labelText: "Hastane",
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
                              onSaved: (value) => yeniHastaneAdi = value,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 5),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                hintText: "Yeni Hastanenin Adresini Giriniz",
                                labelText: "Adres",
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                prefixIcon: Icon(Icons.chrome_reader_mode),
                              ),
                              maxLength: 20,
                              keyboardType: TextInputType.text,
                              autovalidate: false,
                              validator: (value) {
                                if (value.length < 4)
                                  return "4 ten karakterden fazla olması gerekmekte";
                              },
                              onSaved: (value) => yeniHastaneAdres = value,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    //button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: RaisedButton(
                            child: Text("Güncelle"),
                            color: Colors.green.shade300,
                            onPressed: () {
                              if (guncelleFormKey.currentState.validate()) {
                                guncelleFormKey.currentState.save();
                                Hastane h = _secilenHastane;
                                h.hastaneAdi = yeniHastaneAdi;
                                h.hastaneAdresi = yeniHastaneAdres;
                                hastaneGuncelle(h).then((value) {
                                  debugPrint("güncel hastane ID : " +
                                      value.toString());
                                  hastaleriGetir().then((hstneler) {
                                    setState(() {
                                      hastaneler = hstneler;
                                      _secilenHastane = null;
                                      _dDMenuItemHastane =
                                          getDropDownMenuHastane();
                                    });
                                  });
                                  scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text("Hastane Güncellendi"),
                                    duration: Duration(seconds: 5),
                                  ));
                                });
                              }
                            },
                          ),
                        ),
                        Container(
                          child: RaisedButton(
                            child: Text("Sil"),
                            color: Colors.red.shade300,
                            onPressed: () {
                              if (_secilenHastane != null) {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return SimpleDialog(
                                        title: Text("Silme İşlemi"),
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Hastaneyi silmek hastanedeki bölümleri,bölümdeki " +
                                                      "doktorları ve doktorların randevularını otomatik silmektedir." +
                                                      "Hastane Silinsinmi",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Container(
                                                    child: RaisedButton(
                                                      color:
                                                          Colors.green.shade300,
                                                      child: Text("İptal"),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ),
                                                  Container(
                                                    child: RaisedButton(
                                                      color:
                                                          Colors.red.shade300,
                                                      child: Text("Sil"),
                                                      onPressed: () {
                                                        hastaneSil(
                                                                _secilenHastane)
                                                            .then((value) {
                                                          hastaleriGetir()
                                                              .then((hstneler) {
                                                            setState(() {
                                                              hastaneler =
                                                                  hstneler;
                                                              _secilenHastane =
                                                                  null;
                                                              _dDMenuItemHastane =
                                                                  getDropDownMenuHastane();
                                                            });
                                                          });
                                                          scaffoldKey
                                                              .currentState
                                                              .showSnackBar(
                                                                  SnackBar(
                                                            content: Text(
                                                                "Hastane Silindi"),
                                                            duration: Duration(
                                                                seconds: 5),
                                                          ));
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          )
                                        ],
                                      );
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
        ],
      ),
    );
  }

  Future<int> hastaneEkle(Hastane hastane) async {
    var db = DBHelper();
    var hastaneID = await db.insertHastane(hastane);
    return hastaneID;
  }

  Future<int> hastaneGuncelle(Hastane hastane) async {
    var db = DBHelper();
    var hastaneID = await db.updateHastane(hastane);
    return hastaneID;
  }

  Future<int> hastaneSil(Hastane hastane) async {
    var db = DBHelper();
    var hastaneID = await db.deleteHastane(hastane);
    return hastaneID;
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
}
