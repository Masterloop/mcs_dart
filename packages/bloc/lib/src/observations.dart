import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:masterloop_api/masterloop_api.dart' show DeviceApi;
import 'package:masterloop_bloc/src/bloc_list.dart';
import 'package:masterloop_bloc/src/state.dart';
import 'package:masterloop_core/masterloop_core.dart'
    show Observation, ObservationValue, Predicate;

class ObservationsBloc
    extends Bloc<ObservationsEvent, BlocState<Iterable<ObservationState>>>
    with ListBloc {
  final DeviceApi _api;

  ObservationsBloc({
    DeviceApi api,
  })  : assert(api != null),
        _api = api;

  @override
  BlocState<Iterable<ObservationState>> get initialState => BlocState();

  @override
  void dispose() {
    _api.unsubscribe();

    super.dispose();
  }

  @override
  Stream<BlocState<Iterable<ObservationState>>> mapEventToState(
      ObservationsEvent event) async* {
    switch (event.runtimeType) {
      case RefreshObservationsEvent:
        final completer = (event as RefreshObservationsEvent).completer;

        final observations = await _api.template
            .then(
              (template) => template.observations,
            )
            .catchError(completer.completeError);
        final values = await _api.current
            .then(
              (values) => Map.fromEntries(
                    values.map(
                      (v) => MapEntry<int, ObservationValue>(v.id, v),
                    ),
                  ),
            )
            .catchError(completer.completeError);

        yield BlocState(
          data: observations.map(
            (o) => ObservationState(
                  observation: o,
                  value: values[o.id],
                ),
          ),
        );

        completer.complete();
        break;

      case SubscribeObservationsEvent:
        final stream = await _api.subscribe(
          observations: (event as SubscribeObservationsEvent).ids,
          init: (event as SubscribeObservationsEvent).init,
        );

        yield* stream
            .where((v) => v is ObservationValue)
            .cast<ObservationValue>()
            .map(
              (value) => BlocState(
                    data: List<ObservationState>.from(currentState.data).map(
                      (o) {
                        if (o.observation.id == value.id) {
                          return ObservationState(
                            observation: o.observation,
                            value: value,
                          );
                        } else {
                          return o;
                        }
                      },
                    ),
                  ),
            );
        break;

      case UnsubscribeObservationsEvent:
        await _api.unsubscribe();
        break;

      case FilterObservationsEvent:
      case SortObservationsEvent:
        yield* super.mapEventToState(event);
        break;
    }
  }
}

class ObservationState {
  final Observation observation;
  final ObservationValue value;

  ObservationState({
    this.observation,
    this.value,
  }) : assert(observation != null);

  @override
  bool operator ==(other) =>
      other is ObservationState &&
      other.observation == observation &&
      other.value == value;

  @override
  int get hashCode => observation.hashCode ^ value.hashCode;
}

abstract class ObservationsEvent implements ListEvent {}

class RefreshObservationsEvent implements ObservationsEvent {
  final Completer completer = Completer();
}

class FilterObservationsEvent extends FilterListEvent<ObservationState>
    implements ObservationsEvent {
  FilterObservationsEvent({
    Predicate<ObservationState> tester,
  }) : super(tester: tester);
}

class SortObservationsEvent extends SortListEvent<ObservationState>
    implements ObservationsEvent {
  SortObservationsEvent({
    Comparator<ObservationState> comparator,
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
