import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:masterloop_api/masterloop_api.dart' show DeviceApi;
import 'package:masterloop_bloc/src/bloc_list.dart';
import 'package:masterloop_bloc/src/state.dart';
import 'package:masterloop_core/masterloop_core.dart' show Command, Predicate;

class CommandsBloc extends Bloc<CommandsEvent, BlocState<Iterable<Command>>>
    with ListBloc {
  final DeviceApi _api;

  CommandsBloc({
    DeviceApi api,
  })  : assert(api != null),
        _api = api;

  @override
  BlocState<Iterable<Command>> get initialState => BlocState();

  @override
  Stream<BlocState<Iterable<Command>>> mapEventToState(
      CommandsEvent event) async* {
    switch (event.runtimeType) {
      case RefreshCommandsEvent:
        final completer = (event as RefreshCommandsEvent).completer;

        yield BlocState(
          data: await _api.template
              .then((template) => template.commands)
              .whenComplete(completer.complete)
              .catchError(completer.completeError),
        );
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

      case FilterCommandsEvent:
      case SortCommandsEvent:
        super.mapEventToState(event);
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
