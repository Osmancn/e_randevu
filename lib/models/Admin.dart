class Admin{
  int _adminId;
  String TC;
  String sifre;

  int get adminId => _adminId;

  Admin(this.TC, this.sifre);

  Admin.withID(this._adminId, this.TC, this.sifre);

  Admin.fromMap(Map<String,dynamic> map)
  {
    _adminId=int.parse(map['adminID'].toString());
    TC=map['adminTC'];
    sifre=map['adminSifre'];
  }

  Map<String,dynamic> toMap()
  {
    var map=Map<String,dynamic>();
    map['adminTC'] = TC;
    map['adminSifre'] = sifre;
    return map;
  }

}