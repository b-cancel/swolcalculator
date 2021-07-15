import 'package:flutter/material.dart';
import 'package:swolcalculator/functions/1RM&R=W.dart';
import 'package:swolcalculator/functions/W&R=1RM.dart';

import 'field/weightAndReps.dart';
import 'functions/helper.dart';
import 'selectors/repTarget/repTarget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //start with
  final ValueNotifier<int> startWeight = new ValueNotifier<int>(0);
  final ValueNotifier<int> startReps = new ValueNotifier<int>(0);

  //calculate with
  final ValueNotifier<Map<int, double>> predictionIDTo1RM =
      new ValueNotifier({});
  final ValueNotifier<int> repTarget = new ValueNotifier<int>(7);
  final ValueNotifier<Map<int, double>> predictionIDToPredictedWeight =
      new ValueNotifier({});

  updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  predictAllPossibleFutureWeights() {
    if (predictionIDTo1RM.value.length == 0) {
      predictionIDToPredictedWeight.value = {};
    } else {
      Map<int, double> predictionIDToPredictedWeightLocal = {};
      for (int predictionIndex = 0; predictionIndex <= 7; predictionIndex++) {
        predictionIDToPredictedWeightLocal[predictionIndex] =
            ToWeight.fromRepAnd1Rm(
          repTarget.value,
          predictionIDTo1RM.value[predictionIndex]!,
          predictionIndex,
        );
      }
      predictionIDToPredictedWeight.value = predictionIDToPredictedWeightLocal;
    }

    updateState();
  }

  predictAllPossible1RMs() {
    if (startWeight.value <= 0 ||
        startReps.value <= 0 ||
        startReps.value >= 30) {
      predictionIDTo1RM.value = {};
    } else {
      Map<int, double> predictionIDTo1RMlocal = {};
      for (int predictionIndex = 0; predictionIndex <= 7; predictionIndex++) {
        predictionIDTo1RMlocal[predictionIndex] = To1RM.fromWeightAndReps(
          startWeight.value.toDouble(),
          startReps.value,
          predictionIndex,
        );
      }
      predictionIDTo1RM.value = predictionIDTo1RMlocal;
    }
  }

  @override
  void initState() {
    //init
    super.initState();
    //all predictions
    startWeight.addListener(predictAllPossible1RMs);
    startReps.addListener(predictAllPossible1RMs);
    //the above might update the below
    predictionIDTo1RM.addListener(predictAllPossibleFutureWeights);
    repTarget.addListener(predictAllPossibleFutureWeights);
  }

  @override
  void dispose() {
    //all predictions
    startWeight.removeListener(predictAllPossible1RMs);
    startReps.removeListener(predictAllPossible1RMs);
    //the above might update the below
    predictionIDTo1RM.removeListener(predictAllPossibleFutureWeights);
    repTarget.removeListener(predictAllPossibleFutureWeights);
    //the above might update the below
    predictionIDToPredictedWeight.removeListener(updateState);
    //dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //for middle group 1 rm
    double oneRepWeight = predictionIDTo1RM.value.length != 0
        ? Functions.getMean(
            predictionIDTo1RM.value.values.toList(),
          )
        : 0;
    double oneRepWeightOffBy = predictionIDTo1RM.value.length != 0
        ? Functions.getStandardDeviation(
            predictionIDTo1RM.value.values.toList(),
          )
        : 0;

    //for target weight
    double targetRepWeight = predictionIDToPredictedWeight.value.length != 0
        ? Functions.getMean(
            predictionIDToPredictedWeight.value.values.toList(),
          )
        : 0;
    double targetRepWeightOffBy =
        predictionIDToPredictedWeight.value.length != 0
            ? Functions.getStandardDeviation(
                predictionIDToPredictedWeight.value.values.toList(),
              )
            : 0;

    //build
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "Record Your Last Set (less than 30 reps)",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 8.0,
                    ),
                    child: WeightRepsField(
                      startWeight: startWeight,
                      startReps: startReps,
                    ),
                  ),
                ],
              ),
            ),
            (predictionIDTo1RM.value.length == 0)
                ? Expanded(
                    child: Center(
                      child: WaitingFor(
                        action: "Valid Set",
                      ),
                    ),
                  )
                : Expanded(
                    child: Column(
                      children: [
                        /*
                        ResultsTitleRow(
                          titles: Functions.functions,
                        ),
                        ResultsRow(
                          results: predictionIDTo1RM.value.values.toList(),
                        ),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: RepShower(
                              reps: 1,
                              weight: oneRepWeight.toInt(),
                              offby: oneRepWeightOffBy.toInt(),
                            ),
                          ),
                        ),
                        */
                        RepTargetSelector(
                          repTarget: repTarget,
                          subtle: false,
                        ),
                        ResultsRow(
                          results: predictionIDToPredictedWeight.value.values
                              .toList(),
                        ),
                        ResultsTitleRow(
                          titles: Functions.functions,
                        ),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: RepShower(
                              reps: repTarget.value,
                              weight: targetRepWeight.toInt(),
                              offby: targetRepWeightOffBy.toInt(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class RepShower extends StatelessWidget {
  const RepShower({
    Key? key,
    required this.reps,
    required this.weight,
    required this.offby,
  }) : super(key: key);

  final int reps;
  final int weight;
  final int offby;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            reps.toString(),
            style: TextStyle(
              fontSize: 28,
            ),
          ),
          Visibility(
            visible: reps != 1,
            child: Text(
              " reps of ",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Visibility(
            visible: reps == 1,
            child: Text(
              "RM with ",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Text(
            weight.toString(),
            style: TextStyle(
              fontSize: 28,
            ),
          ),
          Text(
            "+/-",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 8,
            ),
          ),
          Text(
            offby.toString(),
            style: TextStyle(
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class WaitingFor extends StatelessWidget {
  const WaitingFor({
    required this.action,
    Key? key,
  }) : super(key: key);

  final String action;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 4,
          child: Image(
            image: AssetImage("assets/impatient.gif"),
            color: Theme.of(context).accentColor,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 1.75,
          child: Center(
            child: Text(
              "Waiting For A " + action,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ResultsTitleRow extends StatelessWidget {
  const ResultsTitleRow({
    required this.titles,
    Key? key,
  }) : super(key: key);

  final List<String> titles;

  /*
  verticalText(String string) {
    String spacedString = "";
    for (int i = 0; i < (string.length - 1); i++) {
      spacedString += (string[i] + "\n");
    }
    spacedString += (string[string.length - 1]);
    return spacedString;
  }
  */

  spacedText(String string) {
    return string.replaceAll(" ", "\n");
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        return Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Center(
              child: Text(
                spacedText(titles[index]),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class ResultsRow extends StatelessWidget {
  ResultsRow({
    required this.results,
    Key? key,
  }) : super(key: key);

  final List<double> results;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(results.length, (index) {
        return Expanded(
          child: Center(
            child: Column(
              children: [
                Text(
                  results[index].toInt().toString(),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
