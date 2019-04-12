import 'package:masterloop_core/core.dart'
    show
        Observation,
        ObservationValue,
        SubscribeCallback,
        UnsubscribeCallback,
        ValueGetter;
import 'package:masterloop_core_bloc/core_bloc.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

class ObservationsBloc extends TransformedBloc<Map<int, ObservationValue>,
        Iterable<ObservationState>>
    with ListBloc<Map<int, ObservationValue>, ObservationState> {
  final ValueGetter<Future<Iterable<ObservationValue>>> _onRefresh;
  final Stream<Iterable<Observation>> _observations;
  final SubscribeCallback<ObservationValue> _subscribe;
  final UnsubscribeCallback _unsubscribe;

  StreamSubscription _subscription;

  ValueGetter<Future<Map<int, ObservationValue>>> get onRefresh =>
      () => _onRefresh().then(
            (values) => values == null
                ? null
                : Map.fromEntries(
                    values.map(
                      (v) => MapEntry(v.id, v),
                    ),
                  ),
          );

  ObservationsBloc({
    Stream<Iterable<Observation>> observations,
    ValueGetter<Future<Iterable<ObservationValue>>> onRefresh,
    SubscribeCallback<ObservationValue> subscribe,
    UnsubscribeCallback unsubscribe,
    Comparator<ObservationState> comparator,
  })  : assert(observations != null),
        assert(onRefresh != null),
        assert(subscribe != null),
        assert(unsubscribe != null),
        _observations = observations,
        _onRefresh = onRefresh,
        _subscribe = subscribe,
        _unsubscribe = unsubscribe,
        super() {
    if (comparator != null) {
      sort(comparator);
    }
  }

  @override
  void dispose() {
    super.dispose();

    _subscription?.cancel();
    _subscription = null;
  }

  @override
  Stream<Iterable<ObservationState>> transform(
    Stream<Map<int, ObservationValue>> stream,
  ) =>
      Observable.combineLatest2<Iterable<Observation>,
          Map<int, ObservationValue>, Iterable<ObservationState>>(
        _observations,
        stream,
        (
          observations,
          values,
        ) =>
            observations == null
                ? null
                : List.unmodifiable(
                    observations
                        .map(
                          (o) => ObservationState(
                              observation: o, value: (values ?? {})[o.id]),
                        )
                        .toList(),
                  ),
      ).distinct();

  Future<void> subscribe({List<int> ids, bool init = false}) {
    _subscription?.cancel();

    return _subscribe(ids, init).then((stream) {
      _subscription = stream.listen(_onValue);
    });
  }

  Future<void> unsubscribe() =>
      _unsubscribe().then((_) => _subscription?.cancel());

  void _onValue(ObservationValue value) {
    final values = current ?? {};

    values[value.id] = value;

    dispatch(Map.from(values));
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
