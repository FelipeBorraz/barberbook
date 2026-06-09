import 'package:flutter/material.dart';

class Barbearia {
  final String id;
  final String nome;
  final String endereco;
  final String telefone;
  final double avaliacao;
  final IconData icone;
  final Color cor;
  final List<String> servicos;
  final List<String> barbeiros;
  final String horarioFuncionamento;

  Barbearia({
    required this.id,
    required this.nome,
    required this.endereco,
    required this.telefone,
    required this.avaliacao,
    required this.icone,
    required this.cor,
    required this.servicos,
    required this.barbeiros,
    required this.horarioFuncionamento,
  });
}

List<Barbearia> barbeariasFixas = [
  Barbearia(
    id: '1',
    nome: 'Barbearia do Zé',
    endereco: 'Rua das Flores, 123',
    telefone: '(83) 99999-1111',
    avaliacao: 4.8,
    icone: Icons.content_cut,
    cor: const Color(0xFF1A237E),
    servicos: ['Corte', 'Barba', 'Corte + Barba', 'Hidratacao'],
    barbeiros: ['Zé', 'Carlos', 'Marcus'],
    horarioFuncionamento: 'Seg-Sab: 8h as 19h',
  ),
  Barbearia(
    id: '2',
    nome: 'Studio Cut',
    endereco: 'Av. Principal, 456',
    telefone: '(83) 99999-2222',
    avaliacao: 4.5,
    icone: Icons.face_retouching_natural,
    cor: const Color(0xFF6A1B9A),
    servicos: ['Corte', 'Barba', 'Sobrancelha', 'Coloracao'],
    barbeiros: ['Pedro', 'Lucas'],
    horarioFuncionamento: 'Seg-Sex: 9h as 20h',
  ),
  Barbearia(
    id: '3',
    nome: 'Navalha de Ouro',
    endereco: 'Rua do Comercio, 789',
    telefone: '(83) 99999-3333',
    avaliacao: 4.9,
    icone: Icons.auto_fix_high,
    cor: const Color(0xFFB71C1C),
    servicos: ['Corte Classico', 'Barba Completa', 'Relaxamento', 'Corte Infantil'],
    barbeiros: ['Rafael', 'Diego', 'Thiago'],
    horarioFuncionamento: 'Ter-Dom: 8h as 18h',
  ),
];