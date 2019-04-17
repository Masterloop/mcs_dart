# Masterloop Bloc

## How to build

### Prerequisites

-Dart SDK

## Feedback

File bugs on [Masterloop Home](https://github.com/orgs/Masterloop/projects/1).

## License

Unless explicitly stated otherwise all files in this repository are licensed under the License in the root repository.

## Using the Masterloop Bloc

### Implemeted types:

- [TemplatesBloc](#templatesBloc)
- [DevicesBloc](#devicesBloc) <br/>
- [DeviceBloc](#devicebloc) <br/>
- [CommandsBloc](#commandsbloc) <br/>
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
Iterable<T> get current
```

checking if bloc is disposed

```
bool get isDisposed
```

### TemplatesBloc

extends Bloc<Iterable<Template>>

```
TemplatesBloc({
  //Called on templatesBloc.Refresh() and returns most updated list of templates
  Future<Iterable<Template>> onRefresh,
  //Comparator to use when sorting the templates
  Comparator<Template> comparator,
})
```

#### Methods

##### refreshing

```
Future<void> refresh()
```

##### sorting

if comparator is null no sorting is applied

```
void sort(Comparator<Template> comparator)
```

##### filtering

if tester is null no filtering is applied

```
  void filter(Test<Template> tester)
```

### DevicesBloc

extends Bloc<Iterable<Device>>

```
TemplatesBloc({
  //Called on devicesBloc.Refresh() and returns most updated list of devices
  Future<Iterable<Device>> onRefresh,
  //Comparator to use when sorting the devices
  Comparator<Device> comparator,
})
```

#### Methods

##### refreshing

```
Future<void> refresh()
```

##### sorting

if comparator is null no sorting is applied

```
void sort(Comparator<Device> comparator)
```

##### filtering

if tester is null no filtering is applied

```
  void filter(Test<Device> tester)
```

### DeviceBloc

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

-arguments<br />
-expiresIn, defaults to 5 minutes

```
Future<bool> sendCommand({
  int id,
  Iterable<Map<String, dynamic>> arguments,
  Duration expiresIn = const Duration(minutes: 5),
})
```

### CommandsBloc

extends Bloc<Command>

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

#### Methods

##### refreshing

```
Future<void> refresh()
```

##### sorting

if comparator is null no sorting is applied

```
void sort(Comparator<Command> comparator)
```

##### filtering

if tester is null no filtering is applied

```
  void filter(Test<Command> tester)
```

### ObservationsBloc

extends Bloc<ObservationState>

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

##### refreshing

```
Future<void> refresh()
```

##### sorting

if comparator is null no sorting is applied

```
void sort(Comparator<ObservationState> comparator)
```

##### filtering

if tester is null no filtering is applied

```
  void filter(Test<ObservationState> tester)
```

##### subscribing to observations

###### optional:

-init, indicates if values should be initialized

```
Future<void> subscribe({List<int> ids, bool init = false})
```

##### unsubscribing

```
Future<void> unsubscribe()
```
