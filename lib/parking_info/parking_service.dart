
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parkwatch_app/const/const.dart';

class ParkingService {
  // http://10.0.2.2:5000
  // static const String baseUrl = 'http://127.0.0.1:5000'; // Use appropriate IP for physical devices 192.168.100.132

  Future<Map<String, dynamic>> getParkingInfo() async {
    final response = await http.get(Uri.parse('$baseUrl/get_parking_info'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load parking info');
    }
  }
}
