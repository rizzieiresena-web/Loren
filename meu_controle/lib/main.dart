import 'package:flutter/material.dart';

void main() {
  runApp(const LorenApp());
}

class LorenApp extends StatelessWidget {
  const LorenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loren',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F7F9),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF315C50),
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
      ),
      home: const LorenHome(),
    );
  }
}

class LorenHome extends StatefulWidget {
  const LorenHome({super.key});

  @override
  State<LorenHome> createState() => _LorenHomeState();
}

class _LorenHomeState extends State<LorenHome> {
  int selectedIndex = 0;

  final List<String> titles = [
    'Início',
    'Lançamentos',
    'Contas',
    'Planejamento',
    'Perfil',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F7F9),
        title: const Text(
          'Loren',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color(0xFF315C50),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: selectedIndex == 0
          ? const DashboardPage()
          : PlaceholderPage(title: titles[selectedIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Lançamentos',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Contas',
          ),
          NavigationDestination(
            icon: Icon(Icons.flag_outlined),
            label: 'Metas',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Bem-vindo ao Loren!',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Seu dinheiro organizado em um só lugar.',
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 24),

        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFF315C50),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Saldo total',
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 10),
              Text(
                'R\$ 0,00',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Seus valores aparecerão aqui.',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),

        const SizedBox(height: 26),

        const Text(
          'Acesso rápido',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),

        Row(
          children: [
            QuickAction(
              icon: Icons.add_circle_outline,
              label: 'Nova receita',
              color: const Color(0xFF315C50),
            ),
            const SizedBox(width: 12),
            QuickAction(
              icon: Icons.remove_circle_outline,
              label: 'Nova despesa',
              color: const Color(0xFFB65B55),
            ),
            const SizedBox(width: 12),
            QuickAction(
              icon: Icons.swap_horiz,
              label: 'Transferir',
              color: const Color(0xFF5976A5),
            ),
          ],
        ),

        const SizedBox(height: 28),

        const Text(
          'Resumo financeiro',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),

        const SummaryCard(
          title: 'Receitas',
          value: 'R\$ 0,00',
          icon: Icons.trending_up,
          color: Color(0xFF32856A),
        ),
        const SizedBox(height: 12),
        const SummaryCard(
          title: 'Despesas',
          value: 'R\$ 0,00',
          icon: Icons.trending_down,
          color: Color(0xFFB65B55),
        ),

        const SizedBox(height: 28),

        const Text(
          'Últimas movimentações',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Column(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 38,
                color: Colors.black38,
              ),
              SizedBox(height: 10),
              Text(
                'Nenhuma movimentação ainda.',
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const QuickAction({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 5,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 27),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
