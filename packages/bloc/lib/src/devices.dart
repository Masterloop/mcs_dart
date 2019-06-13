import 'dart:async';

import 'package:masterloop_api/masterloop_api.dart' show DevicesApi;
import 'package:masterloop_bloc/src/base.dart';
import 'package:masterloop_bloc/src/bloc_list.dart';
import 'package:masterloop_bloc/src/state.dart';
import 'package:masterloop_core/masterloop_core.dart' show Device, Predicate;

class DevicesBloc extends BaseBloc<DevicesEvent, Iterable<Device>>
    with ListBloc {
  final DevicesApi api;

  DevicesBloc({
    this.api,
  }) : assert(api != null);

  @override
  Stream<BlocState<Iterable<Device>>> mapEventToState(
      DevicesEvent event) async* {
    switch (event.runtimeType) {
      case RefreshDevicesEvent:
        final refresh = event as RefreshDevicesEvent;
        final completer = refresh.completer;
        final tid = refresh.tid;

        if (tid == null) {
          yield BlocState(
            data: await api
                .all()
                .whenComplete(completer.complete)
                .catchError(completer.completeError),
          );
        } else {
          yield BlocState(
            data: await api
                .template(tid: tid)
                .whenComplete(completer.complete)
                .catchError(completer.completeError),
          );
        }
        break;

      case FilterDevicesEvent:
      case SortDevicesEvent:
        yield* super.mapEventToState(event);
        break;
    }
  }
}

abstract class DevicesEvent implements ListEvent {}

class RefreshDevicesEvent implements DevicesEvent {
  final Completer completer = Completer();
  final String tid;

  RefreshDevicesEvent({this.tid});
}

class FilterDevicesEvent extends FilterListEvent<Device>
    implements DevicesEvent {
  FilterDevicesEvent({
    Predicate<Device> tester,
  }) : super(tester: tester);
}

class SortDevicesEvent extends SortListEvent<Device> implements DevicesEvent {
  SortDevicesEvent({
    Comparator<Device> comparator,
  }) : super(comparator: comparator);
}
