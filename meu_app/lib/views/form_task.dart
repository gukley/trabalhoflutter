import 'package:flutter/material.dart';
import 'package:meu_app/models/task_model.dart';
import 'package:meu_app/services/task_service.dart';

class FormTask extends StatefulWidget {
  final Task? task;
  final int? index;

  const FormTask({super.key, this.task, this.index});

  @override
  State<FormTask> createState() => _FormTaskState();
}

class _FormTaskState extends State<FormTask> {
  final _formKey = GlobalKey<FormState>();
  final TaskService taskService = TaskService();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  String _priority = 'Baixa';

  @override
  void initState() {
    if (widget.task != null) {
      _titleController.text = widget.task!.title!;
      _descriptionController.text = widget.task!.description!;
      _priority = widget.task!.priority ?? 'Baixa';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Tarefa' : 'Criar Tarefa'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '*Titulo não preenchido!';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  label: Text('Titulo de Tarefa'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _descriptionController,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                decoration: InputDecoration(
                  label: Text('Descrição da Tarefa'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Center(
                child: Column(
                  children: [
                    Text('Prioridade:'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Baixa',
                              groupValue: _priority,
                              onChanged: (String? value) {
                                setState(() {
                                  _priority = value!;
                                });
                              },
                            ),
                            const Text('Baixa'),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Média',
                              groupValue: _priority,
                              onChanged: (String? value) {
                                setState(() {
                                  _priority = value!;
                                });
                              },
                            ),
                            const Text('Média'),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Alta',
                              groupValue: _priority,
                              onChanged: (String? value) {
                                setState(() {
                                  _priority = value!;
                                });
                              },
                            ),
                            const Text('Alta'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String title = _titleController.text;
                  String description = _descriptionController.text;

                  if (widget.task != null && widget.index != null) {
                    await taskService.editTask(
                      widget.index!,
                      title,
                      description,
                      _priority,
                      false,
                    );
                  } else {
                    await taskService.saveTask(
                      title,
                      description,
                      _priority,
                    );
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(isEditing ? 'Alterar Tarefa' : 'Salvar Tarefa'),
            ),
          ],
        ),
      ),
    );
  }
}
