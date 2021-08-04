import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;

import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:url_launcher/url_launcher.dart';

/// A web implementation of the SmsAdvanced plugin.
class SmsAdvancedPlugin extends PlatformInterface {
  SmsAdvancedPlugin() : super(token: _token);

  static final Object _token = Object();

  static SmsAdvancedPlugin _instance = SmsAdvancedPlugin();

  /// The default instance of [SmsAdvancedPlugin] to use.
  ///
  /// Defaults to [MethodChannelSmsAdvancedPlugin].
  static SmsAdvancedPlugin get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [SmsAdvancedPlugin] when they register themselves.
  static set instance(SmsAdvancedPlugin instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'plugins.elyudde.com/sendSMS',
      const JSONMethodCodec(),
      registrar,
    );

    final pluginInstance = SmsAdvancedPlugin();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'sendSMS':
        return sendSMS(call.arguments['address'].toString(),
            call.arguments['body'].toString());
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'sms_advanced for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  String get separator => isCupertino() ? "&" : "?";
  Future sendSMS(String address, String body) async {
    final _body = Uri.encodeComponent(body);
    return launch('sms:$address${separator}body=$_body');
  }
}

bool isCupertino() {
  final _devices = [
    'iPad Simulator',
    'iPhone Simulator',
    'iPod Simulator',
    'iPad',
    'iPhone',
    'iPod',
    'Mac OS X',
  ];
  final String _agent = html.window.navigator.userAgent;
  for (final device in _devices) {
    if (_agent.contains(device)) {
      return true;
    }
  }
  return false;
}
