import 'package:flutter/material.dart';

InputDecoration decoration(String Label) {
  return InputDecoration(
      labelText: Label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)));
}

String? requiredValidator(String? value, String fieldName) {
  if (value == null || value.isEmpty) {
    return 'Por favor insira $fieldName';
  }
  return null;
}
