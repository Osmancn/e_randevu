import 'package:e_randevu/utils/DBHelper.dart';
import 'package:flutter/material.dart';

class DoktorGirisSayfasi extends StatefulWidget {
  @override
  _DoktorGirisSayfasiState createState() => _DoktorGirisSayfasiState();
}

class _DoktorGirisSayfasiState extends State<DoktorGirisSayfasi> {
  String _tc, _sifre;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _autoVali = false;
  int _doktorID, _adminID;

  @override
  void initState() {

    super.initState();
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
          title: Text("Doktor-Admin Giris"),
        ),
        body: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 40),
              //başlık
              Center(
                child: Text(
                  "Giriş Yap",
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
                  autovalidate: _autoVali,
                  validator: (value) => _validateTc(value),
                  onSaved: (value) => _tc = value,
                ),
              ),
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
                    if (value.length < 5)
                      return "Şifre 5 karakterde küçük olmaz";
                    else
                      return null;
                  },
                  onSaved: (value) => _sifre = value,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 90),
                child: RaisedButton(
                  child: Text("Giriş Yap"),
                  color: Colors.blue,
                  onPressed: () {
                    _autoVali = true;
                    if (_girisOnayla()) {
                      adminTcKontrol(_tc).then(
                        (adminKontrol) {
                          if (adminKontrol)
                            Navigator.pushNamed(
                                context, "/AdminAnaSayfa/$_adminID");
                          else
                            doktorTcKontrol(_tc).then(
                              (doktorKontrol) {
                                if (doktorKontrol)
                                  Navigator.pushNamed(
                                      context, "/DoktorAnaSayfa/$_doktorID");
                                else
                                  scaffoldKey.currentState.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "Böyle Bir Doktor Kaydı Bulunamadı"),
                                      duration: Duration(seconds: 5),
                                    ),
                                  );
                              },
                            );
                        },
                      );
                    }
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 90),
                child: RaisedButton(
                  child: Text("Kullanıcı Giriş Sayfası"),
                  color: Colors.orange,
                  onPressed: () {
                    Navigator.pushNamed(context, "/GirisSayfasi");
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  bool _girisOnayla() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      return true;
    }
    return false;
  }

  Future<bool> adminTcKontrol(String tc) async {
    var db = DBHelper();
    var admin = await db.getAdminByTc(tc);
    if (admin == null || admin.sifre != _sifre)
      return false;
    else {
      _adminID = admin.adminId;
      return true;
    }
  }

  Future<bool> doktorTcKontrol(String tc) async {
    var db = DBHelper();
    var doktor = await db.getDoktorByTc(tc);

    if (doktor == null || doktor.sifre != _sifre)
      return false;
    else {
      _doktorID = doktor.doktorID;
      return true;
    }
  }

  String _validateTc(String tc) {
    RegExp regex = new RegExp("^[0-9]+\$");
    if (!regex.hasMatch(tc) || tc.length != 11)
      return "Doğru TC kimlik no giriniz";
    else
      return null;
  }
}
