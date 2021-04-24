import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoey/model/task.dart';
import 'package:todoey/widgets/task_tile.dart';

import '../task_data.dart';

class TasksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Task> tasks;
    int itemCount;
    Future<void> _getTasks() async {
      tasks = await Provider.of<TaskData>(context).tasks;
      itemCount = tasks.length;
    }

    return FutureBuilder(
      future: _getTasks(),
      builder: (context, snapshot) {
        return Consumer<TaskData>(
          builder: (context, taskData, child) {
            if (itemCount != null) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskTile(
                    taskTitle: task.name,
                    isChecked: task.isDone,
                    checkboxCallback: (checkboxState) {
                      taskData.updateTask(task);
                    },
                    deleteCallback: () {
                      taskData.deleteTask(task);
                    },
                  );
                },
                itemCount: itemCount,
              );
            } else {
              return Container();
            }
          },
        );
      },
    );
  }
}
