class Agendamento {
  final String id;
  final String usuarioId;
  final String barbeariaId;
  final String barbeariaNome;
  final String barbeiro;
  final String servico;
  final DateTime data;
  final String horario;
  final StatusAgendamento status;

  Agendamento({
    required this.id,
    required this.usuarioId,
    required this.barbeariaId,
    required this.barbeariaNome,
    required this.barbeiro,
    required this.servico,
    required this.data,
    required this.horario,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'barbeariaId': barbeariaId,
      'barbeariaNome': barbeariaNome,
      'barbeiro': barbeiro,
      'servico': servico,
      'data': data.toIso8601String(),
      'horario': horario,
      'status': status.name,
    };
  }

  factory Agendamento.fromMap(Map<String, dynamic> map) {
    return Agendamento(
      id: map['id'] ?? '',
      usuarioId: map['usuarioId'] ?? '',
      barbeariaId: map['barbeariaId'] ?? '',
      barbeariaNome: map['barbeariaNome'] ?? '',
      barbeiro: map['barbeiro'] ?? '',
      servico: map['servico'] ?? '',
      data: DateTime.parse(map['data']),
      horario: map['horario'] ?? '',
      status: StatusAgendamento.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => StatusAgendamento.confirmado,
      ),
    );
  }
}

enum StatusAgendamento { confirmado, cancelado, concluido }