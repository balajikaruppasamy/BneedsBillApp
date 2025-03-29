import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String Companyid;
  String Companyname;
  String Streetname;
  String Address;
  String City;
  String Emailid;
  String Phonenumber;
  String passwords;
  String gst;
  String Active;

  UserModel({
    required this.id,
    required this.Companyid,
    required this.Companyname,
    required this.Address,
    required this.City,
    required this.Emailid,
    required this.Phonenumber,
    required this.passwords,
    required this.Streetname,
    required this.gst,
    required this.Active,
  });

  static UserModel empty() => UserModel(
      id: '',
      Companyid: '',
      Companyname: '',
      Address: '',
      City: '',
      Emailid: '',
      passwords: '',
      Streetname: '',
      gst: '',
      Active: '',
      Phonenumber: '');

  Map<String, dynamic> toJson() {
    return {
      'COMPANYID': Companyid,
      'COMPANYNAME': Companyname,
      'ADDRESS': Address,
      'CITY': City,
      'EMAILID': Emailid,
      'PHONENUMBER': Phonenumber,
      'STREETNAME': Streetname,
      'GST': gst,
      'PASSWORDS': passwords,
      'ACTIVE': Active
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
          id: document.id,
          Companyid: data['COMPANYID'] ?? '',
          Companyname: data['COMPANYNAME'] ?? '',
          Address: data['ADDRESS'] ?? '',
          City: data['CITY'] ?? '',
          Emailid: data['EMAILID'] ?? '',
          passwords: data['PASSWORDS'] ?? '',
          Streetname: data['STREETNAME'] ?? '',
          gst: data['GST'] ?? '',
           Active : data['ACTIVE'] ?? '',
          Phonenumber: data['PHONENUMBER'] ?? '');
    } else {
      return UserModel.empty();
    }
  }
}
