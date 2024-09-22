
import 'dart:convert';
import 'package:http/http.dart' as http;

class ParkingService2 {
  // http://10.0.2.2:5000
  // static const String baseUrl = 'http://127.0.0.1:5000'; // Use appropriate IP for physical devices 192.168.100.132
  static const String baseUrl = 'http://192.168.100.177:5000';

  Future<Map<String, dynamic>> getParkingInfo() async {
    final response = await http.get(Uri.parse('$baseUrl/get_parking_info2'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load parking info');
    }
  }
}