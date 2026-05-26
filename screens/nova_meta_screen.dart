import 'package:flutter/material.dart';
import 'package:myfinance/database/database_helper.dart';

class NovaMetaScreen extends StatefulWidget {
  final Map<String, String>? meta;
  final int? index;

  const NovaMetaScreen({
    super.key,
    this.meta,
    this.index,
  });

  @override
  State<NovaMetaScreen> createState() => _NovaMetaScreenState();
}

class _NovaMetaScreenState extends State<NovaMetaScreen> {
  final nomeController = TextEditingController();
  final valorObjetivoController = TextEditingController();
  final valorGuardadoController = TextEditingController();
  final dataController = TextEditingController();
  double porcentagem = 0;

  @override
  void initState() {
    super.initState();

    if (widget.meta != null) {
      nomeController.text = widget.meta!['nome'] ?? '';
      valorObjetivoController.text = widget.meta!['objetivo'] ?? '';
      valorGuardadoController.text = widget.meta!['guardado'] ?? '';
      dataController.text = widget.meta!['data'] ?? '';
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    valorObjetivoController.dispose();
    valorGuardadoController.dispose();
    dataController.dispose();
    super.dispose();
  }

  void formataValor (String texto, TextEditingController controller) {
    String numeros = texto.replaceAll(RegExp(r'[^0-9]'), '');

    if (numeros.isEmpty) {
      controller.clear();
      return;
    }

    double valor = double.parse(numeros) / 100;

    String textoFormatado = valor
      .toStringAsFixed(2)
      .replaceAll('.', ',');

    textoFormatado = 'R\$ $textoFormatado';

    controller.value = TextEditingValue(
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

  double limparValor(String texto) {
  String numeros = texto.replaceAll(RegExp(r'[^0-9]'), '');

  if (numeros.isEmpty) return 0;

  return double.parse(numeros) / 100;
}

void calcularPorcentagem() {
  double objetivo = limparValor(valorObjetivoController.text);
  double guardado = limparValor(valorGuardadoController.text);

  setState(() {
    if (objetivo > 0) {
      porcentagem = (guardado / objetivo) * 100;
    } else {
      porcentagem = 0;
    }
  });
}


void salvarMeta() async {
  final novaMeta = {
    'nome': nomeController.text,
    'objetivo': valorObjetivoController.text,
    'guardado': valorGuardadoController.text,
    'data': dataController.text,
  };

  if (widget.index != null && widget.meta?['id'] != null) {
    await DatabaseHelper.instance.atualizarMeta(
      int.parse(widget.meta!['id']!),
      novaMeta,
    );
  } else {
    await DatabaseHelper.instance.inserirMeta(novaMeta);
  }

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Meta salva com sucesso!'),
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
                    'NOVA META',
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
                hint: 'Nome da meta', 
                cor: const Color(0xFF00B86B),
              ),

              campoTexto(
                controller: valorObjetivoController,
                hint: 'Valor Obejetivo', 
                cor: const Color(0xFF0585A8),
                teclado: TextInputType.number,
                aoDigitar: (texto) {
                  formataValor(texto, valorObjetivoController);
                  calcularPorcentagem();
                  },
              ),      

              campoTexto(
                controller: valorGuardadoController,
                hint: 'Valor já guardado', 
                cor: const Color(0xFF9B9A1F),
                teclado: TextInputType.number,
                aoDigitar: (texto) {
                  formataValor(texto, valorGuardadoController);
                  calcularPorcentagem();
                },
              ),  

              campoTexto(
                controller: dataController,
                hint: 'Prazo final', 
                cor: const Color(0xFF22BF66),
                teclado: TextInputType.number,
                aoDigitar: formataData,
              ),
              
              Text(
                '${porcentagem.toStringAsFixed(0)}%',
                style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: salvarMeta,
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


