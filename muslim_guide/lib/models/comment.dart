import 'package:flutter/material.dart';
import 'package:muslim_guide/screens/task_list_screen.dart';
//import 'package:uuid/uuid.dart';

//const uuid = Uuid();

List<String> getDiscussionForums () {
  List<String> DFs = [];
  for (int i = 0; i < listOfTasks.length; i++) {
    DFs[i] = listOfTasks[i].taskName;
  }
  return DFs;
}

class Comment {
  Comment({
    required this.username,
    required this.comment,
    required this.DiscussionForum,
    replyToUser,
    //required this.date,
    //required this.time,
  });
  
  final String username;
  String comment;
  String replyToUser = '';
  String DiscussionForum;
  List<String> ListOfForums = getDiscussionForums();
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

}
