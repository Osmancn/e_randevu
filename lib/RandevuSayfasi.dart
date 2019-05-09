import 'package:e_randevu/models/Bolum.dart';
import 'package:e_randevu/models/Doktor.dart';
import 'package:e_randevu/models/Hastane.dart';
import 'package:e_randevu/utils/DBHelper.dart';
import 'package:flutter/material.dart';

class RandevuSayfasi extends StatefulWidget {
  @override
  _RandevuSayfasiState createState() => _RandevuSayfasiState();
}

class _RandevuSayfasiState extends State<RandevuSayfasi> {
  List<Hastane> hastaneler;
  Hastane _secilenHastane;
  Bolum _secilenBolum;
  Doktor _secilenDoktor;
  DateTime _secilenTarih = DateTime.now();
  List<DropdownMenuItem<Hastane>> _dDMenuItemHastane;
  List<DropdownMenuItem<Bolum>> _dDMenuItemBolum;
  List<DropdownMenuItem<Doktor>> _dDMenuItemDoktor;

  String _validator = "";

  @override
  void initState() {
    // TODO: implement initState
    HastaleriGetir().then((hstneler){
      setState(() {
        hastaneler=hstneler;
        _dDMenuItemHastane = getDropDownMenuHastane();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Randevu")),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 40),
          Center(
            child: Text(
              "Randevu",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
            child: Row(
              children: <Widget>[
                Text(
                  "Hastane : ",
                  style: TextStyle(fontSize: 18, color: Colors.green.shade700),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: DropdownButton<Hastane>(
                    isExpanded: true,
                    items: _dDMenuItemHastane,
                    onChanged: (value) {
                      setState(() {
                        _secilenHastane = value;
                        if (_dDMenuItemBolum != null) _dDMenuItemBolum.clear();
                        _secilenBolum = null;
                        if (_dDMenuItemDoktor != null)
                          _dDMenuItemDoktor.clear();
                        _secilenDoktor = null;
                        _dDMenuItemBolum = getDropDownMenuBolum();
                      });
                    },
                    value: _secilenHastane,
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
            child: Row(
              children: <Widget>[
                Text(
                  "Bolum : ",
                  style: TextStyle(fontSize: 18, color: Colors.green.shade700),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: DropdownButton<Bolum>(
                    isExpanded: true,
                    items: _dDMenuItemBolum,
                    onChanged: (value) {
                      setState(() {
                        _secilenBolum = value;
                        if (_dDMenuItemDoktor != null)
                          _dDMenuItemDoktor.clear();
                        _secilenDoktor = null;
                        _dDMenuItemDoktor = getDropDownMenuDoktor();
                      });
                    },
                    value: _secilenBolum,
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
            child: Row(
              children: <Widget>[
                Text(
                  "Doktor : ",
                  style: TextStyle(fontSize: 18, color: Colors.green.shade700),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: DropdownButton<Doktor>(
                    isExpanded: true,
                    items: _dDMenuItemDoktor,
                    onChanged: (value) {
                      setState(() {
                        _secilenDoktor = value;
                      });
                    },
                    value: _secilenDoktor,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "Tarih : ",
                style: TextStyle(fontSize: 18, color: Colors.green.shade700),
              ),
              Text(
                "" +
                    _secilenTarih.day.toString() +
                    "." +
                    _secilenTarih.month.toString() +
                    "." +
                    _secilenTarih.year.toString(),
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              GestureDetector(
                child: Icon(
                  Icons.date_range,
                  color: Colors.cyan.shade600,
                ),
                onTap: () {
                  showDatePicker(
                          context: context,
                          firstDate: DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day),
                          initialDate: _secilenTarih,
                          lastDate: DateTime(DateTime.now().year,
                              DateTime.now().month + 3, DateTime.now().day))
                      .then((secilenTrh) {
                    setState(() {
                      if (secilenTrh != null) _secilenTarih = secilenTrh;
                    });
                  });
                },
              )
            ],
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              _validator,
              style: TextStyle(
                fontSize: 14,
                color: Colors.red,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 80),
            child: RaisedButton.icon(
              icon: Icon(Icons.navigate_next),
              label: Text(
                "Devam",
                style: TextStyle(fontSize: 18),
              ),
              color: Colors.cyan,
              onPressed: () {
                if (_secilenDoktor != null &&
                    _secilenBolum != null &&
                    _secilenDoktor != null) {
                  debugPrint("hastane : ${_secilenHastane.hastaneAdi}\n" +
                      "bölüm : ${_secilenBolum.bolumAdi}\n" +
                      "doktor : ${_secilenDoktor.ad} ${_secilenDoktor.soyad}");
                } else {
                  setState(() {
                    _validator = "Lütfen bütün alanları doldurunuz";
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Hastane>> HastaleriGetir()async
  {
    var db = await DBHelper();
    var hastanelerr=await db.getHastaneler();
    return hastanelerr;
  }

  List<DropdownMenuItem<Hastane>> getDropDownMenuHastane() {
    List<DropdownMenuItem<Hastane>> ddMenuHastane = new List();
    for (int i = 0; i < hastaneler.length; i++) {
      ddMenuHastane.add(new DropdownMenuItem<Hastane>(
        child: Text(hastaneler[i].hastaneAdi),
        value: hastaneler[i],
      ));
    }
    return ddMenuHastane;
  }

  List<DropdownMenuItem<Bolum>> getDropDownMenuBolum() {
    List<DropdownMenuItem<Bolum>> ddMenuBolum = new List();

    for (int i = 0; i < _secilenHastane.bolumler.length; i++) {
      ddMenuBolum.add(new DropdownMenuItem<Bolum>(
        child: Text(_secilenHastane.bolumler[i].bolumAdi),
        value: _secilenHastane.bolumler[i],
      ));
    }
    return ddMenuBolum;
  }

  List<DropdownMenuItem<Doktor>> getDropDownMenuDoktor() {
    List<DropdownMenuItem<Doktor>> ddMenuDoktor = new List();
    for (int i = 0; i < _secilenBolum.doktorlar.length; i++) {
      ddMenuDoktor.add(new DropdownMenuItem<Doktor>(
        child: Text(_secilenBolum.doktorlar[i].ad +
            " " +
            _secilenBolum.doktorlar[i].soyad),
        value: _secilenBolum.doktorlar[i],
      ));
    }
    return ddMenuDoktor;
  }
}
