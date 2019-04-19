# Masterloop API

## How to build

### Prerequisites

- [Dart SDK](https://www.dartlang.org/)

## Feedback

File bugs on [Masterloop Home](https://github.com/orgs/Masterloop/projects/1).

## License

Unless explicitly stated otherwise all files in this repository are licensed under the License in the root repository.

## Using the Masterloop API

### Contens:

- [MasterloopApi](#masterloopapi)
- [TemplatesApi](#templatesapi)
- [DevicesApi](#devicesapi)
- [DeviceApi](#deviceapi)
- [DeviceHistoryApi](#devicehistoryapi)

### [MasterloopApi](./lib/src/masterloop.dart)

###### optional:

- client, default Dio with `BaseOptions(connectTimeout: 30000, receiveTimeout: 30000)`
- host, default https://api.masterloop.net

```
MasterloopApi({
    Dio client,
    String host,
})
```

#### Properties

##### templates

```
DevicesApi get templates
```

##### devices

```
DevicesApi get devices
```

#### Methods

##### connect

```
Future<void> connect({
    String username,
    String password,
})
```

##### disconnect

```
Future<void> disconnect()
```

### [TemplatesApi](./lib/src/templates.dart)

client must be authenticated, with access token.

```
TemplatesApi({
    Dio client,
})
```

#### Operators

##### get [tid]

```
Future<Template> operator [](String tid)
```

#### Methods

##### devices

returns all devices of tid

```
Future<Iterable<Device>> devices({
    String tid,
})
```

### [DevicesApi](./lib/src/devices.dart)

client must be authenticated, with access token.

```
DevicesApi({
    Dio client,
})
```

#### Operators

##### get device api

```
DeviceApi operator [](String mid)
```

#### Methods

##### get all devices

returns all devices

###### optional:

- metadata, defualt false
- details, default false

```
Future<Iterable<Device>> all({
    bool metadata = false,
    bool details = false,
})
```

### [DeviceApi](./lib/src/device.dart)

client must be authenticated, with access token.

```
DeviceApi({
    Dio client,
})
```

#### Parameters

##### get device details

```
Future<Device> get details
```

##### get device with secure details

```
Future<Device> get secureDetails
```

##### get device's template

```
Future<Template> get template
```

##### get device's current observation's values

```
Future<Iterable<ObservationValue>> get current
```

##### get device history api

```
DeviceHistoryApi get history
```

#### Methods

##### send command to device

###### optional:

- arguments
- expiresIn, defualt 5 minutes

```
Future<bool> sendCommand({
    int id,
    Iterable<Map<String, dynamic>> arguments,
    Duration expiresIn = const Duration(minutes: 5),
})
```

##### subscribe to observations/commands

###### optional:

- observations, default all. if passed null all observations will be included, for none pass empty array
- commands, default none. if passed null all commands will be included, for none pass empty array
- init, defualt true

```
Future<Stream<LiveValue>> subscribe({
    Iterable<int> observations,
    Iterable<int> commands = const [],
    bool init = true,
})
```

##### unsubscribe from all observations/commands

```
Future<void> unsubscribe()
```

### [DeviceHistoryApi](./lib/src/device_history.dart)

client must be authenticated, with access token.

```
DeviceHistoryApi({
    Dio client,
})
```

#### Operators

##### get device api

```
DeviceApi operator [](String mid)
```

#### Methods

##### get commands history

difference cant be grater than 90 days

###### optional:

- from, defualt DateTime.now()
- to, default from + 90 days

```
Future<Iterable<CommandValue>> commands({
    DateTime from,
    DateTime to,
})
```

##### get observation history

difference cant be grater than 90 days

###### optional:

- from, defualt DateTime.now()
- to, default from + 90 days

```
Future<Iterable<Value>> observation({
    int id,
    DateTime from,
    DateTime to,
})
```
