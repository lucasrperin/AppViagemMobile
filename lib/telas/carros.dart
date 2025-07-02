import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class CarScreen extends StatefulWidget {
  @override
  _CarScreenState createState() => _CarScreenState();
}

class _CarScreenState extends State<CarScreen> {
  // Storage
  final box = GetStorage();

  // Formulário de CRUD
  final _crudFormKey     = GlobalKey<FormState>();
  final _modeloController = TextEditingController();
  final _placaController  = TextEditingController();

  // Estado
  String? _token;
  List<dynamic> veiculos = [];
  String? veiculoEditandoId;

  // URL da API
  final String apiUrl = 'http://164.90.152.205:5000/veiculos';

  @override
  void initState() {
    super.initState();
    // 1) lê o token gravado no LoginScreen
    _token = box.read<String>('token');
    if (_token == null) {
      // se não tiver token, volta para o login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/');
      });
    } else {
      // 2) carrega a lista de veículos
      fetchVeiculos();
    }
  }

  // cabeçalhos com o token
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'access-token': _token!,
      };

  // READ
  Future<void> fetchVeiculos() async {
    final resp = await http.get(Uri.parse(apiUrl), headers: _headers);
    if (resp.statusCode == 200) {
      setState(() => veiculos = json.decode(resp.body));
    } else {
      print('Erro ao carregar veículos: ${resp.body}');
    }
  }

  // CREATE / UPDATE
  Future<void> salvarVeiculo() async {
  if (!_crudFormKey.currentState!.validate()) return;

  final payload = {
    'id':     veiculoEditandoId,      // inclui o id aqui
    'modelo': _modeloController.text,
    'placa':  _placaController.text,
  };

  final resp = await http.put(
    Uri.parse(apiUrl),
    headers: _headers,
    body: json.encode(payload),
  );

  print('↩️ Status PUT: ${resp.statusCode}, body: ${resp.body}');
  if (resp.statusCode == 200) {
    limparFormulario();
    fetchVeiculos();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Atualizado com sucesso!')),
    );
  } else {
    print('Erro ao atualizar veículo: ${resp.body}');
  }
}


  // DELETE
  Future<void> removerVeiculo(String id) async {
    final url = '$apiUrl?id=$id';
    final resp = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'access-token': _token!,
      },
    );
    if (resp.statusCode == 200) {
      fetchVeiculos();
      ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Veículo removido')));
    } else {
      print('Erro ao remover veículo: ${resp.body}');
    }
  }

  // preencher formulário para edição
  void carregarParaEdicao(Map<String, dynamic> v) {
    setState(() {
      _modeloController.text = v['modelo'];
      _placaController.text  = v['placa'];
      veiculoEditandoId      = v['id'];
    });
  }

  // limpar form
  void limparFormulario() {
    _modeloController.clear();
    _placaController.clear();
    veiculoEditandoId = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(veiculoEditandoId == null
            ? 'Cadastro de Veículos'
            : 'Editar Veículo'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Formulário de CREATE / UPDATE
            Form(
              key: _crudFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _modeloController,
                    decoration: const InputDecoration(labelText: 'Modelo'),
                    validator: (v) =>
                        v!.isEmpty ? 'Informe o modelo' : null,
                  ),
                  TextFormField(
                    controller: _placaController,
                    decoration: const InputDecoration(labelText: 'Placa'),
                    validator: (v) =>
                        v!.isEmpty ? 'Informe a placa' : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: salvarVeiculo,
                        child: Text(
                          veiculoEditandoId == null
                              ? 'Cadastrar'
                              : 'Salvar Alterações',
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (veiculoEditandoId != null)
                        TextButton(
                          onPressed: limparFormulario,
                          child: const Text('Cancelar'),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Lista de veículos
            Expanded(
              child: RefreshIndicator(
                onRefresh: fetchVeiculos,
                child: ListView.builder(
                  itemCount: veiculos.length,
                  itemBuilder: (ctx, i) {
                    final v = veiculos[i];
                    return ListTile(
                      title: Text(v['modelo']),
                      subtitle: Text('Placa: ${v['placa']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => carregarParaEdicao(v),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => removerVeiculo(v['id']),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
