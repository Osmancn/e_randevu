import 'package:e_randevu/HastaAnaSayfa.dart';
import 'package:e_randevu/models/Randevu.dart';
import 'package:e_randevu/utils/DBHelper.dart';
import 'package:flutter/material.dart';

class HastaRandevular extends StatefulWidget {
  @override
  _HastaRandevularState createState() => _HastaRandevularState();
}

class _HastaRandevularState extends State<HastaRandevular> {
  var randevuListesi = List<Map<String, String>>();

  @override
  void initState() {
    randevuListesiGetir(HastaAnaSayfa.hastaID).then((value) {
      setState(() {
        randevuListesi = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Randevular"),
      ),
      body: ListView.builder(
        itemCount: randevuListesi.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Material(
              color: cardColor(index),
              elevation: 10,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    "Hastane : ${randevuListesi[index]['hastane']}\n"),
                                Text(
                                    "Doktor : ${randevuListesi[index]['doktor']}\n"),
                                Text(
                                    "Tarih : ${randevuListesi[index]['tarih']}  " +
                                        "${randevuListesi[index]['saat']}"),
                              ],
                            )),
                      ],
                    ),
                    cardButton(index),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<List<Map<String, String>>> randevuListesiGetir(int hastaID) async {
    var db = await DBHelper();
    var list = await db.getHastaRandevular(hastaID);
    var mapler = List<Map<String, String>>();
    for (int i = 0; i < list.length; i++) {
      var map = Map<String, String>();
      var h = await db.getHastaneByID(list[i].hastaID);
      var d = await db.getDoktorByID(list[i].doktorID);
      var s = await db.getSaatByID(list[i].saatID);
      map['hastane'] = h.hastaneAdi;
      map['doktor'] = d.ad + " " + d.soyad;
      map['saat'] = s;
      map['tarih'] = list[i].randevuGunu;
      map['randevuID'] = list[i].randevuID.toString();
      map['durum'] = list[i].randevuDurum == true ? "1" : "0";
      mapler.add(map);
    }
    return mapler;
  }

  Color cardColor(int index) {
    if (randevuListesi[index]['durum'] == '0') return Colors.red.shade200;
    var split = randevuListesi[index]['tarih'].split(".");
    DateTime tarih =
        DateTime(int.parse(split[2]), int.parse(split[1]), int.parse(split[0]));
    if (tarih.isAfter(DateTime.now())) {
      return Colors.green.shade200;
    } else
      return Colors.blue.shade200;
  }

  Widget cardButton(int index) {
    if (randevuListesi[index]['durum'] == '0') return Container();
    var split = randevuListesi[index]['tarih'].split(".");
    DateTime tarih =
        DateTime(int.parse(split[2]), int.parse(split[1]), int.parse(split[0]));
    if (tarih.isAfter(DateTime.now())) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: RaisedButton(
          color: Colors.red.shade300,
          onPressed: () {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: Text("Randevu İptal Eminmisiniz"),
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Colors.green.shade500,
                            child: Text("Vazgeç"),
                            elevation: 10,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          RaisedButton(
                            onPressed: () {
                              RandevuIptal(int.parse(randevuListesi[index]
                                          ['randevuID']
                                      .toString()))
                                  .then((value) {
                                setState(() {
                                  randevuListesi[index]['durum'] = "0";
                                  Navigator.pop(context);
                                });
                              });
                            },
                            color: Colors.red.shade500,
                            child: Text("Randevu İptal"),
                            elevation: 10,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      )
                    ],
                  );
                });
          },
          child: Text("iptal"),
        ),
      );
    } else
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: InkWell(
          onTap: () {},
          child: Icon(
            Icons.favorite,
            color: Colors.grey,
            size: 30,
          ),
        ),
      );
  }

  Future<int> RandevuIptal(int randevuID) async {
    var db = await DBHelper();
    int id = await db.randevuIptal(randevuID);
    return id;
  }
}
