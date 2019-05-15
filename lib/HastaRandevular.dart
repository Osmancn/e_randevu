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
  var favoriMi = List<bool>();

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
      body: randevularWidgets(),
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
      map['doktorID'] = list[i].doktorID.toString();
      map['durum'] = list[i].randevuDurum == true ? "1" : "0";
      mapler.add(map);
      bool favMi = true;
      var mapp = await db.getFavoriDoktor(list[i].doktorID, hastaID);
      if (mapp.isEmpty) favMi = false;
      favoriMi.add(favMi);
    }
    return mapler;
  }

  Color cardColor(int index) {
    if (randevuListesi[index]['durum'] == '0') return Colors.red.shade200;
    var split = randevuListesi[index]['tarih'].split(".");
    var split2 = randevuListesi[index]['saat'].split("-");
    var split3 = split2[1].split(":");
    DateTime tarih = DateTime(int.parse(split[2]), int.parse(split[1]),
        int.parse(split[0]), int.parse(split3[0]), int.parse(split3[1]));
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
    if (tarih.isAfter(DateTime.now()))
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
    else
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: InkWell(
          onTap: () {
            debugPrint("tiklandi");
            favoriDoktorMu(
                    int.parse(randevuListesi[index]['doktorID'].toString()),
                    HastaAnaSayfa.hastaID)
                .then((kontrol) {
              if (kontrol)
                setState(() {
                  favoriDoktoruSil(
                          int.parse(
                              randevuListesi[index]['doktorID'].toString()),
                          HastaAnaSayfa.hastaID)
                      .then((value) {
                    debugPrint("silindi" + value.toString());
                  });
                  favoriMi[index] = false;
                  for (int i = 0; i < randevuListesi.length; i++)
                    if (randevuListesi[i]['doktorID'] ==
                        randevuListesi[index]['doktorID']) favoriMi[i] = false;
                });
              else
                setState(() {
                  favoriDoktorlaraEkle(
                          int.parse(
                              randevuListesi[index]['doktorID'].toString()),
                          HastaAnaSayfa.hastaID)
                      .then((value) {
                    debugPrint("eklendi " + value.toString());
                  });
                  favoriMi[index] = true;
                  for (int i = 0; i < randevuListesi.length; i++)
                    if (randevuListesi[i]['doktorID'] ==
                        randevuListesi[index]['doktorID']) favoriMi[i] = true;
                });
            });
          },
          child: Icon(
            Icons.favorite,
            color: favoriMi[index] == true ? Colors.red : Colors.grey,
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

  Future<bool> favoriDoktorMu(int doktorID, int hastaID) async {
    var db = await DBHelper();
    var map = await db.getFavoriDoktor(doktorID, hastaID);
    if (map.isEmpty)
      return false;
    else
      return true;
  }

  Future<int> favoriDoktorlaraEkle(int doktorID, int hastaID) async {
    var db = await DBHelper();
    int id = await db.insertFavoriDoktor(doktorID, hastaID);
    return id;
  }

  Future<int> favoriDoktoruSil(int doktorID, int hastaID) async {
    var db = await DBHelper();
    int id = await db.deleteFavoriDoktor(doktorID, hastaID);
    return id;
  }

  randevularWidgets()
  {
    if (randevuListesi.isEmpty)
      return Center(
        child: Text(
          "Randevu Bulunmamakta",
          style: TextStyle(fontSize: 24, color: Colors.red.shade300),
        ),
      );
    else
      return ListView.builder(
        itemCount: randevuListesi.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Material(
              color: cardColor(randevuListesi.length-index-1),
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
                                    "Hastane : ${randevuListesi[randevuListesi.length-index-1]['hastane']}\n"),
                                Text(
                                    "Doktor : ${randevuListesi[randevuListesi.length-index-1]['doktor']}\n"),
                                Text(
                                    "Tarih : ${randevuListesi[randevuListesi.length-index-1]['tarih']}  " +
                                        "${randevuListesi[randevuListesi.length-index-1]['saat']}"),
                              ],
                            )),
                      ],
                    ),
                    cardButton(randevuListesi.length-index-1),
                  ],
                ),
              ),
            ),
          );
        },
      );
  }
}
