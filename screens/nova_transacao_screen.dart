import 'package:flutter/material.dart';
import 'package:myfinance/database/database_helper.dart';

class NovaTransacaoScreen extends StatefulWidget {
  const NovaTransacaoScreen({super.key});

  @override
  State<NovaTransacaoScreen> createState() => _NovaTransacaoScreenState();
}

class _NovaTransacaoScreenState extends State<NovaTransacaoScreen> {
  final nomeController = TextEditingController();
  final valorController = TextEditingController();
  final dataController = TextEditingController();
  final descricaoController = TextEditingController();

  String? categoriaSelecionada;

  final List<String> categorias = [
    'Mercado',
    'Contas',
    'Transporte',
    'Lazer',
    'Saúde',
    'Alimentação',
    'Outros',
  ];

  String tipoSelecionado = 'Despesa';

  @override
  void dispose() {
    nomeController.dispose();
    valorController.dispose();
    dataController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  void formatarValor(String texto) {
    String numeros = texto.replaceAll(RegExp(r'[^0-9]'), '');

    if (numeros.isEmpty) {
      valorController.clear();
      return;
    }

    double valor = double.parse(numeros) / 100;

    String textoFormatado = valor.toStringAsFixed(2).replaceAll('.', ',');
    textoFormatado = 'R\$ $textoFormatado';

    valorController.value = TextEditingValue(
      text: textoFormatado,
      selection: TextSelection.collapsed(offset: textoFormatado.length),
    );
  }

  void formatarData(String texto) {
    String numeros = texto.replaceAll(RegExp(r'[^0-9]'), '');

    if (numeros.length == 4) {
      String dataFormatada =
          '${numeros.substring(0, 2)}/${numeros.substring(2, 4)}/2026';

      dataController.value = TextEditingValue(
        text: dataFormatada,
        selection: TextSelection.collapsed(offset: dataFormatada.length),
      );
    }
  }

  void salvarTransacao() async {
    await DatabaseHelper.instance.inserirTransacao({
      'tipo': tipoSelecionado,
      'nome': nomeController.text,
      'valor': valorController.text,
      'categoria': categoriaSelecionada ?? 'Sem categoria',
      'data': dataController.text,
      'descricao': descricaoController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Transação salva com sucesso!'),
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8C8B8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back, size: 32),
                  ),
                  const Text(
                    'NOVA TRANSAÇÃO',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: DropdownButtonFormField<String>(
                  value: tipoSelecionado,

                  decoration: InputDecoration(
                    hintText: 'Tipo da transação',

                    filled: true,
                    fillColor: const Color(0xFF00B86B),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),

                  items: const [

                    DropdownMenuItem(
                      value: 'Despesa',
                      child: Text('Despesa'),
                    ),

                    DropdownMenuItem(
                      value: 'Receita',
                      child: Text('Receita'),
                    ),
                  ],

                  onChanged: (valor) {
                    setState(() {
                      tipoSelecionado = valor!;
                    });
                  },
                ),
              ),

              campoTexto(
                controller: nomeController,
                hint: 'Nome da transação',
                cor: const Color(0xFF0585A8),
              ),

              campoTexto(
                controller: valorController,
                hint: 'Valor',
                cor: const Color(0xFF9B9A1F),
                teclado: TextInputType.number,
                aoDigitar: formatarValor,
              ),

              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: DropdownButtonFormField<String>(
                  value: categoriaSelecionada,
                  decoration: InputDecoration(
                    hintText: 'Categoria',
                    filled: true,
                    fillColor: const Color(0xFF22BF66),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: categorias.map((categoria) {
                    return DropdownMenuItem(
                      value: categoria,
                      child: Text(categoria),
                    );
                  }).toList(),
                  onChanged: (valor) {
                    setState(() {
                      categoriaSelecionada = valor;
                    });
                  },
                ),
              ),

              campoTexto(
                controller: dataController,
                hint: 'Data',
                cor: const Color(0xFF0585A8),
                teclado: TextInputType.number,
                aoDigitar: formatarData,
              ),

              campoTexto(
                controller: descricaoController,
                hint: 'Descrição',
                cor: const Color(0xFF9B9A1F),
                linhas: 4,
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: salvarTransacao,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF743B2B),
                  ),
                  child: const Text(
                    'SALVAR',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget campoTexto({
  TextEditingController? controller,
  required String hint,
  required Color cor,
  int linhas = 1,
  TextInputType teclado = TextInputType.text,
  Function(String)? aoDigitar,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 20),
    child: TextField(
      controller: controller,
      maxLines: linhas,
      keyboardType: teclado,
      onChanged: aoDigitar,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: cor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
      ),
    ),
  );
}