import 'package:flutter/material.dart';
import 'package:myfinance/database/database_helper.dart';
import 'nova_meta_screen.dart';

class MetasFinanceirasScreen extends StatefulWidget {
  const MetasFinanceirasScreen({super.key});

  @override
  State<MetasFinanceirasScreen> createState() =>
      _MetasFinanceirasScreenState();
}

class _MetasFinanceirasScreenState extends State<MetasFinanceirasScreen> {

 List<Map<String, dynamic>> metas = [];

  @override
  void initState() {
    super.initState();
    carregarMetas();
  }

  Future<void> carregarMetas() async {
    final lista = await DatabaseHelper.instance.listarMetas();

    setState(() {
      metas = lista;
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
                    'METAS FINANCEIRAS',
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
                        builder: (context) => const NovaMetaScreen(),
                      ),
                    );

                    carregarMetas();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF743B2B),
                  ),
                  child: const Text(
                    'NOVA META',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: metas.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma meta cadastrada.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: metas.length,
                        itemBuilder: (context, index) {
                          final meta = metas[index];

                          double objetivo =
                              double.tryParse(
                                    (meta['objetivo'] ?? '0')
                                        .replaceAll(RegExp(r'[^0-9]'), ''),
                                  ) ??
                                  0;

                          objetivo = objetivo / 100;

                          double guardado =
                              double.tryParse(
                                    (meta['guardado'] ?? '0')
                                        .replaceAll(RegExp(r'[^0-9]'), ''),
                                  ) ??
                                  0;

                          guardado = guardado / 100;

                          double porcentagem = 0;

                          if (objetivo > 0) {
                            porcentagem = (guardado / objetivo) * 100;
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  meta['nome'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 15),

                                Text('Objetivo: ${meta['objetivo']}'),

                                const SizedBox(height: 8),

                                Text('Guardado: ${meta['guardado']}'),

                                const SizedBox(height: 8),

                                Text(
                                  '${porcentagem.toStringAsFixed(0)}%',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                LinearProgressIndicator(
                                  value: (porcentagem / 100).clamp(0.0, 1.0),
                                ),

                                const SizedBox(height: 15),

                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => NovaMetaScreen(
                                            meta: {
                                              'id': meta['id'].toString(),
                                              'nome': meta['nome'],
                                              'objetivo': meta['objetivo'],
                                              'guardado': meta['guardado'],
                                              'data': meta['data'],
                                            },
                                            index: index,
                                          ),
                                        ),
                                      );
                                      carregarMetas();                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(0xFF743B2B),
                                    ),
                                    child: const Text(
                                      'EDITAR',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await DatabaseHelper.instance.deletarMeta(meta['id']);

                                      carregarMetas();
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