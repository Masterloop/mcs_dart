import 'package:dio/dio.dart';
import 'package:masterloop_core_api/core_api.dart';
import 'package:masterloop_api/src/utils/live_device.dart';
import 'package:masterloop_api/src/device.dart';
import 'package:masterloop_core/core.dart' show Device, LiveValue;
import 'package:masterloop_api/src/utils/rabbit_mq_connection.dart';
import 'dart:async';

class DevicesApi implements Api {
  static final String basePath = "/api/devices";

  final Map<String, LiveDevice> _liveDevicesMap = {};
  final Dio _client;

  RabbitMQConnection _rabbitMQ;

  DevicesApi({
    Dio client,
  })  : assert(client != null),
        _client = client;

  DeviceApi operator [](String mid) => DeviceApi(
        mid: mid,
        client: _client,
        subscribe: _subscribeDevice,
        unsubscribe: _unsubscribeDevice,
      );

  Future<Iterable<Device>> all({bool metadata = false, bool details = false}) =>
      _client
          .get("$basePath?includeMetadata=$metadata&includeDetails=$details")
          .then(
            (response) => List<Device>.unmodifiable(
                  response.data.map(
                    (d) => Device.fromJson(d),
                  ),
                ),
          )
          .catchError((_) => null);

  Future<Stream<LiveValue>> _subscribeDevice(
    String mid,
    Iterable<int> observations,
    Iterable<int> commands, [
    bool init = true,
  ]) {
    assert(mid != null);
    final liveDevice = LiveDevice(
      mid: mid,
      observations: observations,
      commands: commands ?? const [],
      init: init,
    );

    if (liveDevice.isEmpty) {
      _liveDevicesMap.remove(mid);
    } else {
      _liveDevicesMap[mid] = liveDevice;
    }

    if (_liveDevicesMap.isEmpty) {
      return Future.value(liveDevice.stream);
    } else {
      return _subscribe(devices: _liveDevicesMap.values.toList())
          .then((_) => liveDevice.stream);
    }
  }

  Future<void> _unsubscribeDevice(String mid) {
    assert(mid != null);

    final liveDevice = _liveDevicesMap.remove(mid);

    return _unsubscribe().then((_) => liveDevice?.dispose()).then(
          (_) => _liveDevicesMap.isNotEmpty
              ? _subscribe(devices: _liveDevicesMap.values.toList())
              : Future.value(),
        );
  }

  Future<void> _unsubscribe() =>
      (_rabbitMQ?.dispose() ?? Future.value()).then((_) => _rabbitMQ = null);

  Future<void> _subscribe({Iterable<LiveDevice> devices}) {
    assert(devices != null, devices.isNotEmpty);

    return _unsubscribe().then(
      (_) => _getConnectionData(devices: devices).then(
            (data) => RabbitMQConnection.connect(connectionData: data).then(
                  (rabbitMQ) {
                    _rabbitMQ = rabbitMQ;
                    final queue = data["QueueName"];
                    devices.forEach((liveDevice) {
                      rabbitMQ.stompClient.subscribeJson(
                        liveDevice.id,
                        "/amq/queue/$queue",
                        (headers, value) => _onMessage(
                              mid: liveDevice.mid,
                              headers: headers,
                              value: value,
                            ),
                        matcher: liveDevice,
                      );
                    });
                  },
                ),
          ),
    );
  }

  void _onMessage({
    String mid,
    Map<String, String> headers,
    Map<String, dynamic> value,
  }) =>
      _liveDevicesMap[mid]?.onMessage(
        headers: headers,
        value: value,
      );

  Future<Map<String, dynamic>> _getConnectionData({
    Iterable<LiveDevice> devices = const [],
  }) =>
      _client
          .post(
            "/api/tools/liveconnect",
            data: List.unmodifiable(devices.map((f) => f.toRequest())),
          )
          .then((response) => response.data as Map<String, dynamic>)
          .catchError((_) => null);
}
