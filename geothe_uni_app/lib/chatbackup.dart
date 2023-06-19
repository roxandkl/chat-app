//import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'dart:io';

class ChatLogger {
  final String filePath;

  ChatLogger(this.filePath);

  void createFileIfNotExists() {
    final file = File(filePath);

    if (!file.existsSync()) {
      file.createSync(recursive: true);
      file.writeAsStringSync('Time,Date,Content\n', mode: FileMode.write);
    }
  }

  void log(String content, VoidCallback? onCompleted) {
    createFileIfNotExists();

    final file = File(filePath);

    final currentTime = DateTime.now();
    final formattedTime = currentTime.toIso8601String();
    final formattedDate = currentTime.toLocal().toString().split(' ')[0];
    final csvRow = '"$formattedTime","$formattedDate","$content"\n';

    file.writeAsStringSync(csvRow, mode: FileMode.append);

    onCompleted!();
  }

  Future<List<String>> retrieveChatLog() async {
    final file = File(filePath);
    final exists = await file.exists();

    if (!exists) {
      throw FileSystemException('File not found');
    }

    final lines = await file.readAsLines();
    print(lines);

    return lines;
  }
}


