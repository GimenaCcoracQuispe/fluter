import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mikrosystem/models/district.dart';

class DistrictService {
  final String baseUrl = "http://192.168.1.43:8085/v1/district";

  Future<List<District>> getDistricts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<District> districts =
            data.map((json) => District.fromJson(json)).toList();
        return districts;
      } else {
        throw Exception('Failed to load districts');
      }
    } catch (e) {
      throw Exception('Failed to load districts: $e');
    }
  }
}
