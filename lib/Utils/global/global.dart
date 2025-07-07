import 'package:flutter/foundation.dart';

void printLog(dynamic data) {
  if (!kReleaseMode)  printLog(data.toString());
}
