import 'package:dio/dio.dart';
import 'package:masterloop_api/src/devices.dart';
import 'package:masterloop_core/masterloop_core.dart'
    show Value, CommandValue, Api;
import 'dart:async';

class DeviceHistoryApi implements Api {
  final String basePath;
  final Dio _client;
  final String mid;

  DeviceHistoryApi({
    Dio client,
    this.mid,
  })  : assert(client != null),
        assert(mid != null),
        _client = client,
        basePath = "${DevicesApi.basePath}/$mid/";

  Future<Iterable<CommandValue>> commands({
    DateTime from,
    DateTime to,
  }) {
    if (from == null) {
      from = DateTime.now();
    }
    if (to == null) {
      to = from.add(const Duration(days: 90));
    }

    _validateDuration(from, to);

    return _client
        .get("$basePath/commands?fromTimestamp=$from&toTimestamp=$to")
        .then(
          (response) => List<CommandValue>.unmodifiable(
                response.data.map((v) => CommandValue.fromJson(v)),
              ),
        );
  }

  Future<Iterable<Value>> observation({
    int id,
    DateTime from,
    DateTime to,
  }) {
    assert(id != null);

    if (from == null) {
      from = DateTime.now();
    }
    if (to == null) {
      to = from.add(const Duration(days: 90));
    }

    _validateDuration(from, to);

    return _client
        .get(
            "$basePath/observations/$id/observations?fromTimestamp=$from&toTimestamp=$to")
        .then(
          (response) => List<Value>.unmodifiable(
                response.data.map((v) => Value.fromJson(v)),
              ),
        );
  }

  void _validateDuration(DateTime from, DateTime to) {
    final diff = from.difference(to).abs();
    if (diff > Duration(days: 90))
      throw UnsupportedError(
          "Can't fetch history for more than 90 days, you tried to fetch ${diff.inDays}");
  }
}
