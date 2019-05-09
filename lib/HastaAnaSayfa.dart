import 'package:flutter/material.dart';

class HastaAnaSayfa extends StatefulWidget {
  int hastaID;

  HastaAnaSayfa(this.hastaID);

  @override
  _HastaAnaSayfaState createState() => _HastaAnaSayfaState();
}

class _HastaAnaSayfaState extends State<HastaAnaSayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ana Sayfa"),
      ),
      body: Center(child: Text(widget.hastaID.toString()),),
    );
  }
}
