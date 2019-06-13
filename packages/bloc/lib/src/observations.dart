import 'dart:async';

import 'package:masterloop_bloc/src/base.dart';
import 'package:masterloop_bloc/src/bloc_list.dart';
import 'package:masterloop_bloc/src/device.dart';
import 'package:masterloop_bloc/src/state.dart';
import 'package:masterloop_core/masterloop_core.dart'
    show Observation, ObservationValue, Predicate, DataType;
import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';

class ObservationsBloc
    extends BaseBloc<ObservationsEvent, Iterable<ObservationWithValue>>
    with ListBloc {
  final BehaviorSubject<bool> _subscribedSubject =
      BehaviorSubject.seeded(false);
  final DeviceBloc _bloc;

  bool get isSubscribed => _subscribedSubject.value;
  Stream<bool> get onSubscribedChanged => _subscribedSubject.distinct();

  ObservationsBloc({
    DeviceBloc bloc,
  })  : assert(bloc != null),
        _bloc = bloc;

  @override
  void dispose() {
    _subscribedSubject
      ..add(false)
      ..close();
    _bloc.api.unsubscribe();

    super.dispose();
  }

  @override
  Stream<BlocState<Iterable<ObservationWithValue>>> mapEventToState(
    ObservationsEvent event,
  ) async* {
    switch (event.runtimeType) {
      case RefreshObservationsEvent:
        final completer = (event as RefreshObservationsEvent).completer;

        final refresh = RefreshDeviceEvent();
        _bloc.dispatch(refresh);
        await refresh.completer.future;

        final jobs = await Future.wait([
          _bloc.state.take(1).map((s) => s.data).single.then(
                (device) => device.template.observations,
              ),
          _bloc.api.current.then(
            (values) => Map.fromEntries(
                  values.map(
                    (v) => MapEntry<int, ObservationValue>(v.id, v),
                  ),
                ),
          ),
        ]).catchError(completer.completeError);

        final observations = jobs[0] as Iterable<Observation>;
        final values = jobs[1] as Map<int, ObservationValue>;

        yield BlocState(
          data: List.unmodifiable(
            observations.map(
              (o) => ObservationWithValue.from(
                    observation: o,
                    value: values[o.id],
                  ),
            ),
          ),
        );

        completer.complete();
        break;

      case SubscribeObservationsEvent:
        _subscribedSubject.add(true);
        final stream = await _bloc.api.subscribe(
          observations: (event as SubscribeObservationsEvent).ids,
          init: (event as SubscribeObservationsEvent).init,
        );

        Observable(stream)
            .where((v) => v is ObservationValue)
            .cast<ObservationValue>()
            .withLatestFrom(
          state.map(
            (observations) => Map.fromEntries(
                  observations.data.map((o) => MapEntry(o.id, o)),
                ),
          ),
          (value, Map<int, ObservationWithValue> observations) {
            observations[value.id] = ObservationWithValue.from(
              observation: observations[value.id],
              value: value,
            );

            return SetObservationsEvent(
              observations: List<ObservationWithValue>.from(
                observations.values,
              ),
            );
          },
        ).forEach(dispatch);
        break;

      case UnsubscribeObservationsEvent:
        _subscribedSubject.add(false);
        await _bloc.api.unsubscribe();
        break;

      case SetObservationsEvent:
        yield BlocState(
          data: (event as SetObservationsEvent).observations,
        );
        break;

      case FilterObservationsEvent:
      case SortObservationsEvent:
        yield* super.mapEventToState(event);
        break;
    }
  }
}

class ObservationWithValue<T> extends Observation {
  final T value;
  final DateTime timestamp;

  ObservationWithValue({
    int id,
    String name,
    String description,
    DataType dataType,
    this.value,
    this.timestamp,
  }) : super(
          id: id,
          name: name,
          description: description,
          dataType: dataType,
        );

  ObservationWithValue.from({
    Observation observation,
    ObservationValue value,
  })  : value = value?.value,
        timestamp = value?.timestamp,
        super(
          id: observation.id,
          name: observation.name,
          description: observation.description,
          dataType: observation.dataType,
        );

  @override
  bool operator ==(other) =>
      other is ObservationWithValue &&
      super == other &&
      other.value == value &&
      other.timestamp == timestamp;

  @override
  int get hashCode => super.hashCode ^ value.hashCode ^ timestamp.hashCode;
}

abstract class ObservationsEvent implements ListEvent {}

class SetObservationsEvent implements ObservationsEvent {
  final Iterable<ObservationWithValue> observations;

  SetObservationsEvent({this.observations});
}

class RefreshObservationsEvent implements ObservationsEvent {
  final Completer completer = Completer();
}

class FilterObservationsEvent extends FilterListEvent<ObservationWithValue>
    implements ObservationsEvent {
  FilterObservationsEvent({
    Predicate<ObservationWithValue> tester,
  }) : super(tester: tester);
}

class SortObservationsEvent extends SortListEvent<ObservationWithValue>
    implements ObservationsEvent {
  SortObservationsEvent({
    Comparator<ObservationWithValue> comparator,
  }) : super(comparator: comparator);
}

class SubscribeObservationsEvent implements ObservationsEvent {
  final Iterable<int> ids;
  final bool init;

  SubscribeObservationsEvent({
    this.ids,
    this.init = false,
  }) : assert(init != null);
}

class UnsubscribeObservationsEvent implements ObservationsEvent {}
