import 'package:e_randevu/models/Hasta.dart';
import 'package:e_randevu/utils/DBHelper.dart';
import 'package:flutter/material.dart';

class HastaAnaSayfa extends StatefulWidget {
  static int hastaID;

  HastaAnaSayfa(int id) {
    HastaAnaSayfa.hastaID = id;
  }

  @override
  _HastaAnaSayfaState createState() => _HastaAnaSayfaState();
}

class _HastaAnaSayfaState extends State<HastaAnaSayfa> {
  Hasta hasta;

  @override
  void initState() {
    HastayiGetir(HastaAnaSayfa.hastaID).then((h) {
      setState(() {
        hasta = h;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ana Sayfa"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text("ad soyad :" + hasta.ad + " " + hasta.soyad),
                Text("tc : " + hasta.TC),
              ],
            ),
            RaisedButton(
              child: Text("Randevu Al"),
              color: Colors.green.shade300,
              onPressed: () {
                Navigator.pushNamed(context, "/RandevuSayfasi");
              },
            )
          ],
        ),
      ),
    );
  }

  Future<Hasta> HastayiGetir(int id) async {
    var db = await DBHelper();
    var h = await db.getHastaByID(id);
    return h;
  }
}
