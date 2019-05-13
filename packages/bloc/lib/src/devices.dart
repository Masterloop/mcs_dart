import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:masterloop_api/masterloop_api.dart' show DevicesApi;
import 'package:masterloop_bloc/src/bloc_list.dart';
import 'package:masterloop_bloc/src/state.dart';
import 'package:masterloop_core/masterloop_core.dart' show Device, Predicate;

class DevicesBloc extends Bloc<DevicesEvent, BlocState<Iterable<Device>>>
    with ListBloc {
  final DevicesApi _api;

  DevicesBloc({
    DevicesApi api,
  })  : assert(api != null),
        _api = api;

  @override
  BlocState<Iterable<Device>> get initialState => BlocState();

  @override
  Stream<BlocState<Iterable<Device>>> mapEventToState(
      DevicesEvent event) async* {
    switch (event.runtimeType) {
      case RefreshDevicesEvent:
        final completer = (event as RefreshDevicesEvent).completer;

        yield BlocState(
          data: await _api
              .all()
              .whenComplete(completer.complete)
              .catchError(completer.completeError),
        );
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
