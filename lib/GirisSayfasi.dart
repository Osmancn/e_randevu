import 'package:e_randevu/utils/DBHelper.dart';
import 'package:flutter/material.dart';

class GirisSayfasi extends StatefulWidget {
  @override
  _GirisSayfasiState createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  String _tc, _sifre;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _autoVali = false;
  int _hastaID;

  @override
  void initState() {
    // TODO: implement initState
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
          title: Text("Kullanıcı Giris"),
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
                    if (value.length < 6)
                      return "Şifre 6 karakterde küçük olmaz";
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
                      tcKontrol(_tc).then(
                        (kontrol) {
                          if (kontrol)
                            Navigator.pushNamed(
                                context, "/HastaAnaSayfa/$_hastaID");
                          else
                            scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Böyle Bir Hasta Kaydı Bulunamadı"),
                                duration: Duration(seconds: 5),
                              ),
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
                  child: Text("Kayıt Ol"),
                  color: Colors.orange,
                  onPressed: () {
                    Navigator.pushNamed(context, "/KayitOl");
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

  Future<bool> tcKontrol(String tc) async {
    var db = DBHelper();
    var hasta = await db.getHastaByTc(tc);
    if (hasta == null||hasta.sifre!=_sifre)
      return false;
    else {
      _hastaID = hasta.hastaId;
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
