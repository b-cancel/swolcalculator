//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swolcalculator/utils/goldenRatio.dart';

import 'customField.dart';
import 'fieldIcon.dart';

//these start off at 0
class WeightRepsField extends StatefulWidget {
  WeightRepsField({
    required this.startWeight,
    required this.startReps,
  });

  final ValueNotifier<int> startWeight;
  final ValueNotifier<int> startReps;

  //weight field
  @override
  _WeightRepsFieldState createState() => _WeightRepsFieldState();
}

class _WeightRepsFieldState extends State<WeightRepsField> {
  final TextEditingController weightController = new TextEditingController();
  final FocusNode weightFocusNode = new FocusNode();
  final TextEditingController repsController = new TextEditingController();
  final FocusNode repsFocusNode = new FocusNode();

  textToNotifierUpdate(
    String text,
    ValueNotifier<int> notifier,
  ) {
    int? newValue = int.tryParse(text);
    if (newValue != null) {
      notifier.value = newValue;
    }
  }

  updateWeightNotifier() {
    textToNotifierUpdate(
      weightController.text,
      widget.startWeight,
    );
  }

  updateRepsNotifier() {
    textToNotifierUpdate(
      repsController.text,
      widget.startReps,
    );
  }

  @override
  void initState() {
    super.initState();
    weightController.addListener(updateWeightNotifier);
    repsController.addListener(updateRepsNotifier);
  }

  @override
  void dispose() {
    weightController.removeListener(updateWeightNotifier);
    repsController.removeListener(updateRepsNotifier);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = 48;
    double borderSize = 3;

    //build
    return Container(
      height: (iconSize * 2) + 8,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RecordField(
            focusNode: weightFocusNode,
            controller: weightController,
            isLeft: true,
            borderSize: borderSize,
            otherController: repsController,
          ),
          Column(
            children: <Widget>[
              TappableIcon(
                focusNode: weightFocusNode,
                iconSize: iconSize,
                borderSize: borderSize,
                icon: Padding(
                  padding: EdgeInsets.only(
                    right: 8,
                  ),
                  child: Icon(
                    FontAwesomeIcons.dumbbell,
                  ),
                ),
                isLeft: true,
              ),
              TappableIcon(
                focusNode: repsFocusNode,
                iconSize: iconSize,
                borderSize: borderSize,
                icon: Icon(Icons.repeat),
                isLeft: false,
              ),
            ],
          ),
          RecordField(
            focusNode: repsFocusNode,
            controller: repsController,
            isLeft: false,
            borderSize: borderSize,
            otherController: weightController,
          ),
        ],
      ),
    );
  }
}
