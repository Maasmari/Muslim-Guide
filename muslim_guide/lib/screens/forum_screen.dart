import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForumWidget extends StatefulWidget {
  final String taskID;
  final String taskName;

  ForumWidget({Key? key, required this.taskID, required this.taskName})
      : super(key: key);

  @override
  _ForumWidgetState createState() => _ForumWidgetState();
}

class _ForumWidgetState extends State<ForumWidget> {
  late Future<List<Comment>> comments;

  @override
  void initState() {
    super.initState();
    comments = fetchForum();
  }

  Future<List<Comment>> fetchForum() async {
    final response = await http.get(Uri.parse(
        'https://us-central1-muslim-guide-417618.cloudfunctions.net/app/disscussion_forum/forum_by_task?taskID=${widget.taskID}'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['comments'] as List;
      return data.map((comment) => Comment.fromJson(comment)).toList();
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Failed to load forums');
    }
  }

  Future<void> deleteComment(int commentID) async {
    Uri url = Uri.parse(
        'https://us-central1-muslim-guide-417618.cloudfunctions.net/app/disscussion_forum/delete_comment');

    try {
      final response = await http
          .delete(url, body: jsonEncode({'commentID': commentID}), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        print('Comment deleted successfully.');
        setState(() {
          comments = fetchForum();
        });
      } else {
        throw Exception('Failed to delete comment: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }

  Future<void> deleteReply(int replyID) async {
    Uri url = Uri.parse(
        'https://us-central1-muslim-guide-417618.cloudfunctions.net/app/disscussion_forum/delete_reply');
    try {
      final response = await http
          .delete(url, body: jsonEncode({'replyID': replyID}), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        print('Reply deleted successfully.');

        setState(() {
          comments = fetchForum();
        });
      } else {
        throw Exception('Failed to delete reply: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to delete reply: $e');
    }
  }

  Future<void> postComment(String forumID, String userID, String commentText,
      String? Username) async {
    final response = await http.post(
      Uri.parse(
          'https://us-central1-muslim-guide-417618.cloudfunctions.net/app/disscussion_forum/post_comment'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode({
        'forumID': forumID,
        'userID': userID,
        'commentText': commentText,
        'Username':
            FirebaseAuth.instance.currentUser!.displayName, // Include Username
      }),
    );
    if (response.statusCode == 201) {
      print('Comment posted successfully: $commentText');
      setState(() {
        comments = fetchForum(); // Refresh comments
      });
    } else {
      throw Exception('Failed to post comment');
    }
  }

  Future<void> postReply(String commentID, String userID, String replyText,
      String? Username) async {
    final response = await http.post(
      Uri.parse(
          'https://us-central1-muslim-guide-417618.cloudfunctions.net/app/disscussion_forum/post_reply'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode({
        'commentID': commentID,
        'userID': userID,
        'replyText': replyText,
        'Username':
            FirebaseAuth.instance.currentUser!.displayName, // Include Username
      }),
    );
    if (response.statusCode == 201) {
      print('Reply posted successfully: $replyText');
      setState(() {
        comments = fetchForum(); // Refresh replies
      });
    } else {
      throw Exception('Failed to post reply');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discussion Forum'),
        backgroundColor: const Color.fromARGB(255, 30, 87, 32),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 22.0, 16.0, 16.0),
          child: Text(
            '${widget.taskName}',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Comment>>(
            future: comments,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (snapshot.data!.isEmpty) {
                return Center(child: Text('No comments found'));
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final comment = snapshot.data![index];
                    return Card(
                      margin: EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            title: Text(comment.commentText,
                                style: TextStyle(fontSize: 20)),
                            subtitle: Text('@${comment.Username}',
                                style: TextStyle(fontSize: 12)),
                            trailing: (comment.userID ==
                                    FirebaseAuth.instance.currentUser!.uid)
                                ? IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                    ),
                                    onPressed: () async {
                                      try {
                                        await deleteComment(comment.commentID);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                backgroundColor: Colors.green,
                                                content: Text(
                                                    "Comment deleted successfully")));
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Failed to delete comment")));
                                      }
                                    },
                                  )
                                : null,
                          ),
                          ...comment.replies
                              .map((reply) => Padding(
                                    padding: EdgeInsets.only(left: 12.0),
                                    child: ListTile(
                                      title: Text(reply.replyText),
                                      subtitle: Text(
                                          '@${reply.Username}', // Display Username
                                          style: TextStyle(fontSize: 12)),
                                      trailing: (reply.userID ==
                                              FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          ? IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                              ),
                                              onPressed: () async {
                                                try {
                                                  await deleteReply(
                                                      reply.replyID);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          backgroundColor:
                                                              Colors.green,
                                                          content: Text(
                                                              "Reply deleted successfully")));
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              "Failed to delete reply")));
                                                }
                                              },
                                            )
                                          : null,
                                    ),
                                  ))
                              .toList(),
                          ListTile(
                            trailing: Icon(Icons.reply),
                            title: Text(''),
                            onTap: () =>
                                _showReplyDialog(context, comment.commentID),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return Center(child: Text('No data'));
              }
            },
          ),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCommentDialog(context),
        tooltip: 'Add Comment',
        child: Icon(Icons.add_comment),
      ),
    );
  }

  void _showCommentDialog(BuildContext context) {
    TextEditingController commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add a Comment'),
        content: TextField(
          controller: commentController,
          autofocus: true,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final Username = FirebaseAuth.instance.currentUser!.displayName;
              print(Username);
              if (commentController.text.isNotEmpty) {
                postComment(
                    widget.taskID,
                    FirebaseAuth.instance.currentUser!.uid,
                    commentController.text,
                    Username);
                Navigator.of(context).pop();
              }
            },
            child: Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showReplyDialog(BuildContext context, int commentID) {
    TextEditingController replyController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reply to Comment'),
        content: TextField(
          controller: replyController,
          autofocus: true,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final Username = FirebaseAuth.instance.currentUser!.displayName;
              if (replyController.text.isNotEmpty) {
                postReply(
                    commentID.toString(),
                    FirebaseAuth.instance.currentUser!.uid,
                    replyController.text,
                    Username);
                Navigator.of(context).pop();
              }
            },
            child: Text('Send'),
          ),
        ],
      ),
    );
  }
}

class Comment {
  final int commentID;
  final String commentText;
  final String userID;
  final String Username; // Added Username field
  List<Reply> replies;

  Comment({
    required this.commentID,
    required this.commentText,
    required this.userID,
    required this.Username, // Initialize Username in constructor
    required this.replies,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    var list = json['replies'] as List;
    List<Reply> repliesList = list.map((i) => Reply.fromJson(i)).toList();
    return Comment(
      commentID: json['commentID'],
      commentText: json['commentText'],
      userID: json['userID'],
      Username:
          json['Username'] ?? '', // Parse Username, use empty string if null
      replies: repliesList,
    );
  }
}

class Reply {
  final int replyID;
  final String replyText;
  final String userID;
  final String Username; // Added Username field

  Reply({
    required this.replyID,
    required this.replyText,
    required this.userID,
    required this.Username, // Initialize Username in constructor
  });

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      replyID: json['replyID'],
      replyText: json['replyText'],
      userID: json['userID'],
      Username: json['Username'], // Parse Username, use empty string if null
    );
  }
}
