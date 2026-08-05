import 'package:get/get.dart';

String localizedText(dynamic value, {String fallback = ''}) {
  if (value == null) return fallback;
  if (value is String) return value;
  if (value is Map) {
    final code = Get.locale?.languageCode ?? 'en';
    final map = value.map((key, item) => MapEntry(key.toString(), item));
    final selected = map[code] ?? map['en'] ?? map['ar'];
    if (selected is String) return selected;
  }
  return fallback;
}

List<String> localizedStringList(dynamic value) {
  if (value is! List) return const [];
  return value.map((item) => localizedText(item)).toList();
}
