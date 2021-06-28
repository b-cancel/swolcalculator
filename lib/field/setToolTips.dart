//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:bot_toast/bot_toast.dart';
import 'package:swolcalculator/utils/ourToolTip.dart';

//internal

//function
showWeightToolTip(
  BuildContext context, {
  PreferDirection direction: PreferDirection.topCenter,
}) {
  showWidgetToolTip(
    context,
    GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        BotToast.cleanAll();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              "the weight you lifted",
            ),
          ),
          Wrap(
            children: <Widget>[
              Text(
                "(",
              ),
              Text(
                "LBS",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                " or ",
              ),
              Text(
                "KG",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                ")",
              ),
            ],
          ),
        ],
      ),
    ),
    direction: direction,
    seconds: 8,
  );
}

showRepsToolTip(
  BuildContext context, {
  PreferDirection direction: PreferDirection.bottomCenter,
}) {
  showWidgetToolTip(
    context,
    GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        BotToast.cleanAll();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              "how many times you lifted the weight",
            ),
          ),
          Wrap(
            children: <Widget>[
              Text(
                "Successfully",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                " and with ",
              ),
              Text(
                "Good Form",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    direction: direction,
  );
}
