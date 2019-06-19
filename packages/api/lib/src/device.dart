import 'dart:async';
import 'package:dio/dio.dart';
import 'package:masterloop_api/src/devices.dart';
import 'package:masterloop_api/src/device_history.dart';
import 'package:masterloop_core/masterloop_core.dart'
    show
        Device,
        Template,
        LiveValue,
        ObservationValue,
        DeviceUnsubscribeCallback,
        DeviceSubscribeCallback,
        Api;

class DeviceApi implements Api {
  final String basePath;
  final Dio _client;
  final String mid;

  DeviceSubscribeCallback _subscribe;
  DeviceUnsubscribeCallback _unsubscribe;

  Future<Device> get details => _client
      .get("$basePath/details")
      .then((response) => Device.fromJson(response.data));

  Future<Device> get secureDetails => _client
      .get("$basePath/securedetails")
      .then((response) => Device.fromJson(response.data));

  Future<Template> get template => _client
      .get("$basePath/template")
      .then((response) => Template.fromJson(response.data));

  Future<Iterable<ObservationValue>> get current =>
      _client.get("$basePath/observations/current2").then(
            (response) => List<ObservationValue>.unmodifiable(
                  response.data.map((v) => ObservationValue.fromJson(v)),
                ),
          );

  DeviceHistoryApi get history => DeviceHistoryApi(
        client: _client,
        mid: mid,
      );

  DeviceApi({
    Dio client,
    this.mid,
    DeviceSubscribeCallback subscribe,
    DeviceUnsubscribeCallback unsubscribe,
  })  : assert(client != null),
        assert(mid != null),
        assert(subscribe != null),
        assert(unsubscribe != null),
        _client = client,
        _subscribe = subscribe,
        _unsubscribe = unsubscribe,
        basePath = "${DevicesApi.basePath}/$mid";

  Future<bool> sendCommand({
    int id,
    Iterable<Map<String, dynamic>> arguments,
    Duration expiresIn,
  }) =>
      _client.post(
        "$basePath/commands/$id",
        data: {
          "Id": id,
          "Arguments": arguments,
          "Timestamp": DateTime.now().toUtc().toIso8601String(),
          "ExpiresAt": DateTime.now()
              .add(expiresIn ?? const Duration(minutes: 5))
              .toUtc()
              .toIso8601String(),
        },
      ).then((_) => true);

  Future<Stream<LiveValue>> subscribe({
    Iterable<int> observations,
    Iterable<int> commands = const [],
    bool init = true,
  }) =>
      _subscribe(mid, observations, commands, init);

  Future<void> unsubscribe() => _unsubscribe(mid);
}
