import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:masterloop_api/masterloop_api.dart' show DeviceApi;
import 'package:masterloop_core/masterloop_core.dart' show Device;

class DeviceBloc extends Bloc<DeviceEvent, Device> {
  final String mid;
  final DeviceApi _api;

  DeviceBloc({
    this.mid,
    DeviceApi api,
  })  : assert(mid != null),
        assert(api != null),
        _api = api;

  @override
  Device get initialState => null;

  @override
  Stream<Device> mapEventToState(DeviceEvent event) async* {
    switch (event.runtimeType) {
      case RefreshDeviceEvent:
        final completer = (event as RefreshDeviceEvent).completer;

        yield await _api.details
            .whenComplete(completer.complete)
            .catchError(completer.completeError);
        break;

      case SendCommandEvent:
        final sendCommandEvent = event as SendCommandEvent;
        final completer = sendCommandEvent.completer;

        _api
            .sendCommand(
              id: sendCommandEvent.id,
              arguments: sendCommandEvent.arguments,
              expiresIn: sendCommandEvent.expiresIn,
            )
            .then((_) => completer.complete(true))
            .catchError((_) => completer.complete(false));
        break;
    }
  }
}

abstract class DeviceEvent {}

class RefreshDeviceEvent implements DeviceEvent {
  final Completer completer = Completer();
}

class SendCommandEvent implements DeviceEvent {
  final Completer<bool> completer = Completer();

  final int id;
  final Iterable<Map<String, dynamic>> arguments;
  final Duration expiresIn;

  SendCommandEvent({
    this.id,
    this.arguments,
    this.expiresIn,
  }) : assert(id != null);
}
