class Task {
  final String userId;
  final String name;
  final String description;
  final String date;

  Task({
    required this.userId,
    required this.name,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    //below line is instantiation for empty map object
    var map = <String, dynamic>{};
    map['userId'] = userId;
    map['name'] = name;
    map['description'] = description;
    map['date'] = date;
    return map;
  }

  static Task fromJson(Map<String, dynamic> json) => Task(

        userId: json['userId'],
        name: json['name'],
        description: json['description'],
        date: json['date'],
      );
}
