import 'dart:async';
import 'package:stomp/stomp.dart';
import 'package:masterloop_core/core.dart'
    show LiveValue, ObservationValue, CommandValue;

class LiveDevice implements Matcher {
  final StreamController<LiveValue> _liveController =
      StreamController.broadcast();

  final String mid;
  final Iterable<int> observations;
  final Iterable<int> commands;
  final bool init;

  String get id => "$mid-subscription";

  Stream<LiveValue> get stream => _liveController.stream;

  bool get isEmpty =>
      observations?.isEmpty == true && commands?.isEmpty == true;

  LiveDevice({
    this.mid,
    this.observations,
    this.commands,
    this.init = true,
  }) : assert(mid != null);

  void dispose() {
    _liveController.close();
  }

  void onMessage({Map<String, dynamic> headers, Map<String, dynamic> value}) {
    assert(headers != null);
    assert(value != null);

    final String destination = headers["destination"];
    final List<String> valueInfo = destination.split("/").last.split(".");

    String timestamp = value["Timestamp"];
    if (timestamp.length >= 28) {
      timestamp = timestamp.substring(0, 26) + "Z";
    }

    onValue(
      id: int.parse(valueInfo.last),
      type: valueInfo[1],
      value: value["Value"],
      timestamp: DateTime.parse(timestamp),
    );
  }

  void onValue({int id, String type, dynamic value, DateTime timestamp}) {
    assert(id != null);
    assert(type != null);
    assert(value != null);

    final Value = _createValue(
      id: id,
      type: type,
      value: value,
      timestamp: timestamp,
    );

    _liveController.add(Value);
  }

  LiveValue _createValue({
    int id,
    String type,
    dynamic value,
    DateTime timestamp,
  }) {
    assert(id != null);
    assert(type != null);
    assert(value != null);

    switch (type) {
      case "O":
        return ObservationValue(
          id: id,
          value: value,
          timestamp: timestamp,
        );

      case "C":
        return CommandValue(
          id: id,
          timestamp: timestamp,
        );

      default:
        throw Exception("Cant create Value of type $type");
    }
  }

  Map<String, dynamic> toRequest() => {
        "MID": mid,
        "ConnectAllObservations": observations == null,
        "ConnectAllCommands": commands == null,
        "InitObservationValues": init,
        "ObservationIds": observations,
        "CommandIds": commands
      };

  @override
  bool matches(String pattern, String destination) =>
      destination.split("/").last.split(".").first == mid;

  @override
  String toString() =>
      "LiveDevice: $mid, watching: { observations: $observations, commands: $commands }";
}
