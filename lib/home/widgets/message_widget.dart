import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/extensions.dart';
import '../background_model.dart';
import '../home_widget.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<BackgroundModelBase, WidgetModelBase>(
      builder: (context, backgroundModel, model, child) {
        final settings = model.messageSettings;
        return Align(
          alignment: settings.alignment.flutterAlignment,
          child: Padding(
            padding: const EdgeInsets.all(56),
            child: Text(
              settings.message,
              textAlign: settings.alignment.textAlign,
              style: TextStyle(
                color: backgroundModel.getForegroundColor(),
                fontSize: settings.fontSize,
                fontFamily: settings.fontFamily,
                height: 1.4,
                letterSpacing: 0.2,
              ),
            ),
          ),
        );
      },
    );
  }
}
