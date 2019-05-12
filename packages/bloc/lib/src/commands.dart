import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:masterloop_api/masterloop_api.dart' show DeviceApi;
import 'package:masterloop_bloc/src/bloc_list.dart';
import 'package:masterloop_core/masterloop_core.dart' show Command, Predicate;

class CommandsBloc extends Bloc<CommandsEvent, Iterable<Command>>
    with ListBloc {
  final DeviceApi _api;

  CommandsBloc({
    DeviceApi api,
  })  : assert(api != null),
        _api = api;

  @override
  Iterable<Command> get initialState => null;

  @override
  Stream<Iterable<Command>> mapEventToState(CommandsEvent event) async* {
    switch (event.runtimeType) {
      case RefreshCommandsEvent:
        final completer = (event as RefreshCommandsEvent).completer;

        yield await _api.template
            .then((template) => template.commands)
            .whenComplete(completer.complete)
            .catchError(completer.completeError);
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
