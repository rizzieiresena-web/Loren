
import 'package:flutter/material.dart';

void main() {
  runApp(const LorenApp());
}

const verde = Color(0xFF315C50);
const fundo = Color(0xFFF6F7F9);

String dinheiro(double valor) {
  return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
}

class Conta {
  final int id;
  final String nome;
  final String instituicao;
  final String tipo;
  final double saldo;

  const Conta({
    required this.id,
    required this.nome,
    required this.instituicao,
    required this.tipo,
    required this.saldo,
  });

  Conta copyWith({
    String? nome,
    String? instituicao,
    String? tipo,
    double? saldo,
  }) {
    return Conta(
      id: id,
      nome: nome ?? this.nome,
      instituicao: instituicao ?? this.instituicao,
      tipo: tipo ?? this.tipo,
      saldo: saldo ?? this.saldo,
    );
  }
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
        scaffoldBackgroundColor: fundo,
        colorScheme: ColorScheme.fromSeed(
          seedColor: verde,
        ),
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
  int nextId = 1;

  final List<Conta> contas = [];

  double get saldoTotal {
    return contas.fold(0, (total, conta) => total + conta.saldo);
  }

  Future<void> adicionarConta() async {
    final resultado = await showDialog<Conta>(
      context: context,
      builder: (_) => const ContaForm(),
    );

    if (resultado != null) {
      setState(() {
        contas.add(Conta(
          id: nextId++,
          nome: resultado.nome,
          instituicao: resultado.instituicao,
          tipo: resultado.tipo,
          saldo: resultado.saldo,
        ));
      });
    }
  }

  Future<void> editarConta(Conta conta) async {
    final resultado = await showDialog<Conta>(
      context: context,
      builder: (_) => ContaForm(conta: conta),
    );

    if (resultado != null) {
      setState(() {
        final index = contas.indexWhere((c) => c.id == conta.id);
        if (index != -1) {
          contas[index] = resultado;
        }
      });
    }
  }

