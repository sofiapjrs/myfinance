import 'package:flutter/material.dart';
import 'nova_despesa_screen.dart';
import 'package:myfinance/database/database_helper.dart';

class DespesasFixasScreen extends StatefulWidget {
  const DespesasFixasScreen({super.key});

  @override
  State<DespesasFixasScreen> createState() =>
      _DespesasFixasScreenState();
}

class _DespesasFixasScreenState extends State<DespesasFixasScreen> {

  List<Map<String, dynamic>> despesas = [];

  @override
  void initState() {
    super.initState();
    carregarDespesas();
  }

  Future<void> carregarDespesas() async {
    final lista = await DatabaseHelper.instance.listarDespesas();

    setState(() {
      despesas = lista;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8C8B8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back, size: 30),
                  ),
                  const Text(
                    'DESPESAS FIXAS',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NovaDespesaScreen(),
                      ),
                    );

                    carregarDespesas();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF743B2B),
                  ),
                  child: const Text(
                    'NOVA DESPESA',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: despesas.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma despesa fixa cadastrada.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: despesas.length,
                        itemBuilder: (context, index) {
                          final despesa = despesas[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  despesa['nome'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text('Valor: ${despesa['valor']}'),
                                Text('Categoria: ${despesa['categoria']}'),
                                Text('Data: ${despesa['data']}'),

                                const SizedBox(height: 12),

                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => NovaDespesaScreen(
                                            despesa: {
                                              'id': despesa['id'].toString(),
                                              'nome': despesa['nome'],
                                              'valor': despesa['valor'],
                                              'categoria': despesa['categoria'],
                                              'data': despesa['data'],
                                            },
                                            index: index,
                                          ),
                                        ),
                                      );

                                      carregarDespesas();
                                    },
                                    child: const Text('EDITAR'),
                                  ),
                                ),
                                
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await DatabaseHelper.instance.deletarDespesa(despesa['id']);

                                      carregarDespesas();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Text(
                                      'EXCLUIR',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}