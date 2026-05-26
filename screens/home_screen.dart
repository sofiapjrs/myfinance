import 'package:flutter/material.dart';
import 'nova_transacao_screen.dart';
import 'minhas_financas_screen.dart';
import 'analise_gastos_screen.dart';
import 'metas_financeiras_screen.dart';
import 'despesas_fixas_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8C8B8),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Olá, Sofia!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B2B2B),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              botaoMenu(
                texto: 'NOVA TRANSAÇÃO',
                cor: Color(0xFF00B86B),
                aoClicar: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NovaTransacaoScreen(),
                    ),
                  );
                },
              ),

              botaoMenu(
                texto: 'DESPESAS FIXAS',
                cor: Color(0xFF0585A8),
                aoClicar: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DespesasFixasScreen(),
                    ),
                  );
                },
              ),

              botaoMenu(
                texto: 'MINHAS FINANÇAS',
                cor: Color(0xFF9B9A1F),
                aoClicar: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MinhasFinancasScreen(),
                    ),
                  );
                },
              ),

              botaoMenu(
                texto: 'ANÁLISE DE GASTOS',
                cor: Color(0xFF00B86B),
                aoClicar: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AnaliseGastosScreen(),
                    ),
                  );
                },
              ),

              botaoMenu(
                texto: 'METAS FINANCEIRAS',
                cor: const Color(0xFF9B9A1F),
                aoClicar: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MetasFinanceirasScreen(),
                    ),
                  );
                },
              ),    
            ],
          ),
        ),
      ),
    );
  }
}

Widget botaoMenu({
  required String texto,
  required Color cor,
  required VoidCallback aoClicar,
}) {
  return Container(
    width: double.infinity,
    height: 41,
    margin: const EdgeInsets.only(bottom: 25),
    child: ElevatedButton(
      onPressed: aoClicar,
      style: ElevatedButton.styleFrom(
        backgroundColor: cor,
        foregroundColor: Colors.black,
        elevation: 0,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}