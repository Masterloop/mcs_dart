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

##### get [mid]

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
