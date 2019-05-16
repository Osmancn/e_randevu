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
      body: Center(
        child: Text("" + AdminAnaSayfa.adminID.toString()),
      ),
    );
  }
}
