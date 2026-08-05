import 'dart:js_interop';

import 'package:web/web.dart' as web;

@JS('getPortfolioVisits')
external JSNumber? _getPortfolioVisits();

void bindJsVisitCounter(void Function(int count) onCount) {
  web.window.addEventListener(
    'portfolio-visits',
    (web.Event event) {
      final count = readJsVisitCount();
      if (count != null) onCount(count);
    }.toJS,
  );
}

int? readJsVisitCount() {
  try {
    final value = _getPortfolioVisits();
    if (value == null) return null;
    return value.toDartDouble.round();
  } catch (_) {
    return null;
  }
}
