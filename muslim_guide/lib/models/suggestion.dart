
//enum TaskType { optional, compulsory }

class Suggestion {
  //final String id;
  String taskName;
  String taskDescription;

  Suggestion({
    //required this.id,
    required this.taskName,
    required this.taskDescription,

  });
}

List<Suggestion> ListOfSuggestions = [];