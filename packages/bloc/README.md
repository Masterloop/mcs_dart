# Masterloop Bloc

## How to build

### Prerequisites

-Dart SDK

## Feedback

File bugs on [Masterloop Home](https://github.com/orgs/Masterloop/projects/1).

## License

Unless explicitly stated otherwise all files in this repository are licensed under the License in the root repository.

## Using the Masterloop Bloc

Implemeted types:
-TemplatesBloc
-DeviceBloc
-DevicesBloc
-CommandsBloc
-ObservationsBloc

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

### TemplatesBloc, DevicesBloc\*

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

refreshing

```
Future<void> refresh()
```

sorting

```
void sort(Comparator<Template> comparator)
```

filtering

```
  void filter(Test<Template> tester)
```

##### \*for Devices Bloc use type DevicesBloc and Device types

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

refreshing

```
Future<void> refresh()
```

sending commands

##### optional:

-arguments<br />
-expiresIn, defaults to 5 minutes

```
Future<bool> sendCommand({
    int id,
    Iterable<Map<String, dynamic>> arguments,
    Duration expiresIn = const Duration(minutes: 5),
  })
```
