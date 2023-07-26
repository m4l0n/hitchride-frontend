// Programmer's Name: Ang Ru Xian
// Program Name: faq_provider.dart
// Description: This is a file that contains the provider for the FAQ page.
// Last Modified: 22 July 2023

import 'package:hitchride/src/features/driver/data/model/faq_item.dart';
import 'package:hitchride/src/features/driver/data/repository/faq_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final faqRepositoryProvider = Provider<FaqRepository>((ref) {
  return FaqRepository();
});

final faqDataProvider = FutureProvider<List<FaqItem>>((ref) async {
  final repository = ref.watch(faqRepositoryProvider);
  return await repository.loadFaqData();
});