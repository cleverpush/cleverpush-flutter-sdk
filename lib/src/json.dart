import 'dart:convert';

abstract class JSONStringRepresentable {
  String jsonRepresentation();

  String convertToJsonString(Map<String, dynamic>? object) => JsonEncoder
      .withIndent('  ')
      .convert(object)
      .replaceAll("\\n", "\n")
      .replaceAll("\\", "");
}
