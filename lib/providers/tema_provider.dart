import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TemaProvider extends ChangeNotifier {
  bool _modoEscuro = false;

  bool get modoEscuro => _modoEscuro;

  TemaProvider() {
    _carregarTema();
  }

  Future<void> _carregarTema() async {
    final prefs = await SharedPreferences.getInstance();
    _modoEscuro = prefs.getBool('modo_escuro') ?? false;
    notifyListeners();
  }

  Future<void> alternarTema() async {
    _modoEscuro = !_modoEscuro;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('modo_escuro', _modoEscuro);
    notifyListeners();
  }
}