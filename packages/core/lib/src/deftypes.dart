import 'package:masterloop_core/src/modals/value.dart' show LiveValue;
import 'dart:async';

typedef T ValueGetter<T>();

typedef void VoidCallback();

typedef Future<Stream<LiveValue>> DeviceSubscribeCallback(
  String mid,
  Iterable<int> observations,
  Iterable<int> commands, [
  bool init,
]);

typedef Future<Stream<T>> SubscribeCallback<T>(List<int> ids, [bool init]);

typedef Future<void> UnsubscribeCallback();

typedef Future<void> DeviceUnsubscribeCallback(String mid);

typedef bool Test<T>(T item);
