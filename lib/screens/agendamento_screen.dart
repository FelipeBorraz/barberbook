import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/barbearia.dart';
import '../models/agendamento.dart';
import '../providers/auth_provider.dart';
import '../providers/agendamento_provider.dart';

class AgendamentoScreen extends StatefulWidget {
  final Barbearia barbearia;
  const AgendamentoScreen({super.key, required this.barbearia});

  @override
  State<AgendamentoScreen> createState() => _AgendamentoScreenState();
}

class _AgendamentoScreenState extends State<AgendamentoScreen> {
  String? _servicoSelecionado;
  String? _barbeiroSelecionado;
  DateTime? _dataSelecionada;
  String? _horarioSelecionado;

  final List<String> _horarios = [
    '08:00', '08:30', '09:00', '09:30', '10:00', '10:30',
    '11:00', '11:30', '13:00', '13:30', '14:00', '14:30',
    '15:00', '15:30', '16:00', '16:30', '17:00', '17:30',
  ];

  Future<void> _selecionarData() async {
    final hoje = DateTime.now();
    final data = await showDatePicker(
      context: context,
      initialDate: hoje,
      firstDate: hoje,
      lastDate: hoje.add(const Duration(days: 30)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF1A237E),
          ),
        ),
        child: child!,
      ),
    );
    if (data != null) setState(() => _dataSelecionada = data);
  }

  Future<void> _confirmarAgendamento() async {
    if (_servicoSelecionado == null ||
        _barbeiroSelecionado == null ||
        _dataSelecionada == null ||
        _horarioSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos para agendar.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final provider = context.read<AgendamentoProvider>();

    final agendamento = Agendamento(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      usuarioId: auth.usuario!.id,
      barbeariaId: widget.barbearia.id,
      barbeariaNome: widget.barbearia.nome,
      barbeiro: _barbeiroSelecionado!,
      servico: _servicoSelecionado!,
      data: _dataSelecionada!,
      horario: _horarioSelecionado!,
      status: StatusAgendamento.confirmado,
    );

    await provider.adicionarAgendamento(agendamento, auth.usuario!.id);

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Agendamento confirmado!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.barbearia.nome}\n$_servicoSelecionado com $_barbeiroSelecionado\n${_dataSelecionada!.day}/${_dataSelecionada!.month}/${_dataSelecionada!.year} as $_horarioSelecionado',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Otimo!'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A237E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.barbearia.nome,
          style: const TextStyle(
            color: Color(0xFF1A237E),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _secao('Escolha o servico'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.barbearia.servicos.map((s) {
                final selecionado = _servicoSelecionado == s;
                return ChoiceChip(
                  label: Text(s),
                  selected: selecionado,
                  onSelected: (_) => setState(() => _servicoSelecionado = s),
                  selectedColor: const Color(0xFF1A237E),
                  labelStyle: TextStyle(
                    color: selecionado ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            _secao('Escolha o barbeiro'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.barbearia.barbeiros.map((b) {
                final selecionado = _barbeiroSelecionado == b;
                return ChoiceChip(
                  label: Text(b),
                  selected: selecionado,
                  onSelected: (_) => setState(() => _barbeiroSelecionado = b),
                  selectedColor: const Color(0xFF1A237E),
                  labelStyle: TextStyle(
                    color: selecionado ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            _secao('Escolha a data'),
            InkWell(
              onTap: _selecionarData,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Color(0xFF1A237E)),
                    const SizedBox(width: 12),
                    Text(
                      _dataSelecionada == null
                          ? 'Selecionar data'
                          : '${_dataSelecionada!.day}/${_dataSelecionada!.month}/${_dataSelecionada!.year}',
                      style: TextStyle(
                        color: _dataSelecionada == null
                            ? Colors.grey
                            : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _secao('Escolha o horario'),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _horarios.length,
              itemBuilder: (context, index) {
                final h = _horarios[index];
                final selecionado = _horarioSelecionado == h;
                return GestureDetector(
                  onTap: () => setState(() => _horarioSelecionado = h),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selecionado
                          ? const Color(0xFF1A237E)
                          : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      h,
                      style: TextStyle(
                        color: selecionado ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _confirmarAgendamento,
              child: const Text(
                'Confirmar Agendamento',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _secao(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        titulo,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A237E),
        ),
      ),
    );
  }
}