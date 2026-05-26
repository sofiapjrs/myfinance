import 'package:flutter/material.dart';
import 'package:myfinance/database/database_helper.dart';

class NovaDespesaScreen extends StatefulWidget {
  final Map<String, String>? despesa;
  final int? index;

  const NovaDespesaScreen({
    super.key,
    this.despesa,
    this.index,
  });

  @override
  State<NovaDespesaScreen> createState() => _NovaDespesaScreenState();
}

class _NovaDespesaScreenState extends State<NovaDespesaScreen> {
  final nomeController = TextEditingController();
  final valorController = TextEditingController();
  final dataController = TextEditingController();

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

  @override
  void initState() {
    super.initState();

    if (widget.despesa != null) {
      nomeController.text = widget.despesa!['nome'] ?? '';
      valorController.text = widget.despesa!['valor'] ?? '';
      dataController.text = widget.despesa!['data'] ?? '';
      categoriaSelecionada = widget.despesa!['categoria'];
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    valorController.dispose();
    dataController.dispose();
    super.dispose();
  }

  void formataValor (String texto) {
    String numeros = texto.replaceAll(RegExp(r'[^0-9]'), '');

    if (numeros.isEmpty) {
      valorController.clear();
      return;
    }

    double valor = double.parse(numeros) / 100;

    String textoFormatado = valor
      .toStringAsFixed(2)
      .replaceAll('.', ',');

    textoFormatado = 'R\$ $textoFormatado';

    valorController.value = TextEditingValue(
      text: textoFormatado,
      selection: TextSelection.collapsed(
        offset: textoFormatado.length),
    );
  }

  void formataData (String texto) {
    String numeros = texto.replaceAll(RegExp(r'[^0-9]'), '');

    if (numeros.length == 4) {
      String dataFormatada = '${numeros.substring(0, 2)}/${numeros.substring(2, 4)}/2026';

      dataController.value = TextEditingValue(
        text: dataFormatada,
        selection: TextSelection.collapsed(offset: dataFormatada.length),
      );
    }
  }

    void salvarDespesa() async {
      final novaDespesa = {
        'nome': nomeController.text,
        'valor': valorController.text,
        'categoria': categoriaSelecionada ?? 'Sem categoria',
        'data': dataController.text,
      };

      if (widget.index != null && widget.despesa?['id'] != null) {
        await DatabaseHelper.instance.atualizarDespesa(
          int.parse(widget.despesa!['id']!),
          novaDespesa,
        );
      } else {
        await DatabaseHelper.instance.inserirDespesa(novaDespesa);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Despesa salva com sucesso!'),
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
                    'NOVA DESPESA',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              campoTexto(
                controller: nomeController,
                hint: 'Nome da despesa', 
                cor: const Color(0xFF00B86B),
              ),

              campoTexto(
                controller: valorController,
                hint: 'Valor', 
                cor: const Color(0xFF0585A8),
                teclado: TextInputType.number,
                aoDigitar: formataValor,
              ),

              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: DropdownButtonFormField<String>(
                  value: categoriaSelecionada,
                  decoration: InputDecoration(
                    hintText: 'Categoria',
                    filled: true,
                    fillColor: const Color(0xFF9B9A1F),
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
                cor: const Color(0xFF22BF66),
                teclado: TextInputType.number,
                aoDigitar: formataData,
              ),
              
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: salvarDespesa,
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


