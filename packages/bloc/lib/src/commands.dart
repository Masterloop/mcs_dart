import 'dart:async';

import 'package:masterloop_bloc/src/bloc_list.dart';
import 'package:masterloop_bloc/src/device.dart';
import 'package:masterloop_bloc/src/state.dart';
import 'package:masterloop_core/masterloop_core.dart' show Command;

class CommandsBloc extends ListBloc<Command> {
  final DeviceBloc _bloc;

  CommandsBloc({
    DeviceBloc bloc,
  })  : assert(bloc != null),
        _bloc = bloc;

  @override
  Stream<BlocState<Iterable<Command>>> mapEventToState(
      ListEvent<Command> event) async* {
    switch (event.runtimeType) {
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

      case FilterListEvent:
      case SortListEvent:
      case RefreshListEvent:
        yield* super.mapEventToState(event);
        break;
    }
  }

  @override
  Future<Iterable<Command>> refresh([RefreshListEvent event]) async {
    final completer = event.completer;

    final refresh = RefreshDeviceEvent();
    _bloc.dispatch(refresh);
    await refresh.completer.future.catchError(completer.completeError);

    return await _bloc.state
        .take(1)
        .map((s) => s.data)
        .single
        .then((device) => device.template.commands);
  }
}

abstract class CommandsEvent implements ListEvent<Command> {}

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
