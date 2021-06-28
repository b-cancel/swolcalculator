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
  final ValueNotifier<Map<int, int>> predictionIDTo1RM = new ValueNotifier({});
  final ValueNotifier<int> repTarget = new ValueNotifier<int>(7);
  final ValueNotifier<Map<int, int>> predictionIDToPredictedWeight =
      new ValueNotifier({});

  updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  updatePrediction() {
    //TODO: select the appropiate prediction with prediction ID
  }

  predictAllPossibleFutureWeights() {
    print("new prediction");
    if (predictionIDTo1RM.value.length == 0) {
      predictionIDToPredictedWeight.value = {};
    } else {
      Map<int, int> predictionIDToPredictedWeightLocal = {};
      for (int predictionIndex = 0; predictionIndex <= 7; predictionIndex++) {
        predictionIDToPredictedWeightLocal[predictionIndex] =
            ToWeight.fromRepAnd1Rm(
          repTarget.value,
          predictionIDTo1RM.value[predictionIndex]!.toDouble(),
          predictionIndex,
        ).toInt();
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
      Map<int, int> predictionIDTo1RMlocal = {};
      for (int predictionIndex = 0; predictionIndex <= 7; predictionIndex++) {
        predictionIDTo1RMlocal[predictionIndex] = To1RM.fromWeightAndReps(
          startWeight.value.toDouble(),
          startReps.value,
          predictionIndex,
        ).toInt();
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
    //the above might update the below
    predictionIDToPredictedWeight.addListener(updatePrediction);
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
    //card radius
    Radius arrowRadius = Radius.circular(48);
    Radius cardRadius = Radius.circular(24);

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
                    "Last Set (less than 30 reps)",
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
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                Functions.getMean(
                                  predictionIDTo1RM.value.values.toList(),
                                ).toInt().toString(),
                              ),
                              Text(
                                "give or take " +
                                    Functions.getStandardDeviation(
                                      predictionIDTo1RM.value.values.toList(),
                                    ).toInt().toString(),
                              ),
                            ],
                          ),
                        ),
                        RepTargetSelector(
                          repTarget: repTarget,
                          subtle: false,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                Functions.getMean(
                                  predictionIDToPredictedWeight.value.values
                                      .toList(),
                                ).toInt().toString(),
                              ),
                              Text(
                                "give or take " +
                                    Functions.getStandardDeviation(
                                      predictionIDToPredictedWeight.value.values
                                          .toList(),
                                    ).toInt().toString(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );

    /*
    return ClipRRect(
      //clipping so "hero" doesn't show up in the other page
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: SuggestionChanger(
                      functionID: predictionID,
                      repTarget: repTarget,
                      arrowRadius: arrowRadius,
                      cardRadius: cardRadius,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.only(
                        bottomRight: cardRadius,
                        bottomLeft: cardRadius,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: SetDisplay(
                      useAccent: true,
                      title: "Goal Set",
                      heroUp: widget.heroUp,
                      animate: true,
                      heroAnimTravel: widget.heroAnimTravel,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    */
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
