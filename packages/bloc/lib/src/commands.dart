import 'dart:async';

import 'package:masterloop_bloc/src/base.dart';
import 'package:masterloop_bloc/src/bloc_list.dart';
import 'package:masterloop_bloc/src/device.dart';
import 'package:masterloop_bloc/src/state.dart';
import 'package:masterloop_core/masterloop_core.dart' show Command, Predicate;

class CommandsBloc extends BaseBloc<CommandsEvent, Iterable<Command>>
    with ListBloc {
  final DeviceBloc _bloc;

  CommandsBloc({
    DeviceBloc bloc,
  })  : assert(bloc != null),
        _bloc = bloc;

  @override
  Stream<BlocState<Iterable<Command>>> mapEventToState(
      CommandsEvent event) async* {
    switch (event.runtimeType) {
      case RefreshCommandsEvent:
        final completer = (event as RefreshCommandsEvent).completer;

        final refresh = RefreshDeviceEvent();
        _bloc.dispatch(refresh);
        await refresh.completer.future;

        yield BlocState(
          data: await _bloc.state
              .take(1)
              .map((s) => s.data)
              .single
              .then((device) => device.template.commands)
              .whenComplete(completer.complete)
              .catchError(completer.completeError),
        );
        break;

      case SendCommandEvent:
        final sendCommandEvent = event as SendCommandEvent;
        final completer = sendCommandEvent.completer;

        _bloc.api
            .sendCommand(
              id: sendCommandEvent.id,
              arguments: sendCommandEvent.arguments,
              expiresIn: sendCommandEvent.expiresIn,
            )
            .then((_) => completer.complete(true))
            .catchError((_) => completer.complete(false));
        break;

      case FilterCommandsEvent:
      case SortCommandsEvent:
        yield* super.mapEventToState(event);
        break;
    }
  }
}

abstract class CommandsEvent implements ListEvent {}

class RefreshCommandsEvent implements CommandsEvent {
  final Completer completer = Completer();
}

class SendCommandEvent implements CommandsEvent {
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

class FilterCommandsEvent extends FilterListEvent<Command>
    implements CommandsEvent {
  FilterCommandsEvent({
    Predicate<Command> tester,
  }) : super(tester: tester);
}

class SortCommandsEvent extends SortListEvent<Command>
    implements CommandsEvent {
  SortCommandsEvent({
    Comparator<Command> comparator,
  }) : super(comparator: comparator);
}
