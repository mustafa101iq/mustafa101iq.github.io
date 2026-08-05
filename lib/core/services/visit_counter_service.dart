import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:portfolio_website/core/services/visit_counter_bridge.dart';

class VisitCounterService extends GetxService {
  static const _hitUrl =
      'https://countapi.mileshilliard.com/api/v1/hit/mustafa101iq_github_io_portfolio';
  static const _getUrl =
      'https://countapi.mileshilliard.com/api/v1/get/mustafa101iq_github_io_portfolio';
  static const _abacusHitUrl =
      'https://abacus.jasoncameron.dev/hit/mustafa101iq_github_io/portfolio_visits';

  final RxnInt totalVisits = RxnInt();

  @override
  void onInit() {
    super.onInit();
    if (!kIsWeb) return;
    bindJsVisitCounter(_applyCount);
    unawaited(_bootstrap());
  }

  Future<void> _bootstrap() async {
    final fromJs = readJsVisitCount();
    if (fromJs != null) {
      _applyCount(fromJs);
      return;
    }

    for (var i = 0; i < 16; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      final count = readJsVisitCount();
      if (count != null) {
        _applyCount(count);
        return;
      }
    }

    final count = await _hit(_hitUrl) ??
        await _hit(_abacusHitUrl) ??
        await _hit(_getUrl);
    if (count != null) {
      _applyCount(count);
    }
  }

  void _applyCount(int count) {
    if (count < 0) return;
    if (totalVisits.value == count) return;
    totalVisits.value = count;
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
      if (body is! Map) return null;
      final value = body['value'];
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value);
    } catch (e) {
      debugPrint('VisitCounterService: $e');
    }
    return null;
  }
}
