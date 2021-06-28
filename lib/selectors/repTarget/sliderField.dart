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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: subtle ? 24 : 16,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: subtle ? 8 : 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: (subtle ? 8 : 12),
                  ),
                  child: Container(
                    color: Colors.black, //line color
                    height: 2,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ],
            ),
          ),
        ),
        CustomSlider(
          value: value,
          lastTick: lastTick,
        ),
      ],
    );
  }
}
