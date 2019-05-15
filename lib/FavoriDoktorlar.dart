import 'package:e_randevu/HastaAnaSayfa.dart';
import 'package:e_randevu/models/Doktor.dart';
import 'package:e_randevu/utils/DBHelper.dart';
import 'package:flutter/material.dart';

class FavoriDoktorlar extends StatefulWidget {
  @override
  _FavoriDoktorlarState createState() => _FavoriDoktorlarState();
}

class _FavoriDoktorlarState extends State<FavoriDoktorlar> {
  var favorilerMap = List<Map<String, String>>();

  @override
  void initState() {
    favoriDoktorlariGetir(HastaAnaSayfa.hastaID).then((value) {
      setState(() {
        favorilerMap = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favori Doktorlarım")),
      body: FavoriDoktorlarWidgets(),
    );
  }

  Future<List<Map<String, String>>> favoriDoktorlariGetir(int hastaID) async {
    var db = await DBHelper();
    var fMap = await db.getFavoriDoktorlarByHastaID(hastaID);
    var list = List<Doktor>();
    var map = List<Map<String, String>>();
    for (int i = 0; i < fMap.length; i++) {
      var m = Map<String, String>();
      Doktor d =
          await db.getDoktorByID(int.parse(fMap[i]['doktorID'].toString()));
      var hbMap = await db.getHastaneAndBolumByDoktorID(d.doktorID);
      m['doktor'] = d.ad + " " + d.soyad;
      m['bolum'] = hbMap['bolum'];
      m['hastane'] = hbMap['hastane'];
      m['doktorID'] = d.doktorID.toString();
      map.add(m);
    }
    return map;
  }

  Widget FavoriDoktorlarWidgets() {
    if (favorilerMap.isEmpty)
      return Center(
        child: Text(
          "Favori Doktor Bulunmamakta",
          style: TextStyle(fontSize: 24, color: Colors.red.shade300),
        ),
      );
    else
      return ListView.builder(
        itemCount: favorilerMap.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Material(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(10),
              elevation: 10,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Hastane : " + favorilerMap[index]['hastane']),
                        Text("Bölüm : " + favorilerMap[index]['bolum']),
                        Text("Doktor : " + favorilerMap[index]['doktor'])
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return SimpleDialog(
                                  title: Text("Favorilerden Çıkar"),
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("Hastane : " +
                                              favorilerMap[index]['hastane']),
                                          Text("Bölüm : " +
                                              favorilerMap[index]['bolum']),
                                          Text("Doktor : " +
                                              favorilerMap[index]['doktor']),
                                          SizedBox(height: 40),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              RaisedButton(
                                                child: Text("Vazgeç"),
                                                color: Colors.green.shade300,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              SizedBox(width: 20),
                                              RaisedButton(
                                                  child: Text(
                                                      "Favorilenden Çıkar"),
                                                  color: Colors.red.shade300,
                                                  onPressed: () {
                                                    favoriDoktoruSil(
                                                            int.parse(favorilerMap[
                                                                        index]
                                                                    ['doktorID']
                                                                .toString()),
                                                            HastaAnaSayfa
                                                                .hastaID)
                                                        .then((value) {
                                                      setState(() {
                                                        favorilerMap
                                                            .removeAt(index);
                                                        Navigator.pop(context);
                                                      });
                                                    });
                                                  }),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
  }

  Future<int> favoriDoktoruSil(int doktorID, int hastaID) async {
    var db = await DBHelper();
    int id = await db.deleteFavoriDoktor(doktorID, hastaID);
    return id;
  }
}
