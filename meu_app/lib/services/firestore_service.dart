import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get currentUserId {
    return FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  Future<void> addTask(String title, String description, double price) async {
    try {
      CollectionReference tasks = _db.collection('tasks');

      await tasks.add({
        'title': title,
        'description': description,
        'price': price,
        'created_at': FieldValue.serverTimestamp(),
        'user_id': currentUserId,
      });
    } catch (e) {
      throw Exception("Erro ao adicionar tarefa: $e");
    }
  }

  Stream<QuerySnapshot> getTasksStream() {
    try {
      return _db
          .collection('tasks')
          .where('user_id', isEqualTo: currentUserId)
          .orderBy('created_at', descending: true)
          .snapshots();
    } catch (e) {
      throw Exception("Erro ao obter tarefas: $e");
    }
  }

  Future<Map<String, dynamic>> getTaskById(String docId) async {
    try {
      DocumentSnapshot document =
          await _db.collection('tasks').doc(docId).get();

      if (document.exists) {
        return document.data() as Map<String, dynamic>;
      } else {
        throw Exception('Documento não encontrado');
      }
    } catch (e) {
      throw Exception('Erro ao obter tarefa: $e');
    }
  }

  Future<void> updateTask(String docId, String newTitle, String newDescription,
      double newPrice) async {
    try {
      await _db.collection('tasks').doc(docId).update({
        'title': newTitle,
        'description': newDescription,
        'price': newPrice,
      });
    } catch (e) {
      throw Exception("Erro ao atualizar tarefa: $e");
    }
  }

  Future<void> deleteTask(String docId) async {
    try {
      await _db.collection('tasks').doc(docId).delete();
    } catch (e) {
      throw Exception("Erro ao deletar tarefa: $e");
    }
  }
}
