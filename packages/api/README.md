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

### MasterloopApi

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

##### devices

```
DevicesApi get devices
```

##### templates

```
DevicesApi get templates
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
