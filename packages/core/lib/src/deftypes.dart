import 'package:masterloop_core/src/models/value.dart' show LiveValue;
import 'dart:async';

//Used as a getter of type T value
typedef T ValueGetter<T>();

//Used as a callback, ex. onEvent, onClick etc..
typedef void VoidCallback();

//Used as callback to init device subscription to live connection, used in DevicesApi, DeviceApi.
typedef Future<Stream<LiveValue>> DeviceSubscribeCallback(
  String mid,
  Iterable<int> observations,
  Iterable<int> commands, [
  bool init,
]);

//Used as callback to unsubscribe device from live connection, used in DevicesApi, DeviceApi.
typedef Future<void> DeviceUnsubscribeCallback(String mid);

//Used as callback init subscription of ids, used in ObservationsBloc.
typedef Future<Stream<T>> SubscribeCallback<T>(List<int> ids, [bool init]);

//Used as callback to dispose subscription.
typedef Future<void> UnsubscribeCallback();

//Used as a Tester of type T, returns true if passed test else false
typedef bool Test<T>(T item);
