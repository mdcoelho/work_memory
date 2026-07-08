import 'package:flutter/services.dart';

import '../models.dart';

class QuickEntryService {
  QuickEntryService() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  static const _channel = MethodChannel('work_memory/quick_entry');

  VoidCallback? onQuickEntry;

  Future<bool> register(QuickEntryShortcut shortcut) async {
    try {
      return await _channel.invokeMethod<bool>(
            'registerShortcut',
            shortcut.toPlatformArguments(),
          ) ??
          false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    if (call.method == 'quickEntry') {
      onQuickEntry?.call();
    }
  }
}
