import 'package:masterloop_bloc/src/bloc_list.dart';
import 'package:masterloop_core/masterloop_core.dart' show Template;
import 'dart:async';
import 'package:masterloop_api/masterloop_api.dart' show TemplatesApi;

class TemplatesBloc extends ListBloc<Template> {
  final TemplatesApi api;

  TemplatesBloc({
    this.api,
  }) : assert(api != null);

  @override
  Future<Iterable<Template>> refresh([RefreshListEvent event]) => api.all;
}
