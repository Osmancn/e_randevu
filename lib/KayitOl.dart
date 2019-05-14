import 'package:e_randevu/models/Hasta.dart';
import 'package:e_randevu/utils/DBHelper.dart';
import 'package:flutter/material.dart';

class KayitOl extends StatefulWidget {
  @override
  _KayitOlState createState() => _KayitOlState();
}

class _KayitOlState extends State<KayitOl> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _autoVali = false;
  TextEditingController _controllerSifre, _controllerTc;
  String _tc, _ad, _soyad, _email, _sifre, _sifreOnay, _cinsiyet;
  String _validatorCinsiyet = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerSifre = TextEditingController(text: "");
    _controllerTc = TextEditingController(text: "");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerSifre.dispose();
    _controllerTc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primarySwatch: Colors.green,
        hintColor: Colors.green.shade300,
        errorColor: Colors.red,
      ),
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("Kayıt Ol"),
        ),
        body: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 40),
              //başlık
              Center(
                child: Text(
                  "Kayıt Ol",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              SizedBox(height: 40),
              //tc no
              Container(
                margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: "TC kimlik numarasını giriniz",
                    labelText: "TC",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
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
                margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: "Adınızı giriniz",
                    labelText: "Ad",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
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
                margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: "Soyadınızı giriniz",
                    labelText: "Soyad",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
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
                margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: "Email adresinizi giriniz",
                    labelText: "Email",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
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
                margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: "Şifrenizi giriniz",
                    labelText: "Şifre",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
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
                margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: "Şifrenizi tekrar giriniz",
                    labelText: "Şifre",
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
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
              Column(
                children: <Widget>[
                  Text(
                    "Cinsiyet",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio<String>(
                        value: "erkek",
                        groupValue: _cinsiyet,
                        onChanged: (value) {
                          setState(() {
                            _cinsiyet = value;
                            _validatorCinsiyet = "";
                          });
                        },
                      ),
                      Text(
                        "Erkek",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Radio<String>(
                        value: "kadın",
                        groupValue: _cinsiyet,
                        onChanged: (value) {
                          setState(() {
                            _cinsiyet = value;
                            _validatorCinsiyet = "";
                          });
                        },
                      ),
                      Text(
                        "Kadın",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink),
                      )
                    ],
                  ),
                  Center(
                    heightFactor: 0,
                    child: Text(
                      _validatorCinsiyet,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              //Kayıt ol button
              Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 90),
                child: RaisedButton(
                  child: Text("Kayıt Ol"),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() {
                      _autoVali = true;
                      if (_cinsiyet == null)
                        _validatorCinsiyet = "Cinsiyet seçiniz";
                    });

                    if (_KayitOnayla() && _cinsiyet != null) {
                      tcKontrol(_controllerTc.text.toString()).then((kontrol) {
                        if (kontrol) {
                          var hasta = Hasta(_ad, _soyad, _controllerTc.text.toString(), _sifre,
                              _email, _cinsiyet);
                          hastaEkle(hasta).then((hastaID) {
                            Navigator.pushNamed(
                                context, "/HastaAnaSayfa/$hastaID");
                          });
                        } else {
                          scaffoldKey.currentState.showSnackBar(SnackBar(
                            content:
                                Text("Böyle bir TC numaralı hasta bulunmakta"),
                            duration: Duration(seconds: 5),
                          ));
                        }
                      });
                    }
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 90),
                child: RaisedButton(
                  child: Text("Zaten Kaydım Var"),
                  color: Colors.orange,
                  onPressed: () {
                    Navigator.pushNamed(context, "/GirisSayfasi");
                  },
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  bool _KayitOnayla() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      return true;
    }
    return false;
  }

  Future<bool> tcKontrol(String tc) async {
    var db = await DBHelper();
    var hasta = await db.getHastaByTc(tc);
    if (hasta == null)
      return true;
    else
      return false;
  }

  Future<int> hastaEkle(Hasta h) async {
    var db = await DBHelper();
    var hastaID = await db.insertHasta(h.toMap());
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Kayıt oluşturuldu"),
      duration: Duration(seconds: 2),
    ));
    return hastaID;
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
}
