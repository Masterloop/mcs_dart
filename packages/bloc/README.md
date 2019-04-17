# Masterloop Bloc

## How to build

### Prerequisites

- [Dart SDK](https://www.dartlang.org/)

## Feedback

File bugs on [Masterloop Home](https://github.com/orgs/Masterloop/projects/1).

## License

Unless explicitly stated otherwise all files in this repository are licensed under the License in the root repository.

## Using the Masterloop Bloc

### Implemeted types:

- [TemplatesBloc](#templatesBloc)
- [DevicesBloc](#devicesBloc)
- [DeviceBloc](#devicebloc)
- [CommandsBloc](#commandsbloc)
- [ObservationsBloc](#observationsbloc)

## API:

### Bloc

#### Properties

stream of T

```
Stream<T> get state
```

current T

```
T get current
```

checking if bloc is disposed

```
bool get isDisposed
```

#### Methods

##### transforming stream

```
Stream<T> transform(Stream<S> stream)
```

##### dispatching updates

```
void dispatch(S state)
```

##### dispatching errors

```
void dispatchError(Object error, {StackTrace stackTrace})
```

##### dispose

```
void dispose()
```

## Mixins

### ListBloc

#### Methods

##### refreshing

calling onRefresh and dispatching the result

```
Future<void> refresh()
```

##### sorting

if comparator is null no sorting is applied

```
void sort(Comparator<T> comparator)
```

##### filtering

if tester is null no filtering is applied

```
  void filter(Test<T> tester)
```

### [TemplatesBloc](./lib/src/models/templates.dart)

extends Bloc<Iterable<Template>> with ListBloc

```
TemplatesBloc({
  //Called on templatesBloc.Refresh() and returns most updated list of templates
  Future<Iterable<Template>> onRefresh,
  //Comparator to use when sorting the templates
  Comparator<Template> comparator,
})
```

### [DevicesBloc](./lib/src/models/devices.dart)

extends Bloc<Iterable<Device>> with ListBloc

```
TemplatesBloc({
  //Called on devicesBloc.Refresh() and returns most updated list of devices
  Future<Iterable<Device>> onRefresh,
  //Comparator to use when sorting the devices
  Comparator<Device> comparator,
})
```

### [DeviceBloc](./lib/src/models/device.dart)

extends Bloc<Device>

```
DeviceBloc({
  //MID of device
  String mid,
  //Called on deviceBloc.Refresh() and returns most updated device
  ValueGetter<Future<Device>> onRefresh,
  //Implementation of send command
  SendCommand onSendCommand,
})
```

#### Methods

##### refreshing

```
Future<void> refresh()
```

##### sending commands

###### optional:

- arguments<br />
- expiresIn, defaults to 5 minutes

```
Future<bool> sendCommand({
  int id,
  Iterable<Map<String, dynamic>> arguments,
  Duration expiresIn = const Duration(minutes: 5),
})
```

### [CommandsBloc](<(./lib/src/models/commands.dart)>)

extends Bloc<Command> with ListBloc

```
CommandsBloc({
  //Called on commandsBloc.Refresh() and returns most updated commands, force update
  Future<Iterable<Command>> onRefresh,
  //Usually comming from deviceBloc.state.map((device)=> deivce.commands).distinct()
  Stream<Iterable<Command>> commands,
  //Comparator to use when sorting the commands
  Comparator<Command> comparator,
})
```

### [ObservationsBloc](./lib/src/models/observations.dart)

extends Bloc<ObservationState> with ListBloc

```
ObservationState({
    Observation observation;
    ObservationValue value;
})
```

```
ObservationsBloc({
  //Usually comming from observationsBloc.state.map((device)=> deivce.observations).distinct()
  Stream<Iterable<Observation>> observations,
  //Called on observationsBloc.Refresh() and returns most updated observations values, force update
  ValueGetter<Future<Iterable<ObservationValue>>> onRefresh,
  //Implemetation of subscribe
  SubscribeCallback<ObservationValue> subscribe,
  //Implemetation of unsubscribe
  UnsubscribeCallback unsubscribe,
  //Comparator to use when sorting the observations
  Comparator<ObservationState> comparator,
})
```

#### Methods

##### subscribing to observations

###### optional:

- init, indicates if values should be initialized

```
Future<void> subscribe({List<int> ids, bool init = false})
```

##### unsubscribing

```
Future<void> unsubscribe()
```
