import 'package:masterloop_bloc/src/bloc_list.dart';
import 'package:masterloop_core/masterloop_core.dart' show Predicate, Template;
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:masterloop_api/masterloop_api.dart' show TemplatesApi;

class TemplatesBloc extends Bloc<TemplatesEvent, Iterable<Template>>
    with ListBloc {
  final TemplatesApi _api;

  TemplatesBloc({
    TemplatesApi api,
  })  : assert(api != null),
        _api = api;

  @override
  Iterable<Template> get initialState => null;

  @override
  Stream<Iterable<Template>> mapEventToState(TemplatesEvent event) async* {
    switch (event.runtimeType) {
      case RefreshTemplatesEvent:
        final completer = (event as RefreshTemplatesEvent).completer;

        yield await _api.all
            .whenComplete(completer.complete)
            .catchError(completer.completeError);
        break;

      case FilterTemplatesEvent:
      case SortTemplatesEvent:
        super.mapEventToState(event);
        break;
    }
  }
}

abstract class TemplatesEvent implements ListEvent {}

class RefreshTemplatesEvent implements TemplatesEvent {
  final Completer completer = Completer();
}

class FilterTemplatesEvent extends FilterListEvent<Template>
    implements TemplatesEvent {
  FilterTemplatesEvent({
    Predicate<Template> tester,
  }) : super(tester: tester);
}

class SortTemplatesEvent extends SortListEvent<Template>
    implements TemplatesEvent {
  SortTemplatesEvent({
    Comparator<Template> comparator,
  }) : super(comparator: comparator);
}
