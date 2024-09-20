import 'package:flutter/material.dart';
import 'package:meu_app/models/task_model.dart';
import 'package:meu_app/services/task_service.dart';
import 'package:meu_app/views/form_task.dart';

class ListViewTask extends StatefulWidget {
  const ListViewTask({super.key});

  @override
  State<ListViewTask> createState() => _ListViewTaskState();
}

class _ListViewTaskState extends State<ListViewTask> {
  TaskService taskService = TaskService();
  List<Task> tasks = [];

  Future<void> getAllTasks() async {
    tasks = await taskService.getTasks();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAllTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Minhas Lista de Tarefas')),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          bool localIsDone = tasks[index].isDone ?? false;
          String priority = tasks[index].priority ?? 'Baixa';

          return Column(
            children: [
              Card(
                color: const Color.fromARGB(255, 231, 229, 229),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              tasks[index].title.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: localIsDone
                                    ? const Color.fromARGB(255, 88, 87, 87)
                                    : Colors.red,
                                decoration: localIsDone
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                          Checkbox(
                            value: localIsDone,
                            onChanged: (value) async {
                              if (value != null) {
                                await taskService.editTask(
                                  index,
                                  tasks[index].title!,
                                  tasks[index].description!,
                                  priority,
                                  value,
                                );
                                setState(() {
                                  tasks[index].isDone = value;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      Text(
                        tasks[index].description.toString(),
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FormTask(
                                    task: tasks[index],
                                    index: index,
                                  ),
                                ),
                              ).then((value) => getAllTasks());
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () async {
                              await taskService.deleteTask(index);
                              getAllTasks();
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                      Text(
                        'Prioridade: $priority',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: priority == 'Alta'
                              ? Colors.red
                              : priority == 'Média'
                                  ? Colors.orange
                                  : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
