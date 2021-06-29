import 'dart:math' as math;

import 'W&R=1RM.dart';

class Functions {
  static List<String> functions = [
    "Brzycki", // 0
    "McGlothin (or Landers)", // 1
    "Almazan (our own)", // 2
    "Epley (or Baechle)", // 3
    "O'Conner", // 4
    "Wathan", // 5
    "Mayhew", // 6
    "Lombardi", // 7
  ];

  static Map<String, int> functionToIndex = {
    functions[0]: 0,
    functions[1]: 1,
    functions[2]: 2,
    functions[3]: 3,
    functions[4]: 4,
    functions[5]: 5,
    functions[6]: 6,
    functions[7]: 7,
  };

  static List<int> functionIndices = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
  ];

  //r: must not be 37 (for sure)
  //r: must not be anything above 37 (logically)
  static bool brzyckiUsefull(int reps) => (reps < 37);

  //r: must not be 37.9226049423 (technically)
  //r: must not be anything above 37.9226049423 (logically)
  //r: and logically you can assume the number is 38
  //    1. because we are only ever going to be passed int reps
  //    2. and because 37 actually does work here whereas 38 does not
  static bool mcGlothinOrLandersUsefull(int reps) => (reps < 38);

  //r: must not be 104.34355 (technically)
  //r: must not anything above 104.34355 (logically)
  //r: and logically youc an assume the number is 105
  //    1. because we are only ever going to be passed int reps
  //    2. and because 104 does work here whereas 105 does not
  static bool almazanUsefull(int reps) => (reps < 105);

  //based on average order of functions
  static const int defaultFunctionID = 3;

  static double getMean(List values) {
    double sum = 0;
    for (int i = 0; i < values.length; i++) {
      sum += values[i];
    }
    return sum / values.length;
  }

  static double getStandardDeviation(List values, {double? mean}) {
    if (mean == null) {
      mean = getMean(values);
    }

    double massiveSum = 0;
    for (int i = 0; i < values.length; i++) {
      double val = values[i] - mean;
      massiveSum += (val * val);
    }

    return math.sqrt(massiveSum / values.length);
  }
}
