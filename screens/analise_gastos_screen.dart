import 'package:flutter/material.dart';
import 'package:myfinance/database/database_helper.dart';
import 'package:fl_chart/fl_chart.dart';

class AnaliseGastosScreen extends StatefulWidget {
  const AnaliseGastosScreen({super.key});

  @override
  State<AnaliseGastosScreen> createState() => _AnaliseGastosScreenState();
}

class _AnaliseGastosScreenState extends State<AnaliseGastosScreen> {
  Map<String, double> gastosPorCategoria = {};

  DateTime? dataInicio;
  DateTime? dataFim;

  @override
  void initState() {
    super.initState();
    calcularGastos();
  }

  Future<void> calcularGastos() async {
    gastosPorCategoria.clear();

    final transacoes =
        await DatabaseHelper.instance.listarTransacoes();

    for (var transacao in transacoes) {
      if (transacao['tipo'] == 'Despesa') {
        DateTime? dataTransacao =
            converterData(transacao['data'] ?? '');

        if (dataInicio != null && dataFim != null) {
          if (dataTransacao == null ||
              dataTransacao.isBefore(dataInicio!) ||
              dataTransacao.isAfter(dataFim!)) {
            continue;
          }
        }

        String categoria = transacao['categoria'] ?? 'Outros';
        String valorTexto = transacao['valor'] ?? '0';

        String numeros =
            valorTexto.replaceAll(RegExp(r'[^0-9]'), '');

        if (numeros.isNotEmpty) {
          double valor = double.parse(numeros) / 100;

          if (gastosPorCategoria.containsKey(categoria)) {
            gastosPorCategoria[categoria] =
                gastosPorCategoria[categoria]! + valor;
          } else {
            gastosPorCategoria[categoria] = valor;
          }
        }
      }
    }

    setState(() {});
  }

  DateTime? converterData(String data) {
    try {
      List<String> partes = data.split('/');

      int dia = int.parse(partes[0]);
      int mes = int.parse(partes[1]);
      int ano = int.parse(partes[2]);

      return DateTime(ano, mes, dia);
    } catch (e) {
      return null;
    }
  }

  Future<void> escolherPeriodo() async {
    DateTimeRange? periodo = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: dataInicio != null && dataFim != null
          ? DateTimeRange(start: dataInicio!, end: dataFim!)
          : null,
    );

    if (periodo != null) {
      setState(() {
        dataInicio = periodo.start;
        dataFim = periodo.end;
        calcularGastos();
      });
    }
  }

  double calcularTotal() {
    double total = 0;

    for (var valor in gastosPorCategoria.values) {
      total += valor;
    }

    return total;
  }

  String calcularPorcentagem(double valorCategoria) {
    double total = calcularTotal();

    if (total == 0) return '0%';

    double porcentagem = (valorCategoria / total) * 100;

    return '${porcentagem.toStringAsFixed(0)}%';
  }

  List<PieChartSectionData> gerarSecoesGrafico() {
    final List<Color> cores = [
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.brown,
    ];

    int index = 0;

    return gastosPorCategoria.entries.map((entry) {
      final valor = entry.value;
      final porcentagem = calcularPorcentagem(valor);

      final secao = PieChartSectionData(
        color: cores[index % cores.length],
        value: valor,
        title: porcentagem,
        radius: 90,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );

      index++;

      return secao;
    }).toList();
  }

  String formatarData(DateTime data) {
    return '${data.day}/${data.month}/${data.year}';
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
                    'ANÁLISE DE GASTOS',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              SizedBox(
                height: 220,
                child: gastosPorCategoria.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma despesa cadastrada.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : PieChart(
                        PieChartData(
                          sections: gerarSecoesGrafico(),
                          centerSpaceRadius: 35,
                          sectionsSpace: 3,
                        ),
                      ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: escolherPeriodo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF743B2B),
                  ),
                  child: const Text(
                    'ESCOLHER PERÍODO',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              if (dataInicio != null && dataFim != null)
                Text(
                  '${formatarData(dataInicio!)} até ${formatarData(dataFim!)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

              const SizedBox(height: 30),

              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CATEGORIA',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'VALOR GASTO',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'PORCENTAGEM',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Expanded(
                child: gastosPorCategoria.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhum gasto nesse período.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView(
                        children: [
                          for (var categoria in gastosPorCategoria.keys)
                            itemGasto(
                              categoria,
                              'R\$ ${gastosPorCategoria[categoria]!.toStringAsFixed(2).replaceAll('.', ',')}',
                              calcularPorcentagem(
                                gastosPorCategoria[categoria]!,
                              ),
                            ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget itemGasto(String categoria, String valor, String porcentagem) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            categoria,
            style: const TextStyle(
              color: Color(0xFF743B2B),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            valor,
            style: const TextStyle(
              color: Color(0xFF743B2B),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            porcentagem,
            style: const TextStyle(
              color: Color(0xFF743B2B),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}