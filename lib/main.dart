import 'package:e_randevu/FavoriDoktorlar.dart';
import 'package:e_randevu/GirisSayfasi.dart';
import 'package:e_randevu/HastaAnaSayfa.dart';
import 'package:e_randevu/HastaRandevular.dart';
import 'package:e_randevu/KayitOl.dart';
import 'package:e_randevu/RandevuSayfasi.dart';
import 'package:e_randevu/models/Hasta.dart';
import 'package:e_randevu/models/Hastane.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  List<Hastane> hastaneler;
  List<Hasta> hastalar;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.blue.shade900,
        hintColor: Colors.green.shade300,
        errorColor: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => GirisSayfasi(),
        "/KayitOl": (context) => KayitOl(),
        "/GirisSayfasi":(context)=>GirisSayfasi(),
        "/RandevuSayfasi":(context)=>RandevuSayfasi(),
        "/HastaRandevular":(context)=>HastaRandevular(),
        "/FavoriDoktorlar":(context)=>FavoriDoktorlar(),
      },
      onGenerateRoute: (route){
        var split=route.name.split("/");
        if(split[1]=="HastaAnaSayfa")
          {
            int hastaID=int.parse(split[2]);
            return MaterialPageRoute(builder: (context)=>HastaAnaSayfa(hastaID));
          }
      },
    );
  }
}



