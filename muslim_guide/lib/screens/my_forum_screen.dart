import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyForumWidget extends StatefulWidget {
  MyForumWidget({Key? key}) : super(key: key);

  @override
  _MyForumWidgetState createState() => _MyForumWidgetState();
}

class _MyForumWidgetState extends State<MyForumWidget> {
  late Future<List<Forum>> forumsFuture;
  // late map of int taskID and string taskName
  late Future<Map<int, String>> taskMap;

  @override
  void initState() {
    super.initState();
    forumsFuture = fetchForum();
    taskMap = fetchTaskNames();
  }

  Future<Map<int, String>> fetchTaskNames() async {
    final response = await http.get(Uri.parse(
        'https://us-central1-muslim-guide-417618.cloudfunctions.net/app/disscussion_forum/tasks_names'));
    // print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> jsonData =
          jsonDecode(response.body); // Decode as List, not Map
      Map<int, String> tasksMap = {
        for (var item in jsonData) item['taskID']: item['taskName']
      };
      print(tasksMap);
      return tasksMap;
    } else {
      throw Exception('Failed to load task names');
    }
  }

  Future<List<Forum>> fetchForum() async {
    final response = await http.get(Uri.parse(
        'https://us-central1-muslim-guide-417618.cloudfunctions.net/app/disscussion_forum/forum_by_user?userID=${FirebaseAuth.instance.currentUser!.uid}'));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData['comments'] != null) {
        var data = List<Map<String, dynamic>>.from(jsonData['comments']);
        return data.map((forum) => Forum.fromJson(forum)).toList();
      } else {
        return [];
      }
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
          forumsFuture = fetchForum();
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
        'https://us-central1-muslim-guide-417618.cloudfunctions.net/app/delete_reply');
    try {
      final response = await http
          .delete(url, body: jsonEncode({'replyID': replyID}), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        print('Reply deleted successfully.');

        setState(() {
          forumsFuture = fetchForum();
        });
      } else {
        throw Exception('Failed to delete reply: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to delete reply: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Comments and Replies'),
        backgroundColor: const Color.fromARGB(255, 30, 87, 32),
      ),
      body: FutureBuilder<Map<int, String>>(
        future: taskMap,
        builder: (context, taskSnapshot) {
          if (taskSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (taskSnapshot.hasError) {
            return Center(
                child:
                    Text("Failed to load task names: ${taskSnapshot.error}"));
          } else {
            return FutureBuilder<List<Forum>>(
              future: forumsFuture,
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
                      final forum = snapshot.data![index];
                      return ExpansionTile(
                        initiallyExpanded: true,
                        title: Text(
                            'Forum Of: ${taskSnapshot.data![forum.forumID]}'),
                        children: forum.comments
                            .map((comment) => Card(
                                  margin: EdgeInsets.all(14.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ListTile(
                                        title: Text(comment.commentText,
                                            style: TextStyle(fontSize: 20)),
                                        subtitle: Text('@${comment.Username}',
                                            style: TextStyle(fontSize: 12)),
                                        trailing: (comment.userID ==
                                                FirebaseAuth
                                                    .instance.currentUser!.uid)
                                            ? IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                ),
                                                onPressed: () async {
                                                  try {
                                                    await deleteComment(
                                                        comment.commentID);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            backgroundColor:
                                                                Colors.green,
                                                            content: Text(
                                                                "Comment deleted successfully")));
                                                  } catch (e) {
                                                    ScaffoldMessenger.of(
                                                            context)
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
                                                padding:
                                                    EdgeInsets.only(left: 12.0),
                                                child: ListTile(
                                                  title: Text(reply.replyText),
                                                  subtitle: Text(
                                                      '@${reply.Username}',
                                                      style: TextStyle(
                                                          fontSize: 12)),
                                                  trailing:
                                                      (reply.userID ==
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid)
                                                          ? IconButton(
                                                              icon: Icon(
                                                                Icons.delete,
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                try {
                                                                  await deleteReply(
                                                                      reply
                                                                          .replyID);
                                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .green,
                                                                      content: Text(
                                                                          "Reply deleted successfully")));
                                                                } catch (e) {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(SnackBar(
                                                                          content:
                                                                              Text("Failed to delete reply")));
                                                                }
                                                              },
                                                            )
                                                          : null,
                                                ),
                                              ))
                                          .toList(),
                                    ],
                                  ),
                                ))
                            .toList(),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('No data'));
                }
              },
            );
          }
        },
      ),
    );
  }
}

class Forum {
  final int forumID;
  List<Comment> comments;

  Forum({
    required this.forumID,
    required this.comments,
  });

  factory Forum.fromJson(Map<String, dynamic> json) {
    var list = json['comments'] as List;
    List<Comment> commentsList = list.map((i) => Comment.fromJson(i)).toList();
    return Forum(
      forumID: json['forumID'],
      comments: commentsList,
    );
  }
}

class Comment {
  final int commentID;
  final String commentText;
  final String userID;
  final String Username;
  List<Reply> replies;

  Comment({
    required this.commentID,
    required this.commentText,
    required this.userID,
    required this.Username,
    required this.replies,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    // if (json['userID'] != FirebaseAuth.instance.currentUser!.uid) return null;
    //if the username of the comment is not the same as the current user, return null

    var list = json['replies'] as List<dynamic>? ?? [];
    List<Reply> repliesList = list.map((i) => Reply.fromJson(i)).toList();
    return Comment(
      commentID: json['commentID'],
      commentText: json['commentText'],
      userID: json['userID'],
      Username: json['Username'] ?? '',
      replies: repliesList,
    );
  }
}

class Reply {
  final int replyID;
  final String replyText;
  final String userID;
  final String Username;

  Reply({
    required this.replyID,
    required this.replyText,
    required this.userID,
    required this.Username,
  });

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      replyID: json['replyID'],
      replyText: json['replyText'],
      userID: json['userID'],
      Username: json['Username'] ?? 'Anonymous',
    );
  }
}
