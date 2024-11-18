import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meu_app/services/authentication_service.dart';
import 'package:meu_app/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final FirestoreService firestoreService = FirestoreService();

  Future<void> openModalForm({String? docId}) async {
    if (docId != null) {
      try {
        var task = await firestoreService.getTaskById(docId);
        titleController.text = task['title'];
        descriptionController.text = task['description'];
        priceController.text = task['price']?.toString() ?? '';
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar veículo: $e')),
        );
      }
    } else {
      titleController.clear();
      descriptionController.clear();
      priceController.clear();
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                docId != null ? 'Editar Carro' : 'Adicionar Novo Carro',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Preço',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  String title = titleController.text;
                  String description = descriptionController.text;
                  String priceText = priceController.text;

                  if (title.isNotEmpty &&
                      description.isNotEmpty &&
                      priceText.isNotEmpty) {
                    try {
                      double price = double.parse(priceText);

                      if (docId != null) {
                        await firestoreService.updateTask(
                          docId,
                          title,
                          description,
                          price,
                        );
                      } else {
                        await firestoreService.addTask(
                            title, description, price);
                      }

                      titleController.clear();
                      descriptionController.clear();
                      priceController.clear();

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Carro salvo com sucesso!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao salvar o veículo: $e')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Por favor, preencha todos os campos!')),
                    );
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WG Cars'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                widget.user.displayName != null
                    ? widget.user.displayName!
                    : "Não informado",
              ),
              accountEmail: Text(
                widget.user.email != null
                    ? widget.user.email!
                    : "Não informado",
              ),
            ),
            ListTile(
              title: const Text('Deslogar'),
              leading: const Icon(Icons.logout),
              onTap: () {
                AuthenticationService().logoutUser();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openModalForm(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getTasksStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            var tasks = snapshot.data!.docs;

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = tasks[index];
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;

                String title = data['title'] ?? 'Sem título';
                String description = data['description'] ?? 'Sem descrição';
                String price =
                    data['price'] != null ? '\$${data['price']}' : 'Sem preço';

                String docId = document.id;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    tileColor: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    title: Text(title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(description),
                        Text(price,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            )),
                        Text(
                          document['created_at'] != null
                              ? document['created_at'].toDate().toString()
                              : 'Sem data',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            openModalForm(docId: docId);
                          },
                          icon: const Icon(Icons.settings),
                        ),
                        IconButton(
                          onPressed: () async {
                            try {
                              await firestoreService.deleteTask(docId);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Veículo deletado com sucesso!')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Erro ao deletar veículo: $e')),
                              );
                            }
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Nenhum veículo encontrado.'));
          }
        },
      ),
    );
  }
}
