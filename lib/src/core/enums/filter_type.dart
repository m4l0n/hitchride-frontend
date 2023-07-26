// Programmer's Name: Ang Ru Xian
// Program Name: filter_type.dart
// Description: This is a file that contains the filter type enum.
// Last Modified: 22 July 2023

import 'package:hooks_riverpod/hooks_riverpod.dart';

enum FilterType {
  latest,
  highestRated,
  forYou,
  byYou
}

final filterProvider = StateProvider((ref) => FilterType.latest);