import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/dhikr.dart';

class ApiService {
  static const _base = 'http://www.hisnmuslim.com/api/ar/husn_ar.json';

  // Browsers block HTTP, so upgrade to HTTPS on web
  static String _safe(String url) =>
      kIsWeb ? url.replaceFirst('http://', 'https://') : url;

  static ApiService? _instance;
  static ApiService get instance => _instance ??= ApiService._();
  ApiService._();

  Future<List<Category>> fetchCategories() async {
    final res = await http.get(Uri.parse(_safe(_base)));
    if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');
    final data = json.decode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    return (data['العربية'] as List)
        .map((e) => Category.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Dhikr>> fetchAthkar(String textUrl) async {
    final res = await http.get(Uri.parse(_safe(textUrl)));
    if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');
    final data = json.decode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    return (data.values.first as List)
        .map((e) => Dhikr.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
