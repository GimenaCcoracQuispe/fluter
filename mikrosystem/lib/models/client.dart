import 'package:mikrosystem/models/district.dart';

class Client {
  int id;
  String name;
  String last_name;
  String cellphone;
  String email;
  String type_document;
  String document_number;
  District district;
  String address;
  String state;

  Client({
    required this.id,
    required this.name,
    required this.last_name,
    required this.cellphone,
    required this.email,
    required this.type_document,
    required this.document_number,
    required this.district,
    required this.address,
    required this.state,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      name: json['name'],
      last_name: json['last_name'],
      cellphone: json['cellphone'],
      email: json['email'],
      type_document: json['type_document'],
      document_number: json['document_number'],
      district: District.fromJson(json['district']),
      address: json['address'],
      state: json['state'],
    );
  }
}
