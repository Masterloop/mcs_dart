import 'package:masterloop_core/core.dart'
    show Command, ValueGetter, StreamBloc, ListBloc;
import 'dart:async';

class CommandsBloc extends StreamBloc<Iterable<Command>> with ListBloc {
  @override
  final ValueGetter<Future<Iterable<Command>>> onRefresh;

  CommandsBloc({
    this.onRefresh,
    Stream<Iterable<Command>> commands,
    Comparator<Command> comparator,
  })  : assert(onRefresh != null),
        super(stream: commands) {
    if (comparator != null) {
      sort(comparator);
    }
  }
}
