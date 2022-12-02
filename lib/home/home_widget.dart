import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../resources/fonts.dart';
import 'home_background.dart';
import 'widgets/analogue_clock.dart';
import 'widgets/digital_clock.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BackgroundModelBase>(
      builder: (context, model, child) {
        return DigitalClock(
          // padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          // decoration: ShapeDecoration(
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(0),
          //     side: BorderSide(
          //       color: model.getForegroundColor(),
          //       width: 10,
          //     )
          //   ),
          // ),
          style: TextStyle(
            color: model.getForegroundColor(),
            fontSize: 100,
            height: 1.2,
            fontFamily: FontFamilies.product,
          ),
        );
        return AnalogueClock(
          radius: 124,
          color: model.getForegroundColor(),
        );
      },
    );
  }
}
