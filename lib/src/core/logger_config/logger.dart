// Programmer's Name: Ang Ru Xian
// Program Name: logger.dart
// Description: This is a file that contains the logger configuration.
// Last Modified: 22 July 2023

import 'package:logger/logger.dart';

import 'simple_log_printer.dart';

Logger getLogger(String className) {
  return Logger(printer: SimpleLogPrinter(className), level: Level.debug);
}