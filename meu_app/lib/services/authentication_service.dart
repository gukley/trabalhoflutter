import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthenticationService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  registerUser(
      {required String name,
      required String email,
      required String password}) async {
    try {
      UserCredential credential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await credential.user!.updateDisplayName(name);
    } on FirebaseException catch (e) {
      print(e.code);
      if (e.code == 'email-already-in-use') {
        return 'Email já cadastrado!';
      }
    }
  }

  loginUser({required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  logoutUser() {
    return firebaseAuth.signOut();
  }

  
}
