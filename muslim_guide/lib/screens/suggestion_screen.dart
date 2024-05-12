import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class SuggestionService {
  Future<List<dynamic>> fetchSuggestions() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final response = await http.get(Uri.parse(
        'https://us-central1-muslim-guide-417618.cloudfunctions.net/app/suggestion/view/$userId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Failed to load suggestions');
    }
  }
}

class SuggestionsScreen extends StatefulWidget {
  @override
  _SuggestionsScreenState createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
  final SuggestionService _suggestionService = SuggestionService();
  late Future<List<dynamic>> _suggestions;

  @override
  void initState() {
    super.initState();
    _suggestions = _suggestionService.fetchSuggestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 30, 87, 32),
          title: Text('My Suggestions', style: TextStyle(color: Colors.white))),
      body: FutureBuilder<List<dynamic>>(
        future: _suggestions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data!.isEmpty) {
            return Center(child: Text('No suggestions found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final suggestion = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(suggestion['taskName'] ?? 'No Title',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    // subtitle:
                    //     Text(suggestion['taskDescription'] ?? 'No Description'),
                    // trailing: suggestion['isRecurring'] == 'pending'
                    //     ? Icon(Icons.pending_actions, color: Colors.orange)
                    //     : Icon(Icons.check_circle, color: Colors.green),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('\n' + suggestion['taskDescription']),
                        Text(
                            '\nStatus: ${suggestion['isRecurring'] == 0 ? 'Pending' : 'Approved'}'),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
