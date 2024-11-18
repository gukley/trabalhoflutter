import 'package:flutter/material.dart';
import 'package:meu_app/services/authentication_service.dart';
import 'package:meu_app/widgets/snack_bar_widget.dart';
import 'package:meu_app/widgets/text_field_widget.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({super.key});

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  AuthenticationService authService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("WG Cars"),
          backgroundColor: Colors.indigo, // AppBar com cor clara
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[50]!, Colors.blue[100]!], // Gradiente claro
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Text(
                      "Crie sua conta",
                      style: TextStyle(
                        color: Colors.indigo, // Cor do texto clara
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            style: const TextStyle(color: Colors.black87),
                            decoration: decoration("Nome").copyWith(
                              fillColor: Colors.grey[100], // Fundo claro
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[600]),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                            ),
                            validator: (value) =>
                                requiredValidator(value, "o nome"),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.black87),
                            decoration: decoration("Email").copyWith(
                              fillColor: Colors.grey[100], // Fundo claro
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[600]),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                            ),
                            validator: (value) =>
                                requiredValidator(value, "o email"),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            style: const TextStyle(color: Colors.black87),
                            decoration: decoration("Senha").copyWith(
                              fillColor: Colors.grey[100], // Fundo claro
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[600]),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                            ),
                            validator: (value) =>
                                requiredValidator(value, "a senha"),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, // Cor do botão
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 50,
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                String name = _nameController.text;
                                String email = _emailController.text;
                                String password = _passwordController.text;
                                authService
                                    .registerUser(
                                  name: name,
                                  email: email,
                                  password: password,
                                )
                                    .then((value) {
                                  if (value != null) {
                                    snackBarWidget(
                                      context: context,
                                      title: value,
                                      isError: true,
                                    );
                                  } else {
                                    snackBarWidget(
                                      context: context,
                                      title: 'Cadastro efetuado com sucesso!',
                                      isError: false,
                                    );
                                    Navigator.pop(context);
                                  }
                                });
                              }
                            },
                            child: const Text(
                              'Registrar',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            child: const Text(
                              "Já tem uma conta? Faça login",
                              style: TextStyle(color: Colors.indigo),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          ),
        ));
  }
}