  Future<void> excluirConta(Conta conta) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir conta?'),
        content: Text(
          'Deseja excluir a conta "${conta.nome}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      setState(() {
        contas.removeWhere((c) => c.id == conta.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final paginas = [
      DashboardPage(
        saldoTotal: saldoTotal,
        quantidadeContas: contas.length,
      ),
      const PlaceholderPage(title: 'Lançamentos'),
      ContasPage(
        contas: contas,
        onAdicionar: adicionarConta,
        onEditar: editarConta,
        onExcluir: excluirConta,
      ),
      const PlaceholderPage(title: 'Metas'),
      const PlaceholderPage(title: 'Perfil'),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: fundo,
        title: const Text(
          'Loren',
          style: TextStyle(
            color: verde,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: paginas[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
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
  final double saldoTotal;
  final int quantidadeContas;

  const DashboardPage({
    super.key,
    required this.saldoTotal,
    required this.quantidadeContas,
  });

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
            color: verde,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Saldo total das contas',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 10),
              Text(
                dinheiro(saldoTotal),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '$quantidadeContas conta(s) cadastrada(s)',
                style: const TextStyle(color: Colors.white70),
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
        const Row(
          children: [
            QuickAction(
              icon: Icons.add_circle_outline,
              label: 'Nova receita',
              color: Color(0xFF32856A),
            ),
            SizedBox(width: 12),
            QuickAction(
              icon: Icons.remove_circle_outline,
              label: 'Nova despesa',
              color: Color(0xFFB65B55),
            ),
            SizedBox(width: 12),
            QuickAction(
              icon: Icons.swap_horiz,
              label: 'Transferir',
              color: Color(0xFF5976A5),
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
        SummaryCard(
          title: 'Saldo das contas',
          value: dinheiro(saldoTotal),
          icon: Icons.account_balance_wallet_outlined,
          color: verde,
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

class ContasPage extends StatelessWidget {
  final List<Conta> contas;
  final VoidCallback onAdicionar;
  final Function(Conta) onEditar;
  final Function(Conta) onExcluir;

  const ContasPage({
    super.key,
    required this.contas,
    required this.onAdicionar,
    required this.onEditar,
    required this.onExcluir,
  });

  @override
  Widget build(BuildContext context) {
    final total = contas.fold<double>(
      0,
      (soma, conta) => soma + conta.saldo,
    );

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Minhas contas',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Cadastre e organize suas contas financeiras.',
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: verde,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Saldo total',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 8),
              Text(
                dinheiro(total),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 29,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${contas.length} conta(s)',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        SizedBox(
          height: 52,
          child: FilledButton.icon(
            onPressed: onAdicionar,
            icon: const Icon(Icons.add),
            label: const Text('Adicionar conta'),
            style: FilledButton.styleFrom(
              backgroundColor: verde,
            ),
          ),
        ),
        const SizedBox(height: 22),
        if (contas.isEmpty)
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.account_balance_outlined,
                  size: 45,
                  color: Colors.black38,
                ),
                SizedBox(height: 12),
                Text(
                  'Nenhuma conta cadastrada.',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Toque em Adicionar conta para começar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          )
        else
          ...contas.map(
            (conta) => ContaCard(
              conta: conta,
              onEditar: () => onEditar(conta),
              onExcluir: () => onExcluir(conta),
            ),
          ),
      ],
    );
  }
}

class ContaCard extends StatelessWidget {
  final Conta conta;
  final VoidCallback onEditar;
  final VoidCallback onExcluir;

  const ContaCard({
    super.key,
    required this.conta,
    required this.onEditar,
    required this.onExcluir,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: verde.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: verde,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  conta.nome,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${conta.instituicao} • ${conta.tipo}',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  dinheiro(conta.saldo),
                  style: const TextStyle(
                    color: verde,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (valor) {
              if (valor == 'editar') onEditar();
              if (valor == 'excluir') onExcluir();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'editar',
                child: Text('Editar'),
              ),
              PopupMenuItem(
                value: 'excluir',
                child: Text('Excluir'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ContaForm extends StatefulWidget {
  final Conta? conta;

  const ContaForm({super.key, this.conta});

  @override
  State<ContaForm> createState() => _ContaFormState();
}

class _ContaFormState extends State<ContaForm> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nomeController;
  late final TextEditingController instituicaoController;
  late final TextEditingController saldoController;

  String tipoSelecionado = 'Corrente';

  final tipos = [
    'Corrente',
    'Poupança',
    'Salário',
    'Dinheiro',
    'Investimento',
    'Outro',
  ];

  @override
  void initState() {
    super.initState();

    final conta = widget.conta;

    nomeController = TextEditingController(
      text: conta?.nome ?? '',
    );

    instituicaoController = TextEditingController(
      text: conta?.instituicao ?? '',
    );

    saldoController = TextEditingController(
      text: conta?.saldo.toStringAsFixed(2).replaceAll('.', ',') ?? '',
    );

    if (conta != null) {
      tipoSelecionado = conta.tipo;
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    instituicaoController.dispose();
    saldoController.dispose();
    super.dispose();
  }

  double converterSaldo(String texto) {
    String valor = texto.trim();

    if (valor.contains(',')) {
      valor = valor.replaceAll('.', '').replaceAll(',', '.');
    }

    return double.parse(valor);
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.conta != null;

    return AlertDialog(
      title: Text(editando ? 'Editar conta' : 'Nova conta'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome da conta',
                  hintText: 'Ex.: Minha conta principal',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Informe o nome da conta.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: instituicaoController,
                decoration: const InputDecoration(
                  labelText: 'Banco ou instituição',
                  hintText: 'Ex.: Nome do banco',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Informe a instituição.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: tipoSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Tipo de conta',
                  border: OutlineInputBorder(),
                ),
                items: tipos.map((tipo) {
                  return DropdownMenuItem(
                    value: tipo,
                    child: Text(tipo),
                  );
                }).toList(),
                onChanged: (valor) {
                  if (valor != null) {
                    setState(() => tipoSelecionado = valor);
                  }
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: saldoController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Saldo inicial (R\$)',
                  hintText: '0,00',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Informe o saldo inicial.';
                  }

                  try {
                    converterSaldo(valor);
                  } catch (_) {
                    return 'Informe um valor válido.';
                  }

                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: verde,
          ),
          onPressed: () {
            if (!formKey.currentState!.validate()) return;

            final conta = widget.conta;

            final resultado = Conta(
              id: conta?.id ?? 0,
              nome: nomeController.text.trim(),
              instituicao: instituicaoController.text.trim(),
              tipo: tipoSelecionado,
              saldo: converterSaldo(saldoController.text),
            );

            Navigator.pop(context, resultado);
          },
          child: Text(editando ? 'Salvar' : 'Cadastrar'),
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
          Expanded(child: Text(title)),
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

  const PlaceholderPage({
    super.key,
    required this.title,
  });

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
