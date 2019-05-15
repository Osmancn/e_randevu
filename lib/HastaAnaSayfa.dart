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
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("" + hasta.ad + " " + hasta.soyad),
                accountEmail: Text("" + hasta.email),
                currentAccountPicture: CircleAvatar(
                  child: Center(
                      child: Text(
                    "" + hasta.ad[0],
                    style: TextStyle(fontSize: 40),
                  )),
                  backgroundColor: Colors.blue.shade500,
                ),
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/RandevuSayfasi");
                      },
                      child: ListTile(
                        leading: Icon(Icons.add),
                        title: Text("Randevu Al"),
                        trailing: Icon(Icons.navigate_next),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/HastaRandevular");
                      },
                      child: ListTile(
                        leading: Icon(Icons.calendar_today),
                        title: Text("Randevularım"),
                        trailing: Icon(Icons.navigate_next),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
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
                child: Text("Randevularım"),
                color: Colors.green.shade300,
                onPressed: () {
                  Navigator.pushNamed(context, "/HastaRandevular");
                },
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
      ),
    );
  }

  Future<Hasta> HastayiGetir(int id) async {
    var db = await DBHelper();
    var h = await db.getHastaByID(id);
    return h;
  }
}
