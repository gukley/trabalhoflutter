import 'package:flutter/material.dart';
import 'package:meu_app/views/list_view.dart';
import 'package:meu_app/views/form_task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 0, 72, 65)),
          useMaterial3: false,
        ),
        home: MyWidget(),
        routes: {
          '/listarTarefas': (context) => ListViewTask(),
          '/FormularioTarefas': (context) => FormTask()
        });
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Minhas lista de tarefas')),
        drawer: Drawer(
            child: Column(
          children: [
            UserAccountsDrawerHeader(
                accountName: Text('Gustavo'),
                accountEmail: Text('gustavokley11@gmail.com'),
                currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white, child: Icon(Icons.person))),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Listagem de Terefas'),
              onTap: () {
                Navigator.pushNamed(context, '/listarTarefas');
              },
            )
          ],
        )),
        body: Stack(
          children: [
            Padding(
                padding: EdgeInsets.only(right: 30, bottom: 30),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/FormularioTarefas');
                        },
                        child: Icon(Icons.add))))
          ],
        ));
  }
}
