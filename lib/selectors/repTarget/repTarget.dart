//flutter
import 'package:flutter/material.dart';
import 'sliderField.dart';

//NOTE: this widget should not dispose its passed rep target
class RepTargetSelector extends StatefulWidget {
  RepTargetSelector({
    required this.repTarget,
    required this.subtle,
    this.darkTheme: true,
  });

  final ValueNotifier<int> repTarget;
  final bool subtle;
  final bool darkTheme;

  @override
  _RepTargetSelectorState createState() => _RepTargetSelectorState();
}

class _RepTargetSelectorState extends State<RepTargetSelector> {
  late ValueNotifier<Duration> repTargetDuration;

  repTargetUpdate() {
    //update duration that is used by tick slider
    repTargetDuration.value = Duration(
      seconds: widget.repTarget.value * 5,
    );
  }

  @override
  void initState() {
    //create notifier
    repTargetDuration = new ValueNotifier<Duration>(Duration.zero);

    //set its value given rep target
    repTargetUpdate();

    //listen to value changes so both notifiers stay synced
    widget.repTarget.addListener(repTargetUpdate);

    //super init
    super.initState();
  }

  @override
  void dispose() {
    widget.repTarget.removeListener(repTargetUpdate);
    //DO NOT DISPOSE REP TARGET since it was passed

    //super dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliderField(
      lastTick: 29,
      subtle: widget.subtle,
      value: widget.repTarget,
    );
  }
}
