import 'package:flutter/widgets.dart';
import 'package:universal_io/universal_io.dart';

class PlatformSingleActivator extends SingleActivator {
  PlatformSingleActivator(
    super.trigger, {
    bool ctrlOrCmd = false,
    super.shift,
    super.alt,
    super.numLock = LockState.ignored,
    super.includeRepeats = false,
  }) : super(meta: Platform.isMacOS && ctrlOrCmd, control: Platform.isWindows && ctrlOrCmd);
}
