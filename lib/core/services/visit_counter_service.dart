import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class VisitCounterService extends GetxService {
  static const _namespace = 'mustafa101iq.github.io';
  static const _key = 'portfolio_visits';
  static const _primaryUrl =
      'https://abacus.jasoncameron.dev/hit/$_namespace/$_key';
  static const _fallbackUrl =
      'https://countapi.mileshilliard.com/api/v1/hit/mustafa101iq_github_io_portfolio';

  final RxnInt totalVisits = RxnInt();

  @override
  void onInit() {
    super.onInit();
    if (kIsWeb && _shouldCount) {
      recordVisit();
    }
  }

  bool get _shouldCount {
    final host = Uri.base.host;
    return host == 'mustafa101iq.github.io' ||
        host == 'www.mustafa101iq.github.io';
  }

  Future<void> recordVisit() async {
    final count = await _hit(_primaryUrl) ?? await _hit(_fallbackUrl);
    if (count != null) {
      totalVisits.value = count;
    }
  }

  Future<int?> _hit(String url) async {
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 8));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return null;
      }
      final body = jsonDecode(response.body);
      if (body is Map) {
        final value = body['value'];
        if (value is int) return value;
        if (value is num) return value.toInt();
        if (value is String) return int.tryParse(value);
      }
    } catch (e) {
      debugPrint('VisitCounterService: $e');
    }
    return null;
  }
}
