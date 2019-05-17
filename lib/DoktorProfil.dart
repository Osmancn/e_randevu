import 'package:e_randevu/DoktorAnaSayfa.dart';
import 'package:e_randevu/models/Doktor.dart';
import 'package:e_randevu/utils/DBHelper.dart';
import 'package:flutter/material.dart';

class DoktorProfil extends StatefulWidget {
  @override
  _DoktorProfilState createState() => _DoktorProfilState();
}

class _DoktorProfilState extends State<DoktorProfil> {
  Doktor doktor;
  TextEditingController _sifreController;
  final formKey = GlobalKey<FormState>();
  final formKeySifre = GlobalKey<FormState>();

  @override
  void initState() {
    _sifreController = TextEditingController(text: "");
    doktorGetir(DoktorAnaSayfa.doktorID).then((value) {
      setState(() {
        doktor = value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _sifreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return bodyWidget();
  }

  Future<Doktor> doktorGetir(int doktorID) async {
    var db = DBHelper();
    var d = await db.getDoktorByID(doktorID);
    return d;
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

  Future<int> doktorGuncelle(Doktor d) async {
    var db = DBHelper();
    int id = await db.updateDoktor(d);
    return id;
  }

  Widget bodyWidget() {
    String yeniEmail;
    String yeniSifre;
    if (doktor == null)
      return Container();
    else
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.blue.shade300),
                    child: Center(
                      child: Text(
                        doktor.ad[0],
                        style:
                            TextStyle(fontSize: 50, color: Colors.red.shade300),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                      child: Text(
                    doktor.ad + " " + doktor.soyad,
                    style: TextStyle(fontSize: 20),
                  ))
                ],
              ),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Material(
              borderRadius: BorderRadius.circular(10),
              elevation: 10,
              child: Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width - 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Ad : " + doktor.ad,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Soyad : " + doktor.soyad,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "TC : " + doktor.TC,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Email : " + doktor.email,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return SimpleDialog(
                                    title: Text("Email Değiştir"),
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          SizedBox(height: 20),
                                          Form(
                                            key: formKey,
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  hintText:
                                                      "Email adresinizi giriniz",
                                                  labelText: "Email",
                                                  labelStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  prefixIcon: Icon(Icons.email),
                                                ),
                                                maxLength: 32,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                autovalidate: false,
                                                validator: (value) =>
                                                    _validateEmail(value),
                                                onSaved: (value) =>
                                                    yeniEmail = value,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              RaisedButton(
                                                child: Text("vazgeç"),
                                                color: Colors.red.shade300,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              SizedBox(width: 20),
                                              RaisedButton(
                                                child: Text("Değiştir"),
                                                color: Colors.green.shade300,
                                                onPressed: () {
                                                  if (formKey.currentState
                                                      .validate()) {
                                                    formKey.currentState.save();
                                                    setState(() {
                                                      doktor.email = yeniEmail;
                                                    });
                                                    doktorGuncelle(doktor)
                                                        .then((value) {
                                                      debugPrint(
                                                          value.toString());
                                                      debugPrint(doktor.doktorID
                                                          .toString());
                                                      Navigator.pop(context);
                                                    });
                                                  }
                                                },
                                              ),
                                              SizedBox(width: 20),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                });
                          },
                          color: Colors.blue.shade300,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 10,
                          child: Text(
                            "Email Değiştir",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(width: 20),
                        RaisedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return SimpleDialog(
                                    title: Text("Şifre Değiştir"),
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Form(
                                            key: formKeySifre,
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 50,
                                                      vertical: 5),
                                                  child: TextFormField(
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      hintText:
                                                          "Eski Şifrenizi giriniz",
                                                      labelText: "Eski Şifre",
                                                      labelStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      prefixIcon:
                                                          Icon(Icons.lock_open),
                                                    ),
                                                    maxLength: 16,
                                                    obscureText: true,
                                                    autovalidate: false,
                                                    validator: (value) {
                                                      if (doktor.sifre != value)
                                                        return "Şifre Yanlış";
                                                      else
                                                        return null;
                                                    },
                                                    onSaved: (value) =>
                                                        yeniSifre = value,
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 50,
                                                      vertical: 5),
                                                  child: TextFormField(
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      hintText:
                                                          "Yeni Şifrenizi giriniz",
                                                      labelText: "Yeni Şifre",
                                                      labelStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      prefixIcon:
                                                          Icon(Icons.lock_open),
                                                    ),
                                                    maxLength: 16,
                                                    obscureText: true,
                                                    autovalidate: false,
                                                    validator: (value) {
                                                      if (value.length < 6)
                                                        return "Şifre 6 karakterde küçük olmaz";
                                                      else
                                                        return null;
                                                    },
                                                    onSaved: (value) =>
                                                        yeniSifre = value,
                                                    controller:
                                                        _sifreController,
                                                  ),
                                                ),
                                                //şifre onay
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 50,
                                                      vertical: 5),
                                                  child: TextFormField(
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      hintText:
                                                          "Yeni Şifrenizi tekrar giriniz",
                                                      labelText: "Yeni Şifre",
                                                      labelStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      prefixIcon:
                                                          Icon(Icons.lock_open),
                                                    ),
                                                    maxLength: 16,
                                                    obscureText: true,
                                                    onSaved: (value) =>
                                                        yeniSifre = value,
                                                    autovalidate: false,
                                                    validator: (value) {
                                                      if (value !=
                                                          _sifreController.text
                                                              .toString())
                                                        return "Şifre aynı olmalı";
                                                      else
                                                        return null;
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              RaisedButton(
                                                color: Colors.red.shade300,
                                                child: Text("vazgeç"),
                                                onPressed: () {
                                                  _sifreController.text = "";
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              SizedBox(width: 20),
                                              RaisedButton(
                                                color: Colors.green.shade300,
                                                child: Text("Değiştir"),
                                                onPressed: () {
                                                  if (formKeySifre.currentState
                                                      .validate()) {
                                                    formKeySifre.currentState
                                                        .save();
                                                    doktor.sifre = yeniSifre;
                                                    doktorGuncelle(doktor)
                                                        .then((value) {
                                                      _sifreController.text =
                                                          "";
                                                      Navigator.pop(context);
                                                    });
                                                  }
                                                },
                                              ),
                                              SizedBox(width: 10),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  );
                                });
                          },
                          color: Colors.green.shade300,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 10,
                          child: Text(
                            "Şifre Değiştir",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      );
  }
}
