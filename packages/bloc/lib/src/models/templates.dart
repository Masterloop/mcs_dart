import 'package:masterloop_bloc/src/bloc/bloc_list.dart';
import 'package:masterloop_core/masterloop_core.dart' show Template;
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:masterloop_api/masterloop_api.dart' show TemplatesApi;

class TemplatesBloc extends Bloc<TemplatesEvent, Iterable<Template>>
    with ListBloc<TemplatesEvent, Template> {
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
      case RefreshTemplates:
        yield await _api.all;
        break;
    }
  }
}

abstract class TemplatesEvent implements ListEvent {}

class RefreshTemplates implements TemplatesEvent {}
