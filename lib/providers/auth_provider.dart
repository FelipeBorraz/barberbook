import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario.dart';

class AuthProvider extends ChangeNotifier {
  Usuario? _usuario;
  bool _carregando = false;

  Usuario? get usuario => _usuario;
  bool get carregando => _carregando;
  bool get estaLogado => _usuario != null;

  Future<void> carregarUsuarioSalvo() async {
    final prefs = await SharedPreferences.getInstance();
    final dadosString = prefs.getString('usuario');
    if (dadosString != null) {
      final mapa = jsonDecode(dadosString);
      _usuario = Usuario.fromMap(mapa);
      notifyListeners();
    }
  }

  Future<bool> cadastrar({
    required String nome,
    required String email,
    required String senha,
    required String telefone,
  }) async {
    _carregando = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    final prefs = await SharedPreferences.getInstance();
    final usuariosString = prefs.getString('usuarios') ?? '[]';
    final List<dynamic> usuarios = jsonDecode(usuariosString);

    final jaExiste = usuarios.any((u) => u['email'] == email);
    if (jaExiste) {
      _carregando = false;
      notifyListeners();
      return false;
    }

    final novoUsuario = Usuario(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nome: nome,
      email: email,
      telefone: telefone,
    );

    usuarios.add({...novoUsuario.toMap(), 'senha': senha});
    await prefs.setString('usuarios', jsonEncode(usuarios));

    _usuario = novoUsuario;
    await prefs.setString('usuario', jsonEncode(novoUsuario.toMap()));

    _carregando = false;
    notifyListeners();
    return true;
  }

  Future<bool> login({
    required String email,
    required String senha,
  }) async {
    _carregando = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    final prefs = await SharedPreferences.getInstance();
    final usuariosString = prefs.getString('usuarios') ?? '[]';
    final List<dynamic> usuarios = jsonDecode(usuariosString);

    final dadosUsuario = usuarios.firstWhere(
      (u) => u['email'] == email && u['senha'] == senha,
      orElse: () => null,
    );

    if (dadosUsuario == null) {
      _carregando = false;
      notifyListeners();
      return false;
    }

    _usuario = Usuario.fromMap(dadosUsuario);
    await prefs.setString('usuario', jsonEncode(_usuario!.toMap()));

    _carregando = false;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuario');
    _usuario = null;
    notifyListeners();
  }

  Future<bool> atualizarPerfil({
    required String nome,
    required String telefone,
  }) async {
    if (_usuario == null) return false;

    _carregando = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    final prefs = await SharedPreferences.getInstance();
    final usuariosString = prefs.getString('usuarios') ?? '[]';
    final List<dynamic> usuarios = jsonDecode(usuariosString);

    final index = usuarios.indexWhere((u) => u['id'] == _usuario!.id);
    if (index != -1) {
      usuarios[index]['nome'] = nome;
      usuarios[index]['telefone'] = telefone;
      await prefs.setString('usuarios', jsonEncode(usuarios));
    }

    _usuario = Usuario(
      id: _usuario!.id,
      nome: nome,
      email: _usuario!.email,
      telefone: telefone,
    );
    await prefs.setString('usuario', jsonEncode(_usuario!.toMap()));

    _carregando = false;
    notifyListeners();
    return true;
  }
}