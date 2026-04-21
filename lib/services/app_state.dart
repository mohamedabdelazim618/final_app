import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category.dart';
import '../services/api_service.dart';

class AppState extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _error;
  Set<int> _favorites = {};

  ThemeMode get themeMode   => _themeMode;
  List<Category> get categories => _categories;
  bool get isLoading        => _isLoading;
  String? get error         => _error;
  Set<int> get favorites    => _favorites;

  AppState() { _loadPrefs(); fetchCategories(); }

  Future<void> _loadPrefs() async {
    final p = await SharedPreferences.getInstance();
    _themeMode = (p.getBool('isDark') ?? false) ? ThemeMode.dark : ThemeMode.light;
    _favorites = (p.getStringList('favorites') ?? []).map(int.parse).toSet();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    final p = await SharedPreferences.getInstance();
    await p.setBool('isDark', _themeMode == ThemeMode.dark);
    notifyListeners();
  }

  Future<void> toggleFavorite(int id) async {
    _favorites.contains(id) ? _favorites.remove(id) : _favorites.add(id);
    final p = await SharedPreferences.getInstance();
    await p.setStringList('favorites', _favorites.map((e) => '$e').toList());
    notifyListeners();
  }

  bool isFavorite(int id) => _favorites.contains(id);

  Future<void> fetchCategories() async {
    _isLoading = true; _error = null; notifyListeners();
    try {
      _categories = await ApiService.instance.fetchCategories();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false; notifyListeners();
    }
  }

  List<Category> get favoriteCategories =>
      _categories.where((c) => _favorites.contains(c.id)).toList();
}
