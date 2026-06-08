import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/agendamento.dart';

class AgendamentoProvider extends ChangeNotifier {
  List<Agendamento> _agendamentos = [];

  List<Agendamento> get agendamentos => _agendamentos;

  List<Agendamento> get proximos => _agendamentos
      .where((a) =>
          a.status == StatusAgendamento.confirmado &&
          a.data.isAfter(DateTime.now()))
      .toList()
    ..sort((a, b) => a.data.compareTo(b.data));

  List<Agendamento> get historico => _agendamentos
      .where((a) =>
          a.status == StatusAgendamento.cancelado ||
          a.status == StatusAgendamento.concluido ||
          a.data.isBefore(DateTime.now()))
      .toList()
    ..sort((a, b) => b.data.compareTo(a.data));

  Future<void> carregarAgendamentos(String usuarioId) async {
    final prefs = await SharedPreferences.getInstance();
    final dados = prefs.getString('agendamentos_$usuarioId') ?? '[]';
    final List<dynamic> lista = jsonDecode(dados);
    _agendamentos = lista.map((e) => Agendamento.fromMap(e)).toList();
    notifyListeners();
  }

  Future<void> adicionarAgendamento(
      Agendamento agendamento, String usuarioId) async {
    _agendamentos.add(agendamento);
    await _salvar(usuarioId);
    notifyListeners();
  }

  Future<void> cancelarAgendamento(String id, String usuarioId) async {
    final index = _agendamentos.indexWhere((a) => a.id == id);
    if (index != -1) {
      final a = _agendamentos[index];
      _agendamentos[index] = Agendamento(
        id: a.id,
        usuarioId: a.usuarioId,
        barbeariaId: a.barbeariaId,
        barbeariaNome: a.barbeariaNome,
        barbeiro: a.barbeiro,
        servico: a.servico,
        data: a.data,
        horario: a.horario,
        status: StatusAgendamento.cancelado,
      );
      await _salvar(usuarioId);
      notifyListeners();
    }
  }

  Future<void> _salvar(String usuarioId) async {
    final prefs = await SharedPreferences.getInstance();
    final lista = _agendamentos.map((e) => e.toMap()).toList();
    await prefs.setString('agendamentos_$usuarioId', jsonEncode(lista));
  }

  void limpar() {
    _agendamentos = [];
    notifyListeners();
  }
}