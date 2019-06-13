import 'dart:async';

import 'package:masterloop_api/masterloop_api.dart' show DeviceApi;
import 'package:masterloop_bloc/src/base.dart';
import 'package:masterloop_bloc/src/state.dart';
import 'package:masterloop_core/masterloop_core.dart' show Device;

class DeviceBloc extends BaseBloc<DeviceEvent, Device> {
  final DeviceApi api;

  String get mid => api.mid;

  DeviceBloc({
    this.api,
  }) : assert(api != null);

  @override
  Stream<BlocState<Device>> mapEventToState(DeviceEvent event) async* {
    switch (event.runtimeType) {
      case RefreshDeviceEvent:
        final completer = (event as RefreshDeviceEvent).completer;

        yield BlocState(
          data: await api.details.catchError(completer.completeError),
        );

        completer.complete();
        break;
    }
  }
}

abstract class DeviceEvent {}

class RefreshDeviceEvent implements DeviceEvent {
  final Completer completer = Completer();
}
