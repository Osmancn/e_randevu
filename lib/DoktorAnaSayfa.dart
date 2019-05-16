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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Doktor Ana Sayfa")),
      body: Center(
        child: Text(
          "" + DoktorAnaSayfa.doktorID.toString(),
        ),
      ),
    );
  }
}
