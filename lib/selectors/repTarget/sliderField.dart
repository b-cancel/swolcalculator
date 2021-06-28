import 'package:flutter/material.dart';

import 'ourSlider.dart';

class SliderField extends StatelessWidget {
  SliderField({
    this.subtle: false,
    required this.value,
    required this.lastTick,
  });

  final subtle;
  final ValueNotifier<int> value;
  final int lastTick;

  @override
  Widget build(BuildContext context) {
    return CustomSlider(
      value: value,
      lastTick: lastTick,
    );
  }
}
