class Task {
  int id;
  final String name;
  bool isDone;

  Task({
    this.name,
    this.isDone = false,
  });

  Task.withId({
    this.id,
    this.name,
    this.isDone,
  });

  void toggleDone() {
    isDone = !isDone;
  }

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['name'] = name;
    map['isDone'] = isDone == false ? 0 : 1;
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task.withId(
      id: map['id'],
      name: map['name'],
      isDone: map['isDone'] == 0 ? false : true,
    );
  }
}
