import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final user = _userController.text.trim();
    final pass = _passController.text.trim();

    if (user == 'admin' && pass == 'admin') {
      try {
        print('[DEBUG] Enviando login para API: $user / $pass');
        final response = await http.post(
          Uri.parse('http://164.90.152.205:5000/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'username': user, 'password': pass}),
        );
        print('[DEBUG] Status code da resposta: ${response.statusCode}');
        print('[DEBUG] Body da resposta: ${response.body}');
      } catch (e) {
        print('[DEBUG] Erro ao tentar conectar com a API: $e');
        setState(() {
          _error = 'Erro ao conectar com a API: $e';
        });
      }
    } else {
      setState(() {
        _error = 'Usuário ou senha inválidos';
      });
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4568dc), Color(0xFFb06ab3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 12,
              margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.deepPurple[100],
                        child: const Icon(
                          Icons.directions_car,
                          size: 40,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Bem-vindo",
                        style: Theme.of(context).textTheme.headlineSmall!
                            .copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Faça login para acessar",
                        style: TextStyle(color: Colors.grey[600], fontSize: 15),
                      ),
                      const SizedBox(height: 28),
                      TextFormField(
                        controller: _userController,
                        decoration: InputDecoration(
                          labelText: 'Usuário',
                          prefixIcon: const Icon(Icons.person),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Digite o usuário'
                            : null,
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: _passController,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: const Icon(Icons.lock),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        obscureText: true,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Digite a senha'
                            : null,
                      ),
                      const SizedBox(height: 24),
                      if (_error != null)
                        Text(
                          _error!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    _login();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Entrar',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
