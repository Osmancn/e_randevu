import 'package:e_randevu/DoktorProfil.dart';
import 'package:e_randevu/DoktorRandevular.dart';
import 'package:flutter/material.dart';

class DoktorAnaSayfa extends StatefulWidget {
  static int doktorID;
  DoktorAnaSayfa(int id) {
    doktorID = id;
  }

  @override
  _DoktorAnaSayfaState createState() => _DoktorAnaSayfaState();
}

class _DoktorAnaSayfaState extends State<DoktorAnaSayfa> {
  int bottomIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: Text("Çıkış Yap"),
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(height:10),
                      Text("Çıkış Yapılsın mı?"
                      ,style: TextStyle(fontSize: 18),),
                      SizedBox(height:20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          RaisedButton(
                            color: Colors.green.shade300,
                            child: Text("vazgeç"),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(width :20),
                          RaisedButton(
                            color: Colors.red.shade300,
                            child: Text("Çıkış Yap"),
                            onPressed: (){
                              Navigator.pushNamed(context, "/GirisSayfasi");
                            },
                          ),
                          SizedBox(width :20),
                        ],
                      )
                    ],
                  )
                ],
              );
            });
        return Future.value(false);
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              title: Text("Randevular"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              title: Text("Profil"),
            ),
          ],
          currentIndex: bottomIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              bottomIndex = index;
            });
          },
        ),
        appBar: AppBar(
          title: appBarTitle(bottomIndex),
        ),
        body: sayfayiGetir(bottomIndex),
      ),
    );
  }

  appBarTitle(int index) {
    if (index == 0)
      return Text("Randevular");
    else
      return Text("Profil");
  }

  sayfayiGetir(int index) {
    if (index == 0)
      return DoktorRandevular();
    else
      return DoktorProfil();
  }
}
