import 'package:flutter/material.dart';

class AdminAnaSayfa extends StatefulWidget {
  static int adminID;

  AdminAnaSayfa(int id) {
    adminID = id;
  }

  @override
  _AdminAnaSayfaState createState() => _AdminAnaSayfaState();
}

class _AdminAnaSayfaState extends State<AdminAnaSayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Ana Sayfa"),
      ),
      drawer: Drawer(child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Admin"),
            accountEmail: Text(""),
            currentAccountPicture: CircleAvatar(
              child: Center(
                  child: Text(
                    "A",
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
                    Navigator.pushNamed(context, "/AdminHastaneIslem");
                  },
                  child: ListTile(
                    leading: Icon(Icons.local_hospital),
                    title: Text("Hastane İşlem"),
                    trailing: Icon(Icons.navigate_next),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/AdminBolumIslem");
                  },
                  child: ListTile(
                    leading: Icon(Icons.local_hospital),
                    title: Text("Bölüm İşlem"),
                    trailing: Icon(Icons.navigate_next),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/AdminDoktorIslem");
                  },
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Doktor İşlem"),
                    trailing: Icon(Icons.navigate_next),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/GirisSayfasi");
                  },
                  child: ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text("Çıkış Yap"),
                    trailing: Icon(Icons.navigate_before),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),),
      body: Center(
        child: Text("" + AdminAnaSayfa.adminID.toString()),
      ),
    );
  }
}
