import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:async';

enum ConnectionType {
  //2G
  TYPE_2G,
  //3G
  TYPE_3G,
  //4G
  TYPE_4G,
  //5G
  TYPE_5G,
  //mobile
  TYPE_MOBILE,
  //WIFI
  TYPE_WIFI,
  //none
  TYPE_NONE
}

//connect
class Flutterflappyconnect {
  //channel
  static const MethodChannel _channel = const MethodChannel('flutterflappyconnect');

  //event channel
  static const EventChannel _eventChannel = EventChannel('flutterflappyconnect_event');

  //listeners
  static List<VoidCallback> _networkChangedListeners = [];

  //is listen
  static bool _isListen = false;

  //get connection type
  static Future<ConnectionType> getConnectionType() async {
    final String? version = await _channel.invokeMethod('getConnectionType');
    if (version == "0") {
      return ConnectionType.TYPE_2G;
    }
    if (version == "1") {
      return ConnectionType.TYPE_3G;
    }
    if (version == "2") {
      return ConnectionType.TYPE_4G;
    }
    if (version == "3") {
      return ConnectionType.TYPE_5G;
    }
    if (version == "4") {
      return ConnectionType.TYPE_MOBILE;
    }
    if (version == "5") {
      return ConnectionType.TYPE_WIFI;
    }
    if (version == "6") {
      return ConnectionType.TYPE_NONE;
    }
    return ConnectionType.TYPE_NONE;
  }

  //add change listener
  static void addNetworkChangeListener(VoidCallback callback) {
    if (!_networkChangedListeners.contains(callback)) {
      _networkChangedListeners.add(callback);
    }
    //not start
    if (!_isListen) {
      _isListen = true;
      //add Broadcast
      Stream<String?> stream = _eventChannel.receiveBroadcastStream().map((result) => result as String?);
      //listen
      stream.listen((data) {
        //data
        for (int s = 0; s < _networkChangedListeners.length; s++) {
          _networkChangedListeners[s]();
        }
      });
    }
  }

  //remove
  static void removeNetworkChangeListener(VoidCallback callback) {
    if (_networkChangedListeners.contains(callback)) {
      _networkChangedListeners.remove(callback);
    }
  }

  //remove all
  static void clearNetworkChangeListener(VoidCallback callback) {
    _networkChangedListeners.clear();
  }
}
