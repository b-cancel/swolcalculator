import 'package:flutter/material.dart';

import 'package:flutter_xlider/flutter_xlider.dart';

//NOTE: in both cases things start from 1
class CustomSlider extends StatelessWidget {
  const CustomSlider({
    required this.value,
    required this.lastTick,
    this.isDark: true,
    Key? key,
  }) : super(key: key);

  final ValueNotifier<int> value;
  final int lastTick;
  final bool isDark;

  onChange(int handlerIndex, dynamic lowerValue, dynamic upperValue) {
    double val = lowerValue;
    if (val.toInt() != value.value) {
      value.value = val.toInt();
    }
  }

  @override
  Widget build(BuildContext context) {
    Color tickColor = ThemeData.dark().backgroundColor;

    //reusable tick widget
    double tickWidth = 3;
    double sidePadding = 34;

    Widget littleTick = Container(
      height: 8,
      width: tickWidth,
      color: tickColor,
    );

    Widget bigTick = Container(
      height: 16,
      width: tickWidth,
      color: tickColor,
    );

    Widget spacer = Expanded(
      child: Container(),
    );

    //build tick lines
    List<Widget> ticks = [];
    for (int i = 1; i <= lastTick; i++) {
      if (i % 5 == 0)
        ticks.add(bigTick);
      else
        ticks.add(littleTick);

      if (i != lastTick) {
        ticks.add(spacer);
      }
    }

    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            bottom: 40,
            left: sidePadding,
            right: sidePadding,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: ticks,
          ),
        ),
        Container(
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.5),
            child: FlutterSlider(
              //TODO confirm this is correct
              step: FlutterSliderStep(
                step: 1,
                isPercentRange: false,
              ),
              jump: true,
              values: [value.value.toDouble()],
              min: 1,
              max: lastTick.toDouble(),
              handlerWidth: 35,
              handlerHeight: 35,
              touchSize: 50,
              handlerAnimation: FlutterSliderHandlerAnimation(
                scale: 1.25,
              ),
              handler: FlutterSliderHandler(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: Colors.black),
                    color: isDark
                        ? Theme.of(context).accentColor
                        : ThemeData.dark().scaffoldBackgroundColor,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.repeat,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
                foregroundDecoration: BoxDecoration(),
              ),
              tooltip: FlutterSliderTooltip(
                //alwaysShowTooltip: true,
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
                boxStyle: FlutterSliderTooltipBox(
                  decoration: BoxDecoration(
                      //color: Theme.of(context).backgroundColor,
                      ),
                ),
                //TODO: confirm we don't need the line below
                //numberFormat: intl.NumberFormat(),
              ),
              trackBar: FlutterSliderTrackBar(
                activeTrackBarHeight: 16,
                inactiveTrackBarHeight: 16,
                //NOTE: They need their own outline to cover up mid division of background
                inactiveTrackBar: BoxDecoration(
                  color: tickColor,
                  border: Border(
                    top: BorderSide(width: 2, color: Colors.black),
                    bottom: BorderSide(width: 2, color: Colors.black),
                  ),
                ),
                activeTrackBar: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  border: Border(
                    top: BorderSide(width: 2, color: Colors.black),
                    bottom: BorderSide(width: 2, color: Colors.black),
                  ),
                ),
              ),
              //NOTE: hatch marks don't work unfortunately
              onDragging: (handlerIndex, lowerValue, upperValue) {
                onChange(handlerIndex, lowerValue, upperValue);
              },
              //NOTE: primarily so tapping activates the changes
              //tapping the area runs onDragStarted and onDragCompleted
              //but we only really need one
              //and its a nice bonus that
              //when ur dragging and you finish dragging
              //you are made aware with a little vibration
              onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                onChange(handlerIndex, lowerValue, upperValue);
              },
            ),
          ),
        ),
      ],
    );
  }
}
