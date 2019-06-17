import 'dart:async';

import 'package:masterloop_api/masterloop_api.dart' show DevicesApi;
import 'package:masterloop_bloc/src/base.dart';
import 'package:masterloop_bloc/src/bloc_list.dart';
import 'package:masterloop_core/masterloop_core.dart' show Device;

class DevicesBloc extends ListBloc<Device> {
  final DevicesApi api;

  DevicesBloc({
    this.api,
  }) : assert(api != null);

  @override
  Future<Iterable<Device>> refresh([RefreshListEvent event]) {
    final refresh = event as RefreshDevicesEvent;
    final tid = refresh.tid;

    if (tid == null) {
      return api.all();
    } else {
      return api.template(tid: tid);
    }
  }
}

abstract class DevicesEvent implements ListEvent<Device> {}

class RefreshDevicesEvent with WithCompleter implements DevicesEvent {
  final String tid;

  RefreshDevicesEvent({this.tid});
}
