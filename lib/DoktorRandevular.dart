import 'package:e_randevu/DoktorAnaSayfa.dart';
import 'package:e_randevu/models/Randevu.dart';
import 'package:e_randevu/utils/DBHelper.dart';
import 'package:flutter/material.dart';

class DoktorRandevular extends StatefulWidget {
  @override
  _DoktorRandevularState createState() => _DoktorRandevularState();
}

class _DoktorRandevularState extends State<DoktorRandevular> {
  var randevuListesi = List<Map<String, String>>();

  @override
  void initState() {
    randevuListesiGetir(DoktorAnaSayfa.doktorID).then((map) {
      setState(() {
        randevuListesi = map;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return randevularWidgets();
  }

  Widget randevularWidgets() {
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
              color: Colors.green.shade200,
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
                                    "Hasta Adı : ${randevuListesi[randevuListesi.length - index - 1]['hasta']}\n"),
                                Text("Tarih : ${randevuListesi[randevuListesi.length - index - 1]['tarih']}  " +
                                    "${randevuListesi[randevuListesi.length - index - 1]['saat']}"),
                              ],
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
  }

  Future<List<Map<String, String>>> randevuListesiGetir(int doktorID) async {
    var db = DBHelper();
    List<Randevu> list = await db.getRandevularByDoktorID(doktorID);
    var mapler = List<Map<String, String>>();
    for (int i = 0; i < list.length; i++) {
      if(!list[i].randevuDurum) continue;
      var map = Map<String, String>();
      var s = await db.getSaatByID(list[i].saatID);
      map['tarih'] = list[i].randevuGunu;
      var split = map['tarih'].split(".");
      var split2 = s.toString().split("-");
      var split3 = split2[1].split(":");
      DateTime tarih = DateTime(int.parse(split[2]), int.parse(split[1]),
          int.parse(split[0]), int.parse(split3[0]), int.parse(split3[1]));
      if (tarih.isBefore(DateTime.now())) continue;
      var h = await db.getHastaByID(list[i].hastaID);
      map['hasta'] = h.ad + " " + h.soyad;
      map['saat'] = s;
      mapler.add(map);
    }
    return mapler;
  }
}
