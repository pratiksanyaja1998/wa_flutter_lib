
import 'package:flutter/foundation.dart';

const kPostRequestHeader = {
  "Accept": "application/json",
  "Content-Type": "application/json",
};

const kGetRequestHeader = {
  "Accept": "application/json",
};

void printMessage(String printMessage){
  if (kDebugMode) {
    print(printMessage);
  }
}