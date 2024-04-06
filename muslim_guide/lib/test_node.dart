import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _data = 'Press the button to fetch data';

  Future<void> fetchData() async {
    final url = Uri.parse(
        'http://localhost:3000/test-connection'); // Change to your server's IP if not running locally
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      setState(() {
        _data = result.containsKey('tables')
            ? 'Tables: ${result['tables'].join(', ')}'
            : result['message'];
      });
    } else {
      setState(() {
        _data = 'Failed to fetch data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data from Node.js'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_data),
              ElevatedButton(
                onPressed: fetchData,
                child: Text('Fetch Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
