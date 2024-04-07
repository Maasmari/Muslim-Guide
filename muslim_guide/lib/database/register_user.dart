// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> registerUser(String id, String email, String username) async {
  String apiUrl =
      'https://us-central1-muslim-guide-417618.cloudfunctions.net/app/register';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userID': id,
        'email': email,
        'username': username,
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, parse the JSON.
      final responseData = json.decode(response.body);
      print('User registered successfully: $responseData');
      // You can return or handle the responseData as needed.
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      final responseData = json.decode(response.body);
      print('Failed to register user: ${responseData['error']}');
      // You can show an error message or handle the error accordingly.
    }
  } catch (e) {
    // If something went wrong with the post request,
    // catch the error and handle it accordingly.
    print('Error occurred while calling the server: $e');
    // You can show an error message or throw an exception.
  }
}
