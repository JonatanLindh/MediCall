import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:medicall/contants/api.dart';

// ignore_for_file: use_setters_to_change_properties

class CallRepository {
  Future<String?> getVideoToken({String roomName = ''}) async {
    final response = await http.get(
      Uri.parse('$apiUrl/getvideotoken/$roomName'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');
    }
    return null;
  }

  Future<List<String>> getAllRooms() async {
    final response = await http.get(
      Uri.parse('$apiUrl/getallrooms'),
      headers: {'Content-Type': 'application/json'},
    );

    final decoded = jsonDecode(response.body);
    // Safely convert to List<String>
    final rooms = (decoded as List).map((e) => e.toString()).toList();
    return rooms;
  }
}
