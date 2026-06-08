import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/agendamento.dart';
import '../providers/auth_provider.dart';
import '../providers/agendamento_provider.dart';

class HistoricoScreen extends StatelessWidget {
  const HistoricoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final agendamentoProvider = context.watch<AgendamentoProvider>();
    final proximos = agendamentoProvider.proximos;
    final historico = agendamentoProvider.historico;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Text(
              'Meus Agendamentos',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
          ),
          Expanded(
            child: proximos.isEmpty && historico.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        const Text(
                          'Nenhum agendamento ainda.',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Agende um horario na tela inicial!',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      if (proximos.isNotEmpty) ...[
                        const Text(
                          'Proximos',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...proximos.map((a) => _AgendamentoCard(
                            agendamento: a, mostrarCancelar: true)),
                        const SizedBox(height: 16),
                      ],
                      if (historico.isNotEmpty) ...[
                        const Text(
                          'Historico',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...historico.map((a) => _AgendamentoCard(
                            agendamento: a, mostrarCancelar: false)),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _AgendamentoCard extends StatelessWidget {
  final Agendamento agendamento;
  final bool mostrarCancelar;
  const _AgendamentoCard(
      {required this.agendamento, required this.mostrarCancelar});

  Color get _statusColor {
    switch (agendamento.status) {
      case StatusAgendamento.confirmado:
        return Colors.green;
      case StatusAgendamento.cancelado:
        return Colors.red;
      case StatusAgendamento.concluido:
        return Colors.blue;
    }
  }

  String get _statusTexto {
    switch (agendamento.status) {
      case StatusAgendamento.confirmado:
        return 'Confirmado';
      case StatusAgendamento.cancelado:
        return 'Cancelado';
      case StatusAgendamento.concluido:
        return 'Concluido';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  agendamento.barbeariaNome,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusTexto,
                    style: TextStyle(
                      color: _statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.content_cut,
                    size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(agendamento.servico,
                    style:
                        const TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(width: 12),
                const Icon(Icons.person_outline,
                    size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(agendamento.barbeiro,
                    style:
                        const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${agendamento.data.day}/${agendamento.data.month}/${agendamento.data.year} as ${agendamento.horario}',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
            if (mostrarCancelar &&
                agendamento.status == StatusAgendamento.confirmado) ...[
              const SizedBox(height: 12),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: EdgeInsets.zero,
                ),
                onPressed: () async {
                  final confirmar = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Cancelar agendamento?'),
                      content: const Text(
                          'Tem certeza que deseja cancelar este agendamento?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Nao'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Sim, cancelar',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                  if (confirmar == true && context.mounted) {
                    final auth = context.read<AuthProvider>();
                    await context
                        .read<AgendamentoProvider>()
                        .cancelarAgendamento(
                            agendamento.id, auth.usuario!.id);
                  }
                },
                child: const Text('Cancelar agendamento'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}