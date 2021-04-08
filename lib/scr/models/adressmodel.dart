import 'package:cloud_firestore/cloud_firestore.dart';

class Address{
  static const ADDRESS = "adrress";
  String _adrress;
  String get adrress =>_adrress;
  Address.fromSnapshot(DocumentSnapshot snapshot){
    _adrress = snapshot.data()[ADDRESS];

  }

}