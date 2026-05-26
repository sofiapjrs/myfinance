import 'package:flutter/material.dart';
import 'package:myfinance/database/database_helper.dart';

class MinhasFinancasScreen extends StatefulWidget {
  const MinhasFinancasScreen({super.key});

  @override
  State<MinhasFinancasScreen> createState() => _MinhasFinancasScreenState();
}

class _MinhasFinancasScreenState extends State<MinhasFinancasScreen> {
  
  double despesasMes = 0;
  double receitasMes = 0;
  double saldoAtual = 0;

  List<Map<String, dynamic>> transacoes = [];

  @override
  void dispose() {
    super.dispose();
  }

  double limparValor(String texto) {
    String numeros = texto.replaceAll(RegExp(r'[^0-9]'), '');

    if (numeros.isEmpty) return 0;

    return double.parse(numeros) / 100;
  }

  Future<void> atualizarResumoFinanceiro() async {
    final lista = await DatabaseHelper.instance.listarTransacoes();

    double receitas = 0;
    double despesas = 0;

    for (var transacao in lista) {
      String valorTexto =
          transacao['valor']?.replaceAll(RegExp(r'[^0-9]'), '') ?? '0';

      double valor = double.parse(valorTexto) / 100;

      if (transacao['tipo'] == 'Receita') {
        receitas += valor;
      } else {
        despesas += valor;
      }
    }

    setState(() {
      transacoes = lista;
      receitasMes = receitas;
      despesasMes = despesas;
      saldoAtual = receitas - despesas;
    });
  }

  @override
void initState() {
  super.initState();
  atualizarResumoFinanceiro();
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8C8B8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                    'MINHAS FINANÇAS',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  cardResumo(
                    'SALDO\nATUAL',
                    'R\$ ${saldoAtual.toStringAsFixed(2).replaceAll('.', ',')}',
                  ),

                  cardResumo(
                    'RECEITAS\nDO MÊS',
                    'R\$ ${receitasMes.toStringAsFixed(2).replaceAll('.', ',')}',
                  ),

                  cardResumo(
                    'DESPESAS\nDO MÊS',
                    'R\$ ${despesasMes.toStringAsFixed(2).replaceAll('.', ',')}',
                  ),
                ],
              ),

              const SizedBox(height: 35),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'ÚLTIMAS TRANSAÇÕES',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              for (var transacao in transacoes)
                itemTransacao(
                  transacao['nome'] ?? '',
                  transacao['valor'] ?? '',
                  transacao['tipo'] ?? '',
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget cardResumoEditavel(
  String titulo,
  TextEditingController controller, {
  Function(String)? aoDigitar,
}) {
  return Container(
    width: 85,
    height: 105,
    decoration: BoxDecoration(
      border: Border.all(
        color: const Color(0xFF2B2B2B),
        width: 3,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          titulo,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          width: 75,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            onChanged: aoDigitar,
            decoration: const InputDecoration(
              hintText: 'R\$ 0,00',
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget cardResumo(String titulo, String valor) {
  return Container(
    width: 85,
    height: 105,
    decoration: BoxDecoration(
      border: Border.all(
        color: const Color(0xFF2B2B2B),
        width: 3,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          titulo,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          valor,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13),
        ),
      ],
    ),
  );
}

Widget itemTransacao(String nome, String valor, String tipo,) {
  bool ehReceita = tipo == 'Receita';
  return Padding(
    padding: const EdgeInsets.only(bottom: 22),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          nome,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF743B2B),
          ),
        ),
        Text(
          ehReceita
            ? '+$valor'
            : '-$valor',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: ehReceita
              ? Colors.green
              : Colors.red,
          ),
        ),
      ],
    ),
  );
}