// Programmer's Name: Ang Ru Xian
// Program Name: faq_repository.dart
// Description: This is a file that contains the repository for the FAQ page.
// Last Modified: 22 July 2023

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hitchride/src/features/driver/data/model/faq_item.dart';

class FaqRepository {
  Future<List<FaqItem>> loadFaqData() async {
    String jsonString = await rootBundle.loadString('assets/json/faq.json');
    List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((json) => FaqItem.fromJson(json)).toList();
  }
}