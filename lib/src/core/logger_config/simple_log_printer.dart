// Programmers's Name: Ang Ru Xian
// Program Name: simple_log_printer.dart
// Description: This is a file that configures how the logs are printed.
// Last Modified: 22 July 2023

import 'package:logger/logger.dart';

class SimpleLogPrinter extends LogPrinter {
  
  final String className;
  SimpleLogPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    var color = PrettyPrinter.levelColors[event.level];
    var emoji = PrettyPrinter.levelEmojis[event.level];
    var message = event.message;

    final logOutput =
        '[$emoji] [$className] - $message';

    // Apply color to the log output
    final coloredLogOutput = color != null ? color(logOutput) : logOutput;

   return [coloredLogOutput];
  }
}
